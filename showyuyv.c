#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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

#define CAMWIDTH 320
#define CAMHEIGHT 240

IplImage *frame = NULL, *oldframe = NULL, *hsv, *hue, *sat, *val;

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

int
main(int argc, char **argv)
{
	uint8_t yuyv_buffer[CAMWIDTH * CAMHEIGHT * 2];
	CvSize framesize;
	uint8_t *raw_data;
	FILE *foo;
	struct blob_position *blobs;
	int i;

	if (argc != 2) {
		fprintf(stderr, "Usage: showyuyv filename\n");
		return 1;
	}

	cvNamedWindow("testcam", CV_WINDOW_AUTOSIZE);
	cvSetMouseCallback("testcam", Boo, frame);
	cvNamedWindow("val", CV_WINDOW_AUTOSIZE);
	cvSetMouseCallback("val", Hoo, val);
	cvNamedWindow("sat", CV_WINDOW_AUTOSIZE);
	cvSetMouseCallback("sat", Goo, sat);
	cvNamedWindow("hue", CV_WINDOW_AUTOSIZE);
	cvSetMouseCallback("hue", Foo, hue);

	foo = fopen(argv[1], "r");
	if (foo == NULL) {
		fprintf(stderr, "Could not open \"%s\"\n", argv[1]);
		return 1;
	}

	if (fread(yuyv_buffer, CAMWIDTH * CAMHEIGHT * 2, 1, foo) != 1) {
		fprintf(stderr, "Could not read all of yuyv data from "
				"source file\n");
		fclose(foo);
		return 1;
	}

	framesize = cvSize(CAMWIDTH, CAMHEIGHT);

	hue = cvCreateImage(framesize, IPL_DEPTH_8U, 1);
	sat = cvCreateImage(framesize, IPL_DEPTH_8U, 1);
	val = cvCreateImage(framesize, IPL_DEPTH_8U, 1);

	blobs = 0;
	raw_data = yuyv_buffer;

	frame = make_rgb_image(raw_data, CAMWIDTH, CAMHEIGHT);
	squish_raw_data_into_hsv(raw_data, CAMWIDTH, CAMHEIGHT, hue, sat, val);
	cvShowImage("sat", sat);
	cvShowImage("hue", hue);
	cvShowImage("val", val);

	blobs = vis_find_blobs_through_scanlines(raw_data, CAMWIDTH, CAMHEIGHT);

	for (i = 0; ; i++) {
		if (blobs[i].x1 == 0 && blobs[i].x2 == 0)
			break;

		cvRectangle(frame, cvPoint(blobs[i].x1, blobs[i].y1),
				cvPoint(blobs[i].x2, blobs[i].y2),
				(blobs[i].colour == RED) ?
						cvScalar(0, 0, 255) :
				(blobs[i].colour == BLUE) ?
					cvScalar(255, 0, 0) :
					cvScalar(0, 255, 0), 1);

		int w = blobs[i].x2 - blobs[i].x1;
		int h = blobs[i].y2 - blobs[i].y1;
		printf("%d,%d,%d,%d,%d,%d\n", blobs[i].x1, blobs[i].y1,
					w, h, w*h, blobs[i].colour);

	}

	cvShowImage("testcam", frame);
	cvWaitKey(0);

	return 0;
}

