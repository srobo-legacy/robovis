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

#define BLOB_MIN_WIDTH 3
#define BLOB_MIN_HEIGHT 3
#define BLOB_MIN_MASS 5

#define span_min_sat 60
#define span_min_val 60
#define span_min_len 3
#define span_match_fuzz 8
#define colour_strength_minimum 20
#define colour_strength_minimum_blue 20

static struct blob_position *blobs;

static int num_blobs = 0;

#define SPANS 32
static struct blob_position spans_a[SPANS+1];
static struct blob_position spans_b[SPANS+1];
static struct blob_position *spans, *ospans;
static int span, ospan;

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

void
vis_find_blobs_through_scanlines(uint8_t *yuyv, int width, int height, struct blob_position *in_blob_space)
{
#define line_cache_sz 3
#define red_min 0
#define red_max 10 * line_cache_sz
#define green_min 60 * line_cache_sz
#define green_max 90 * line_cache_sz
#define blue_min 100 * line_cache_sz
#define blue_max 115 * line_cache_sz
#define red2_min 150 * line_cache_sz
#define red2_max 185 * line_cache_sz
/* FIXME - adjust for 0-180 scale */

	uint8_t back_buffer[line_cache_sz];
	void *tmp;
	int x, y, i, j, cache, val_hyst_count, sat_hyst_count;
	int32_t _y, _u, _v, r, g, b, h, s, v;
	uint8_t back_buffer_idx, colour_value, old_colour_value;
	uint8_t drb, drg, dgb;

	blobs = in_blob_space;
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
		val_hyst_count = 0;
		sat_hyst_count = 0;
		colour_value = NOTHING;
		old_colour_value = NOTHING;
		/* swap */
		tmp = ospans;
		ospans = spans;
		spans = (struct blob_position *)tmp;

		/* Swap sizes too */
		ospan = span;

		cache = 0;
		span = 0;

		if (y == height)
			goto final_span_check;

		for (x = 0; x < line_cache_sz; x++) {
			get_yuv(x, y, _y, _u, _v);
			yuv_2_rgb(_y, _u, _v, r, g, b);
			rgb_2_hsv(r, g, b, h, s, v);
			cache += h;
			back_buffer[back_buffer_idx++] = h;
			back_buffer_idx %= line_cache_sz;
		}

		for (x = line_cache_sz; x < width; x++) {
			old_colour_value = colour_value;
			get_yuv(x, y, _y, _u, _v);
			yuv_2_rgb(_y, _u, _v, r, g, b);
			rgb_2_hsv(r, g, b, h, s, v);
			cache += h;
			cache -= back_buffer[back_buffer_idx];
			back_buffer[back_buffer_idx++] = h;
			back_buffer_idx %= line_cache_sz;

			drb = abs(r - b);
			drg = abs(r - g);
			dgb = abs(g - b);

			if (cache >= blue_min &&
				drb < colour_strength_minimum_blue &&
				drg < colour_strength_minimum_blue &&
				dgb < colour_strength_minimum_blue) {
				sat_hyst_count = 0;
				val_hyst_count = 0;
				colour_value = NOTHING;
			} else if (cache < blue_min &&
				drb < colour_strength_minimum &&
				drg < colour_strength_minimum &&
				dgb < colour_strength_minimum) {
				sat_hyst_count = 0;
				val_hyst_count = 0;
				colour_value = NOTHING;
			} else if (s < span_min_sat) {
				sat_hyst_count++;
				if (sat_hyst_count > 1)
					colour_value = NOTHING;
			} else if (v < span_min_val) {
				val_hyst_count++;
				if (val_hyst_count > 1)
					colour_value = NOTHING;
			} else {
				sat_hyst_count = 0;
				val_hyst_count = 0;
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
				spans[span].maxx = x;
				spans[span].maxy = y;
				spans[span].minx = spans[span].x1;
				spans[span].miny = spans[span].y1;
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

		if (spans[span].colour != NOTHING) {
			spans[span].x2 = x;
			spans[span].y2 = y;
			spans[span].maxx = x;
			spans[span].maxy = y;
			spans[span].minx = spans[span].x1;
			spans[span].miny = y;
			span++;
		}

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

	return;
#undef gethue
#undef getsat
#undef getval
#undef getedge
}
