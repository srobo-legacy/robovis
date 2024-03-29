#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <fcntl.h>
#include <poll.h>
#include <unistd.h>

#include "hueblobs.h"

#ifdef OPENCV
#include <cv.h>
#include <highgui.h>
#endif

#include "visfunc.h"

#define UNUSED(x) ((x) = (x))

#define DEBUG 0
#define ERROR 1

#define IN_FILENAME "in.png"
#define OUT_FILENAME "out.bmp"

const unsigned int MINMASS = 200;
const unsigned int MAXMASS = 2000;

#define CAMWIDTH 320
#define CAMHEIGHT 240

#ifdef OPENCV
IplImage *frame = NULL, *oldframe = NULL, *hsv, *hue, *sat, *val;
#endif

int DEBUGOUTPUT = 0;
int DEBUGDISPLAY = 0;
int DEBUGSLOW = 0;

extern "C" {
#include "v4l.h"
}

//grab the command line options and set them where appropriate
void
get_command_line_opts(int argc, char **argv)
{
	for(int i = 1; i < argc; i++) {
		// Skip argv[0] - this is the program name
		if (strcmp(argv[i], "-debug") == 0) {
			DEBUGOUTPUT = 1;
		} else if (strcmp(argv[i], "-display") == 0) {
			DEBUGDISPLAY = 1;
		} else if (strcmp(argv[i], "-slow") == 0) {
			DEBUGSLOW = 1;
		}
	}
	return;
}

/* Wait for a newline on stdin */
char
*wait_trigger(void)
{
	char *req_tag;

	req_tag = (char*)malloc(129);

	if (DEBUGDISPLAY && DEBUGSLOW) {
#ifdef OPENCV
		struct pollfd fd;

		do {
			fd.fd = STDIN_FILENO;
			fd.events = POLLIN;
			fd.revents = 0;

			if (poll(&fd, 1, 0)) {
				req_tag = fgets(req_tag, 128, stdin);
				if (req_tag == NULL)	/*EOF*/
					exit(0);

				return req_tag;
			}

			cvWaitKey(100);
		} while (1);
#endif
	} else {
		req_tag = fgets(req_tag, 128, stdin);
		if (req_tag == NULL)	/*EOF*/
			exit(0);

		return req_tag;
	}

	return 0;
}

void
srlog(char level, const char *m)
{
	if(DEBUGOUTPUT) {
		struct tm * tm;
		struct timeval tv;
		struct timezone tz;

		gettimeofday(&tv, &tz);
		tm = localtime(&tv.tv_sec);
		fprintf(stderr, "%02d:%02d:%02d.%d", tm->tm_hour, tm->tm_min,
						tm->tm_sec, (int) tv.tv_usec);

		switch(level){
			case DEBUG:
				fprintf(stderr, " - DEBUG - %s\n", m);
				break;
			case ERROR:
				fprintf(stderr, " - ERROR - %s\n", m);
		}
	} else if(level == ERROR) {
		fprintf(stderr, "%s\n", m);
	}
}

#ifdef OPENCV
void
Boo(int event, int x, int y, int flags, void *param)
{
	unsigned char *data;
	CvSize size;
	int step, r, g, b;

	UNUSED(event);
	UNUSED(flags);
	UNUSED(param);

	cvGetRawData(frame, &data, &step, &size);
	b = data[((y*step)+(x * 3))];
	g = data[(((y*step)+(x * 3)))+1];
	r = data[(((y*step)+(x * 3)))+1];
	printf("RGB %d,%d - %d %d %d\n", x, y, r, g, b);
}
void
Hoo(int event, int x, int y, int flags, void *param)
{
	unsigned char *data;
	CvSize size;
	int step, c;

	UNUSED(event);
	UNUSED(flags);
	UNUSED(param);

	cvGetRawData(val, &data, &step, &size);
	c = data[y*step+x];
	printf("Val %d,%d - %d\n", x, y, c);
}

void
Goo(int event, int x, int y, int flags, void* param)
{
	unsigned char *data;
	CvSize size;
	int step, c;

	UNUSED(event);
	UNUSED(flags);
	UNUSED(param);

	cvGetRawData(sat, &data, &step, &size);
	c = data[y*step+x];
	printf("Sat %d,%d - %d\n", x, y, c);
}

void
Foo(int event, int x, int y, int flags, void* param)
{
	unsigned char *data;
	CvSize size;
	int step, c;

	UNUSED(event);
	UNUSED(flags);
	UNUSED(param);

	cvGetRawData(hue, &data, &step, &size);
	c = data[y*step+x];
	printf("Hue %d,%d - %d\n", x, y, c);
}
#endif

