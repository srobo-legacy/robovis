/* This file contains eye supliments designed to strengthen the surface of your
 * eyeballs against pokeage, which will save you a lot of pain in the future.
 * This is because looking at robovis code tends to make your eyeballs swell
 * to the size where forks and other sharp cutlery is attracted to your face
 * by gravity.
 *
 * In case of mis-use, consult your doctor
 */

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "hueblobs.h"

#ifdef OPENCV
#include <cv.h>
#endif

#include "visfunc.h"

/* Ensure that "MAX" and "MIN" are what we expect them to be */
#if defined(MAX)
#undef MAX
#endif
#if defined(MIN)
#undef MIN
#endif
#define MIN(a,b)        (((a)<(b))?(a):(b))
#define        MAX(a,b)        (((a)>(b))?(a):(b))

#ifndef __GNUC__
#define INLINE
#define breakpoint() exit(1)
#else
#define INLINE inline
#if !defined(__arm__)
#define breakpoint() __asm__("int $3")
#else
#define breakpoint()
#endif
#endif

#define template_size 5
#define sobel_size 5
#define image_depth IPL_DEPTH_8U

/* Bounds for what edge pixel values are accepted into a line being followed -
 * a line will only _start_ when a 'high' pixel is found, and will continue 
 * until it drops below 'low'. This lets us eliminate a lot of noise without
 * thresholding out faint outlines. If both values are the same, equivalent
 * of thresholding */

#define line_hysteresis_high 5
#define line_hysteresis_low 5

#define BLOB_MIN_WIDTH 5
#define BLOB_MIN_HEIGHT 5
#define BLOB_MIN_MASS 10

#define span_min_sat 60
#define span_min_val 60
#define span_min_len 5
#define span_match_fuzz 30

static struct blob_position blobs[MAX_BLOBS+1];

static int num_blobs = 0;

#define SPANS 32
static blob_position spans_a[SPANS+1];
static blob_position spans_b[SPANS+1];
static blob_position *spans, *ospans;
static int span, ospan;

/* 8 bit division conversion table - defined later in file */
static const int trans_table[] = {
	0, 1044480, 522240, 348160, 261120, 208896, 174080, 149211,
	130560, 116053, 104448, 94953, 87040, 80345, 74606, 69632,
	65280, 61440, 58027, 54973, 52224, 49737, 47476, 45412,
	43520, 41779, 40172, 38684, 37303, 36017, 34816, 33693,
	32640, 31651, 30720, 29842, 29013, 28229, 27486, 26782,
	26112, 25475, 24869, 24290, 23738, 23211, 22706, 22223,
	21760, 21316, 20890, 20480, 20086, 19707, 19342, 18991,
	18651, 18324, 18008, 17703, 17408, 17123, 16846, 16579,
	16320, 16069, 15825, 15589, 15360, 15137, 14921, 14711,
	14507, 14308, 14115, 13926, 13743, 13565, 13391, 13221,
	13056, 12895, 12738, 12584, 12434, 12288, 12145, 12006,
	11869, 11736, 11605, 11478, 11353, 11231, 11111, 10995,
	10880, 10768, 10658, 10550, 10445, 10341, 10240, 10141,
	10043, 9947, 9854, 9761, 9671, 9582, 9495, 9410,
	9326, 9243, 9162, 9082, 9004, 8927, 8852, 8777,
	8704, 8632, 8561, 8492, 8423, 8356, 8290, 8224,
	8160, 8097, 8034, 7973, 7913, 7853, 7795, 7737,
	7680, 7624, 7569, 7514, 7461, 7408, 7355, 7304,
	7253, 7203, 7154, 7105, 7057, 7010, 6963, 6917,
	6872, 6827, 6782, 6739, 6695, 6653, 6611, 6569,
	6528, 6487, 6447, 6408, 6369, 6330, 6292, 6254,
	6217, 6180, 6144, 6108, 6073, 6037, 6003, 5968,
	5935, 5901, 5868, 5835, 5803, 5771, 5739, 5708,
	5677, 5646, 5615, 5585, 5556, 5526, 5497, 5468,
	5440, 5412, 5384, 5356, 5329, 5302, 5275, 5249,
	5222, 5196, 5171, 5145, 5120, 5095, 5070, 5046,
	5022, 4998, 4974, 4950, 4927, 4904, 4881, 4858,
	4836, 4813, 4791, 4769, 4748, 4726, 4705, 4684,
	4663, 4642, 4622, 4601, 4581, 4561, 4541, 4522,
	4502, 4483, 4464, 4445, 4426, 4407, 4389, 4370,
	4352, 4334, 4316, 4298, 4281, 4263, 4246, 4229,
	4212, 4195, 4178, 4161, 4145, 4128, 4112, 4096
};

