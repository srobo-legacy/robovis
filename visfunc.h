#ifndef _ROBOVIS_VISFUNC_H_
#define _ROBOVIS_VISFUNC_H_

#include <stdint.h>

#ifdef OPENCV
#include <cv.h>
#endif

#define MAX_BLOBS 1000

struct blob_position {  
	int x1;
	int y1;
	int x2; 
	int y2;
	int minx, maxx;
	int miny, maxy;
	int colour;
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
