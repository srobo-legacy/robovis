#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <fcntl.h>
#include <unistd.h>
#include <cv.h>
#include <highgui.h>

#include "visfunc.h"

#define UNUSED(x) ((x) = (x))

#define DEBUG 0
#define ERROR 1

#define IN_FILENAME "in.png"
#define OUT_FILENAME "out.jpg"

const unsigned int MINMASS = 200;
const unsigned int MAXMASS = 2000;

#define CAMWIDTH 320
#define CAMHEIGHT 240

IplImage *frame = NULL, *hsv, *hue, *sat, *val;

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

int
main(int argc, char **argv)
{
	get_command_line_opts(argc, argv);

#ifdef spam
	char buffer[256];
	int rawr = 0;
#endif
	CvSize framesize;
	uint8_t *raw_data;

	struct blob_position *blobs;
	char *req_tag = NULL;
	int i, w, h;

	open_webcam(CAMWIDTH, CAMHEIGHT);

	if(DEBUGDISPLAY) {
		//No idea what this returns on fail.
		cvNamedWindow("testcam", CV_WINDOW_AUTOSIZE);
		cvNamedWindow("val", CV_WINDOW_AUTOSIZE);
		cvSetMouseCallback("val", Hoo, val);
		cvNamedWindow("sat", CV_WINDOW_AUTOSIZE);
		cvSetMouseCallback("sat", Goo, sat);
		cvNamedWindow("hue", CV_WINDOW_AUTOSIZE);
		cvSetMouseCallback("hue", Foo, hue);
	}

	//Get a frame to find the image size
	if (USEFILE) {
		fprintf(stderr, "USEFILE is now no longer valid, seeing how "
			"the existing code will only work on a yuyv array");
	}

	framesize = cvSize(320, 240);

	if (DEBUGDISPLAY) {
		srlog(DEBUG, "Allocating scratchpads");
		hue = allo_frame(framesize, IPL_DEPTH_8U, 1);
		sat = allo_frame(framesize, IPL_DEPTH_8U, 1);
		val = allo_frame(framesize, IPL_DEPTH_8U, 1);
	}

	srlog(DEBUG, "Beginning looping");
	while (1){
		srlog(DEBUG, "Press enter to grab a frame:");

		if(!DEBUGDISPLAY) {
			req_tag = wait_trigger();
		}

		srlog(DEBUG, "Grabbing frame");

		if(DEBUGDISPLAY) {
			cvShowImage("sat", sat);
			cvShowImage("hue", hue);
			cvShowImage("val", val);
		}

		blobs = 0;
		raw_data = get_v4l_frame();

		if (DEBUGDISPLAY) {
			frame = make_rgb_image(raw_data, 320, 240);
			squish_raw_data_into_hsv(raw_data, 320, 240,
							hue, sat, val);
		}

		blobs = vis_find_blobs_through_scanlines(raw_data, 320, 240);

		for (i = 0; ; i++) {
			if (blobs[i].x1 == 0 && blobs[i].x2 == 0)
				break;

			cvRectangle(frame, cvPoint(blobs[i].x1, blobs[i].y1),
					cvPoint(blobs[i].x2, blobs[i].y2),
					(blobs[i].colour == RED) ?
							cvScalar(0, 0, 255) :
					(blobs[i].colour == BLUE) ?
						cvScalar(255, 0, 0) :
						cvScalar(255, 0, 0), 1);
					
			w = blobs[i].x2 - blobs[i].x1;
			h = blobs[i].y2 - blobs[i].y1;
			printf("%d,%d,%d,%d,%d,%d\n", blobs[i].x1, blobs[i].y1,
					w, h, w*h, blobs[i].colour);
		}

		if(DEBUGDISPLAY) {
			cvShowImage("testcam", frame);
		}

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
		if (frame)
			cvSaveImage(OUT_FILENAME, frame);

		if (USEFILE && frame) {
			cvReleaseImage(&frame);
		}

		if (DEBUGDISPLAY)
			cvWaitKey(100);

	}	//end while loop

	close_webcam();
	return 0;
}

