#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <fcntl.h>
#include <unistd.h>

#include "hueblobs.h"

#ifdef OPENCV
#include <cv.h>
#include <highgui.h>
#endif

#include "visfunc.h"

extern "C" {
#include "dsp_api.h"
}

#define UNUSED(x) ((x) = (x))

#define DEBUG 0
#define ERROR 1

#define IN_FILENAME "in.png"
#define OUT_FILENAME "out.bmp"

const unsigned int MINMASS = 200;
const unsigned int MAXMASS = 2000;

#ifdef OPENCV
IplImage *frame = NULL, *oldframe = NULL, *hsv, *hue, *sat, *val;
#endif

int USEFILE = 0;
int DEBUGOUTPUT = 0;
int DEBUGDISPLAY = 0;

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

	req_tag = fgets(req_tag, 128, stdin);
	if (req_tag == NULL)	/*EOF*/
		exit(0);

	return req_tag;
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
#ifdef spam
	char buffer[256];
	int rawr = 0;
#endif
#ifdef OPENCV
	CvSize framesize;
#endif
	uint8_t *raw_data;

	struct blob_position *blobs;
	char *req_tag = NULL;
	int i, w, h, num_blobs;

	get_command_line_opts(argc, argv);

	open_webcam(CAMWIDTH, CAMHEIGHT);

#ifdef USE_DSP
	if (check_dsp_open())
		return 1;

	if (open_dsp_and_prepare_buffers(CAMWIDTH * CAMHEIGHT * 2))
		return 1;
#endif

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
#endif

	//Get a frame to find the image size
	if (USEFILE) {
		fprintf(stderr, "USEFILE is now no longer valid, seeing how "
			"the existing code will only work on a yuyv array");
	}

#ifdef OPENCV
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

		if(!DEBUGDISPLAY) {
			req_tag = wait_trigger();
		}

		srlog(DEBUG, "Grabbing frame");

#ifdef OPENCV
		if(DEBUGDISPLAY) {
			cvShowImage("sat", sat);
			cvShowImage("hue", hue);
			cvShowImage("val", val);
		}
#endif

		raw_data = get_v4l_frame();
		if (!raw_data) {
			fprintf(stderr, "Couldn't grab v4l frame!\n");
			sleep(1);
			continue;
		}

#ifdef OPENCV
		if (DEBUGDISPLAY) {
			oldframe = frame;
			frame = make_rgb_image(raw_data, CAMWIDTH, CAMHEIGHT);
			squish_raw_data_into_hsv(raw_data, CAMWIDTH, CAMHEIGHT,
							hue, sat, val);
		}
#endif

#ifdef USE_DSP
		/* Calculating buffer size is less than dynamic; anyway */
		issue_buffer_to_dsp(raw_data, CAMWIDTH * CAMHEIGHT * 2);

		blobs = recv_blob_info(1000); /* 1 second timeout */
		if (blobs == NULL) {
			fprintf(stderr, "Couldn't get blobs info: bad!\n");
			exit(1);
		}

		remove_buffer_from_dsp(); /* Unmap framebuffer */
#else
		blobs = vis_find_blobs_through_scanlines(raw_data, CAMWIDTH,
								CAMHEIGHT);
#endif

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

		num_blobs = i;

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

		srlog(DEBUG, "Saving frame to out.jpg");
#ifdef spam
		sprintf(buffer, "out%4d.jpg", rawr);
		rawr++;
		cvSaveImage(buffer, frame);
#endif

		store_rgb_image(OUT_FILENAME, raw_data, CAMWIDTH, CAMHEIGHT,
				blobs, num_blobs);

#ifdef OPENCV
		if (DEBUGDISPLAY)
			cvWaitKey(100);
#endif

	}	//end while loop

	close_webcam();
#ifdef USE_DSP
	wind_up_dsp();
#endif
	return 0;
}

