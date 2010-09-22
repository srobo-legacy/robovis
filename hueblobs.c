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

uint8_t big_aligned_fbuffer[CAMHEIGHT * CAMWIDTH * 2] __attribute__((aligned(4096)));

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
	char buffer[256];
	uint8_t *raw_data;

	struct blob_position *blobs, *canonical_blobs;
	int i, num_blobs, frame_no;

	get_command_line_opts(argc, argv);
	int w, h;
	frame_no = 2;

#if 0
	open_webcam(CAMWIDTH, CAMHEIGHT);
#endif

#ifdef USE_DSP
	if (check_dsp_open())
		return 1;

	if (open_dsp_and_prepare_buffers(CAMWIDTH * CAMHEIGHT * 2))
		return 1;
#endif

	//Get a frame to find the image size
	if (USEFILE) {
		fprintf(stderr, "USEFILE is now no longer valid, seeing how "
			"the existing code will only work on a yuyv array");
	}

	srlog(DEBUG, "Beginning looping");
	while (1){
		srlog(DEBUG, "Press enter to grab a frame:");

		srlog(DEBUG, "Grabbing frame");

#if 0
		raw_data = get_v4l_frame();
		if (!raw_data) {
			fprintf(stderr, "Couldn't grab v4l frame!\n");
			sleep(1);
			continue;
		}
#endif

		raw_data = &big_aligned_fbuffer[0];
		snprintf(buffer, 255, "data/yuyv%d", frame_no);
		FILE *foo = fopen(buffer, "r");
		if (foo == NULL) {
			fprintf(stderr, "Can't find file %s\n", buffer);
			exit(1);
		}
		fread(raw_data, 2 * CAMWIDTH * CAMHEIGHT, 1, foo);
		fclose(foo);

		/* Calculating buffer size is less than dynamic; anyway */
		issue_buffer_to_dsp(raw_data, CAMWIDTH * CAMHEIGHT * 2);

		blobs = recv_blob_info(1000); /* 1 second timeout */
		if (blobs == NULL) {
			fprintf(stderr, "Couldn't get blobs info: bad!\n");
			exit(1);
		}

		remove_buffer_from_dsp(); /* Unmap framebuffer */

		/* Pick up the /correct/ set of blobs via arm-side calcs */
		canonical_blobs = (struct blob_position *) calloc(1,
				sizeof(struct blob_position *) * MAX_BLOBS);
		vis_find_blobs_through_scanlines(raw_data, CAMWIDTH, CAMHEIGHT,
							canonical_blobs);

		for (i = 0; ; i++) {
			if (blobs[i].x1 == 0 && blobs[i].x2 == 0)
				break;
#if 0

			w = blobs[i].x2 - blobs[i].x1;
			h = blobs[i].y2 - blobs[i].y1;
			printf("%d,%d,%d,%d,%d,%d\n", blobs[i].x1, blobs[i].y1,
					w, h, w*h, blobs[i].colour);
#endif
		}

		num_blobs = i;

		if (memcmp(blobs, canonical_blobs, num_blobs *
				sizeof(struct blob_position))) {
			fprintf(stderr, "Mismatch in blobs for img %d\n",
								frame_no);
		for (i = 0; ; i++) {
			if (blobs[i].x1 == 0 && blobs[i].x2 == 0)
				break;
			w = blobs[i].x2 - blobs[i].x1;
			h = blobs[i].y2 - blobs[i].y1;
			printf("%d,%d,%d,%d,%d,%d\n", blobs[i].x1, blobs[i].y1,
					w, h, w*h, blobs[i].colour);
		}
		printf("vs\n");
		for (i = 0; ; i++) {
			if (canonical_blobs[i].x1 == 0 && canonical_blobs[i].x2 == 0)
				break;
			w = canonical_blobs[i].x2 - canonical_blobs[i].x1;
			h = canonical_blobs[i].y2 - canonical_blobs[i].y1;
			printf("%d,%d,%d,%d,%d,%d\n", canonical_blobs[i].x1, canonical_blobs[i].y1, w, h, w*h, canonical_blobs[i].colour);
		}
		}

		frame_no++;
		free(canonical_blobs);

#if 0
		store_rgb_image(OUT_FILENAME, raw_data, CAMWIDTH, CAMHEIGHT,
				blobs, num_blobs);
#endif

	}	//end while loop

	close_webcam();
#ifdef USE_DSP
	wind_up_dsp();
#endif
	return 0;
}