static void
add_blob(int minx, int miny, int maxx, int maxy, int colour)
{
	int w, h;

	if (!(num_blobs < MAX_BLOBS)) {
		fprintf(stderr, "add_blob, ran out of blob records...\n");
		return;
	}

	w = maxx - minx;
	h = maxy - miny;
	if (w * h < BLOB_MIN_MASS || w < BLOB_MIN_WIDTH || h < BLOB_MIN_HEIGHT)
		return;

	blobs[num_blobs].x1 = minx;
	blobs[num_blobs].x2 = maxx;
	blobs[num_blobs].y1 = miny;
	blobs[num_blobs].y2 = maxy;
	blobs[num_blobs].colour = colour;
	num_blobs++;

	return;
}

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
		if (diff != 0)	{					\
			if (v == r) h = g - b;				\
			if (v == g) h = b - r;				\
			if (v == b) h = r - g;				\
			also = (h < 0) ? 0 : 0;			\
									\
			h = (((1 << 18) + 15 * (h * trans_table[diff])) >> 19);		\
			h += also;					\
									\
			if (v == g) h += 60;				\
			if (v == b) h += 120;				\
		}							\
		h = clip(h);						\
		s = clip(s);						\
		v = clip(v);						\
	} while (0);

#ifdef OPENCV

void
squish_raw_data_into_hsv(uint8_t *yuyv, int width, int height, IplImage *hue,
				IplImage *sat, IplImage *val)
{
	uint8_t *hptr, *sptr, *vptr;
	int i, j;
	int32_t y, u, v, r, g, b, h, s;

	hptr = (uint8_t*) hue->imageData;
	sptr = (uint8_t*) sat->imageData;
	vptr = (uint8_t*) val->imageData;

	for (j = 0; j < height; j++) {
		for (i = 0; i < width; i++) {
			get_yuv(i, j, y, u, v);
			yuv_2_rgb(y, u, v, r, g, b);
			rgb_2_hsv(r, g, b, h, s, v);
			*hptr++ = h;
			*sptr++ = s;
			*vptr++ = v;
		}
	}

	return;
}

IplImage *
make_rgb_image(uint8_t *yuyv, int width, int height)
{
	IplImage *out;
	CvSize frsize;
	uint8_t *prgb;
	int i, j, y, u, v, r, g, b;

	frsize = cvSize(width, height);
	out = cvCreateImage(frsize, IPL_DEPTH_8U, 3);
	prgb = (uint8_t *)out->imageData;

	for (j = 0; j < height; j++) {
		for (i = 0; i < width; i++) {
			get_yuv(i, j, y, u, v);
			yuv_2_rgb(y, u, v, r, g, b);
			*prgb++ = b;
			*prgb++ = g;
			*prgb++ = r;
		}
	}

	return out;
}

#endif

struct bmp_header {
        uint16_t magic;
        uint32_t file_size;
        uint16_t reserved1;
        uint16_t reserved2;
        uint32_t data_offset;

        uint32_t header_size;
        uint32_t width;
        uint32_t height;
        uint16_t planes;
        uint16_t bpp;
        uint32_t compression;
        uint32_t data_size;
        uint32_t x_pix_per_m;
        uint32_t y_pix_per_m;
        uint32_t colours_used;
        uint32_t important_colours;
} __attribute__((packed));

void
store_rgb_image(const char *file, uint8_t *yuyv, int width, int height)
{
	struct bmp_header head;
	FILE *foo;
	uint8_t *prgb;
	int i, j, y, u, v, r, g, b;

	prgb = (uint8_t*) malloc(width * height * 3);

	for (j = 0; j < height; j++) {
		for (i = 0; i < width; i++) {
			get_yuv(i, j, y, u, v);
			yuv_2_rgb(y, u, v, r, g, b);
			*prgb++ = b;
			*prgb++ = g;
			*prgb++ = r;
		}
	}

	head.magic = 0x4D42; /* Will explode on big endian */
	head.file_size = sizeof(head) + (width * height * 3);
	head.data_offset = sizeof(head);
	head.header_size = sizeof(head);
	head.width = width;
	head.height = height;
	head.planes = 1;
	head.bpp = 24;
	head.compression = 0;
	head.data_size = width * height * 3;
	head.x_pix_per_m = 96;
	head.y_pix_per_m = 96;
	head.colours_used = 0;
	head.important_colours = 0;

	foo = fopen(file, "w");
	fwrite(&head, sizeof(head), 1, foo);
	fwrite(prgb, width * height * 3, 1, foo);
	fclose(foo);

	return;
}

