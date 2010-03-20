#ifndef _BOARDS_SLUG_VISION_ROBOVIS_VISFUNC_H_
#define _BOARDS_SLUG_VISION_ROBOVIS_VISFUNC_H_

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
IplImage *vis_do_smooth(IplImage *src);
IplImage *vis_do_roberts_edge_detection(IplImage *src, IplImage **direction);
IplImage *vis_do_sobel_edge_detection(IplImage *src, IplImage **direction);
IplImage *vis_normalize_plane(IplImage *src);
IplImage *vis_threshold(IplImage *src, unsigned char low, unsigned char high);
IplImage *vis_clip(IplImage *src, IplImage *clip, unsigned char low,
						unsigned char high);
IplImage *vis_nonmaximal_supression(IplImage *src, IplImage *direction);
void vis_follow_edge(IplImage *src, IplImage *direction, int x, int y);
void vis_follow_edge_backwards(IplImage *src, IplImage *direction, int x, int y,
				int minx, int miny, int maxx, int maxy);
struct blob_position *vis_search_for_blobs(IplImage *img, IplImage *dir,
							int spacing);
IplImage *make_rgb_image(uint8_t *raw_data, int width, int height);
void squish_raw_data_into_hsv(uint8_t *yuyv, int width, int height, IplImage *hue, IplImage *sat, IplImage *val);
#endif

struct blob_position *vis_find_blobs_through_scanlines(uint8_t *yuyv,
						int width, int height);
void store_rgb_image(const char *, uint8_t *raw_data, int width, int height);

#endif /* _BOARDS_SLUG_VISION_ROBOVIS_VISFUNC_H_ */
