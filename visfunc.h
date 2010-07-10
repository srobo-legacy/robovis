#ifndef _ROBOVIS_VISFUNC_H_
#define _ROBOVIS_VISFUNC_H_

#include <stdint.h>

#ifdef OPENCV
#include <cv.h>
#endif

// When running on the dsp we have some extra constraints... in that the block
// of blobs memory to be mapped must be page aligned. We could map more, but
// that gives the possibility of the dsp trashing the mpu processes stack/heap
// which isn't a plan, or we could map less which would lead to segfaults. So
// make sure blob_position is 32 bytes large and MAX_BLOBS leads to a 4k page
// aligned size.

#define MAX_BLOBS 1024

struct blob_position {  
	uint16_t x1;
	uint16_t y1;
	uint16_t x2;
	uint16_t y2;
	uint16_t minx, maxx;
	uint16_t miny, maxy;
	uint16_t colour;
	uint16_t padding[7];
#define NOTHING 0
#define RED 1
#define BLUE 2
#define GREEN 3
};

#ifdef OPENCV
IplImage *make_rgb_image(uint8_t *raw_data, int width, int height);
void squish_raw_data_into_hsv(uint8_t *yuyv, int width, int height, IplImage *hue, IplImage *sat, IplImage *val);
#endif

void vis_find_blobs_through_scanlines(uint8_t *yuyv, int width, int height,
					struct blob_position *blobs);
void store_rgb_image(const char *, uint8_t *raw_data, int width, int height);

#endif /* _ROBOVIS_VISFUNC_H_ */