struct blob_position *
vis_find_blobs_through_scanlines(uint8_t *yuyv, int width, int height)
{
#define line_cache_sz 5
#define red_min 0
#define red_max 21 * line_cache_sz
#define green_min 30 * line_cache_sz
#define green_max 90 * line_cache_sz
#define blue_min 91 * line_cache_sz
#define blue_max 149 * line_cache_sz
#define red2_min 150 * line_cache_sz
#define red2_max 185 * line_cache_sz
/* FIXME - adjust for 0-180 scale */

	uint8_t back_buffer[line_cache_sz];
	void *tmp;
	int x, y, i, j, cache;
	int32_t _y, _u, _v, r, g, b, h, s, v;
	uint8_t back_buffer_idx, old_hue, colour_value, old_colour_value;
	uint8_t drb, drg, dgb;

	memset(blobs, 0, sizeof(blobs));
	num_blobs = 0;
	spans = spans_a;
	ospans = spans_b;
	memset(spans, 0, sizeof(spans_a));
	memset(ospans, 0, sizeof(spans_a));
	span = 0;

	/* Spin through all scanlines, + 1 */
	for (y = 0; y < height + 1; y++) {
		memset(ospans, 0, sizeof(spans_a));
		memset(back_buffer, 0, sizeof(back_buffer));
		back_buffer_idx = 0;
		colour_value = NOTHING;
		old_colour_value = NOTHING;
		/* swap */
		tmp = ospans;
		ospans = spans;
		spans = (blob_position *)tmp;

		/* Swap sizes too */
		ospan = span;

		cache = 0;
		span = 0;

		if (y == height)
			goto final_span_check;

		for (x = 0; x < line_cache_sz - 1; x++) {
			get_yuv(x, y, _y, _u, _v);
			yuv_2_rgb(_y, _u, _v, r, g, b);
			rgb_2_hsv(r, g, b, h, s, v);
			cache += h;
			back_buffer[back_buffer_idx++] = h;
			back_buffer_idx %= line_cache_sz;
		}

		for (x = line_cache_sz - 1; x < width; x++) {
			old_colour_value = colour_value;
			get_yuv(x, y, _y, _u, _v);
			yuv_2_rgb(_y, _u, _v, r, g, b);
			rgb_2_hsv(r, g, b, h, s, v);
			cache += h;
			old_hue = back_buffer[back_buffer_idx];
			back_buffer[back_buffer_idx++] = h;
			back_buffer_idx %= line_cache_sz;

			drb = abs(r - b);
			drg = abs(r - g);
			dgb = abs(g - b);

			if (drb < 40 && drg < 40 && dgb < 40) {
				colour_value = NOTHING;
			} else if (s < span_min_sat || v < 60) {
				colour_value = NOTHING;
			} else {
				if (cache <= red_max && cache >= red_min)
					colour_value = RED;
				else if (cache <= blue_max && cache >= blue_min)
					colour_value = BLUE;
				else if (cache <= green_max &&
					cache >= green_min)
					colour_value = GREEN;
				else if (cache <= red2_max && cache >= red2_min)
					colour_value = RED;
				else
					colour_value = NOTHING;
			}

			cache -= old_hue;

			if (old_colour_value != colour_value) {
				/* First, end the current span. Insert here
				 * some logic to make sure the first span slot
				 * isn't discarded each time */
				if (spans[span].y1 != y ||
				    spans[span].colour == NOTHING)
					goto trumpets;

				/* Reject anything not long enough */
				if (x - spans[span].x1 <= span_min_len)
					goto trumpets;

				spans[span].x2 = x;
				spans[span].y2 = y;
				spans[span].miny = spans[span].maxy = y;
				spans[span].maxx = x;
				spans[span].minx = spans[span].x1;
				span++;
				trumpets:
				spans[span].x1 = x;
				spans[span].y1 = y;
				spans[span].colour = colour_value;
			}

			if (span >= SPANS) {
				fprintf(stderr, "Out of spans storage\n");
				break;
			}
		}

		if (spans[span].colour != NOTHING)
			span++;

		/* After processing one scan line, see whether there are
		 * similar spans of colour on the higher scanline */

/* If we have one span above another, the endpoints of the span obviously won't
 * be exactly above each other, so we have to decide how close they need to
 * be to be acceptably next to each other. Let's try 10. */

		final_span_check:

		for (i = 0; i < span; i++) {
			for (j = 0; j < ospan; j++) {
				if (abs(spans[i].x1 - ospans[j].x1) < span_match_fuzz && abs(spans[i].x2 - ospans[j].x2) < span_match_fuzz && ospans[j].colour == spans[i].colour)  {
					spans[i].maxx =
					       MAX(ospans[j].maxx, spans[i].x2);
					spans[i].minx =
					       MIN(ospans[j].minx, spans[i].x1);
					spans[i].maxy =
					       MAX(ospans[j].maxy, spans[i].y2);
					spans[i].miny = ospans[j].miny;
					/* Mark that ospan as having been used*/
					ospans[j].colour = NOTHING;
					break; /* Out of ospan loop */
				}
			}
		}

		for (j = 0; j < ospan; j++) {
			if (ospans[j].colour != NOTHING) {
				/* Not used, block is dead */
				add_blob(ospans[j].minx, ospans[j].miny,
					 ospans[j].maxx, ospans[j].maxy,
					 ospans[j].colour);
			}
		}

	}

	return blobs;
#undef gethue
#undef getsat
#undef getval
#undef getedge
}