int
main(int argc, char **argv)
{
	get_command_line_opts(argc, argv);
#ifdef OPENCV
	CvSize framesize;
#endif
	FILE *fifo_out;
	uint8_t *raw_data, *shm_ptr, *gui_data;
	struct blob_position *blobs;
	char *req_tag = NULL;
	int i, w, h, shm_fd, fifo_fd;

	open_webcam(CAMWIDTH, CAMHEIGHT);

	shm_fd = shm_open("/robovis_frame", O_RDWR | O_CREAT | O_TRUNC, 0664);
	if (shm_fd < 0) {
		perror("Couldn't open robovis frame SHM object");
		exit(1);
	}

	ftruncate(shm_fd, (CAMWIDTH * CAMHEIGHT * 3) + 1);

	shm_ptr = (uint8_t *)mmap(NULL, (CAMWIDTH * CAMHEIGHT * 3) + 1,
			PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
	if (shm_ptr == NULL) {
		perror("Couldn't map robovis shm");
		exit(1);
	}

	gui_data = shm_ptr + (CAMWIDTH * CAMHEIGHT * 3);
	*gui_data = 0;

	mkfifo("/tmp/robovis_frame_fifo", 0664); // Don't care about the return.

	fifo_fd = open("/tmp/robovis_frame_fifo", O_RDWR, 0);
	if (fifo_fd < 0) {
		perror("Couldn't open robovis fifo");
		exit(1);
	}

	fifo_out = fdopen(fifo_fd, "w");

#ifdef OPENCV
	if(DEBUGDISPLAY) {
		//No idea what this returns on fail.
		cvNamedWindow("testcam", CV_WINDOW_AUTOSIZE);
		cvSetMouseCallback("testcam", Boo, frame);
		cvNamedWindow("val", CV_WINDOW_AUTOSIZE);
		cvSetMouseCallback("val", Hoo, val);
		cvNamedWindow("sat", CV_WINDOW_AUTOSIZE);
		cvSetMouseCallback("sat", Goo, sat);
		cvNamedWindow("hue", CV_WINDOW_AUTOSIZE);
		cvSetMouseCallback("hue", Foo, hue);
	}

	framesize = cvSize(CAMWIDTH, CAMHEIGHT);

	if (DEBUGDISPLAY) {
		srlog(DEBUG, "Allocating scratchpads");
		hue = cvCreateImage(framesize, IPL_DEPTH_8U, 1);
		sat = cvCreateImage(framesize, IPL_DEPTH_8U, 1);
		val = cvCreateImage(framesize, IPL_DEPTH_8U, 1);
	}
#endif

	srlog(DEBUG, "Beginning looping");
	while (1){
		srlog(DEBUG, "Press enter to grab a frame:");

		if(!DEBUGDISPLAY || DEBUGSLOW) {
			req_tag = wait_trigger();
		}

		srlog(DEBUG, "Grabbing frame");

		blobs = 0;
		raw_data = get_v4l_frame();
		if (!raw_data) {
			fprintf(stderr, "Couldn't grab v4l frame!\n");
			sleep(1);
			continue;
		}

#ifdef OPENCV
		if (DEBUGDISPLAY) {
			oldframe = frame;
			frame = cvCreateImage(framesize, IPL_DEPTH_8U, 3);
			make_rgb_image(raw_data, CAMWIDTH, CAMHEIGHT, frame->widthStep, false, (uint8_t *)frame->imageData);
			squish_raw_data_into_hsv(raw_data, CAMWIDTH, CAMHEIGHT,
							hue, sat, val);

			cvShowImage("sat", sat);
			cvShowImage("hue", hue);
			cvShowImage("val", val);
		}
#endif

		blobs = vis_find_blobs_through_scanlines(raw_data, CAMWIDTH, CAMHEIGHT);

		for (i = 0; ; i++) {
			if (blobs[i].x1 == 0 && blobs[i].x2 == 0)
				break;

#ifdef OPENCV
			cvRectangle(frame, cvPoint(blobs[i].x1, blobs[i].y1),
					cvPoint(blobs[i].x2, blobs[i].y2),
					(blobs[i].colour == RED) ?
							cvScalar(0, 0, 255) :
					(blobs[i].colour == BLUE) ?
						cvScalar(255, 0, 0) :
						cvScalar(0, 255, 0), 1);
#endif

			w = blobs[i].x2 - blobs[i].x1;
			h = blobs[i].y2 - blobs[i].y1;
			printf("%d,%d,%d,%d,%d,%d\n", blobs[i].x1, blobs[i].y1,
					w, h, w*h, blobs[i].colour);
		}

#ifdef OPENCV
		if(DEBUGDISPLAY) {
			cvShowImage("testcam", frame);
			cvReleaseImage(&oldframe);
			oldframe = NULL;
		}
#endif

		if (req_tag) {
			fputs(req_tag, stdout);
			free(req_tag);
		}

		fputs("BLOBS\n", stdout);
		fflush(stdout);

#ifdef OPENCV
		if (DEBUGDISPLAY)
			cvWaitKey(100);
#endif

		// So, interact with the GUI. Is there already a frame sitting
		// in the buffer?
		if (*gui_data != 0)
			continue;

		make_rgb_image(raw_data, CAMWIDTH, CAMHEIGHT, CAMWIDTH*3, true, shm_ptr);

		// Set flag
		*gui_data = 1;

		// Also pump blob data at FIFO.
		for (i = 0; ; i++) {
			if (blobs[i].x1 == 0 && blobs[i].x2 == 0)
				break;

			w = blobs[i].x2 - blobs[i].x1;
			h = blobs[i].y2 - blobs[i].y1;
			fprintf(fifo_out, "%d,%d,%d,%d,%d,%d\n", blobs[i].x1,
				blobs[i].y1, w, h, w*h, blobs[i].colour);
		}

		fprintf(fifo_out, "BLOBS\n");
		fflush(fifo_out);

	}	//end while loop

	close_webcam();
	return 0;
}

