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

/* My eyes: */
#ifdef __cplusplus
extern "C" {
#endif
void vis_find_blobs_through_scanlines(uint8_t *yuyv, int width, int height,
					struct blob_position *blobs);
void store_rgb_image(const char *, uint8_t *raw_data, int width, int height,
			struct blob_position *blobs, int num_blobs);
#ifdef __cplusplus
};
#endif

/* And here are some delicious macros for converting between various colour
 * spaces and whatnot */

extern const int trans_table[]; /* This is required for colour space operations
				 * and to avoid divisions; actually lives in
				 * trans_table.c */

/* Ensure that "MAX" and "MIN" are what we expect them to be */
#if defined(MAX)
#undef MAX
#endif
#if defined(MIN)
#undef MIN
#endif
#define MIN(a,b)	(((a)<(b))?(a):(b))
#define MAX(a,b)	(((a)>(b))?(a):(b))

#define get_yuv(x, y, _y, _u, _v) do {					\
				uint8_t *tmp;				\
				tmp = &yuyv[((width * 2) * y) +		\
						(((x) & ~1) * 2)];	\
				_u = tmp[1];				\
				_v = tmp[3];				\
				_y = ((x) & 1) ? tmp[2] : tmp[0];	\
			} while (0);

#define clip(x) MIN(255,MAX(0,((x))))

#define yuv_2_rgb(y, u, v, r, g, b) do {				\
			int32_t c, d, e;				\
			c = y - 16;					\
			d = u - 128;					\
			e = v - 128;					\
			r = clip((298*c + 409*e + 128) >> 8);		\
			g = clip((298*c - 100*d - 208*e + 128) >> 8);	\
			b = clip((298*c + 516*d + 128) >> 8);		\
		} while (0);

#define rgb_2_hsv(r, g, b, h, s, v) do {				\
		uint32_t min, max, diff, also;				\
		max = MAX(r, MAX(g, b));				\
		min = MIN(r, MIN(g, b));				\
		diff = max - min;					\
		v = max;						\
		if (v) {						\
			s = diff * trans_table[v] >> 12;		\
		} else {						\
			s = 0;						\
			h = 0;						\
			continue;					\
		}							\
		h = 0;							\
		if (diff != 0)  {					\
			if (v == r) h = g - b;				\
			if (v == g) h = b - r;				\
			if (v == b) h = r - g;				\
			also = (h < 0) ? 0 : 0;				\
									\
			h = (((1 << 18) + 15 * (h * trans_table[diff])) >> 19);\
			h += also;					\
									\
			if (v == g) h += 60;				\
			if (v == b) h += 120;				\
		}							\
		h = clip(h);						\
		s = clip(s);						\
		v = clip(v);						\
	} while (0);


#endif /* _ROBOVIS_VISFUNC_H_ */
