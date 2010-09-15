/* This file contains eye supliments designed to strengthen the surface of your
 * eyeballs against pokeage, which will save you a lot of pain in the future.
 * This is because looking at robovis code tends to make your eyeballs swell
 * to the size where forks and other sharp cutlery is attracted to your face
 * by gravity.
 *
 * In case of mis-use, consult your doctor
 */

/* Can't include string.h, it squirts various inline functions at us */
extern void *memset(void *, int c, unsigned int sz);

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

extern void setup_simple_dma(void *src, void *dst, uint16_t cnt);
extern void wait_for_dma_completion();

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

	if (num_blobs >= MAX_BLOBS)
		return;

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

#if defined(USE_DSP) && defined(__clang__)
/* Implement abs here as a workaround for the fact we can't link against libc
 * while also linking against the bridgedriver base image... (also, gcc lowers
 * abs automagically */
static inline int
abs(int a)
{

	return (a < 0) ? -a : a;
}
#endif

#define CACHE_BLOCK_SZ		0x4000
#define L1CACHE_BLOCK1		((uint8_t*)0x10F04000)
#define L1CACHE_BLOCK2		(L1CACHE_BLOCK1 + CACHE_BLOCK_SZ)
#define SIZEOF_SCANLINE		(CAMWIDTH * 2)
#define NUM_SCANLINES_TO_READ	24
#define DMA_READ_SZ		(NUM_SCANLINES_TO_READ * SIZEOF_SCANLINE)

#if ((SIZEOF_SCANLINE * NUM_SCANLINES_TO_READ) > CACHE_BLOCK_SZ)
#error num scanlines doesn't fit in cache block
#endif

static uint8_t * dma_buffer;
static uint8_t * working_buffer;

static void
reset_dma_state(uint8_t **extmem_fb)
{

	/* Setup buffer pointers, and put the first dma xfer in motion */
	dma_buffer = L1CACHE_BLOCK1;
	working_buffer = L1CACHE_BLOCK2;
	setup_simple_dma(*extmem_fb, dma_buffer, DMA_READ_SZ);
	*extmem_fb += DMA_READ_SZ;
	return;
}

static uint8_t *
get_next_buffer(uint8_t **extmem_fb, int y)
{
	uint8_t *read_buffer;
	int read_sz;

	/* first, wait for the previous dma xfer to be ready */
	wait_for_dma_completion();

	/* Swap our buffers around */
	read_buffer = dma_buffer;
	dma_buffer = working_buffer;
	working_buffer = read_buffer;

	/* queue up the next dma_xfer - staying aware that the final one will
	 * need to be slightly smaller */
	if ((CAMWIDTH - y) < NUM_SCANLINES_TO_READ)
		read_sz = (CAMWIDTH - y) * SIZEOF_SCANLINE;
	else
		read_sz = DMA_READ_SZ;

	setup_simple_dma(*extmem_fb, dma_buffer, read_sz);
	*extmem_fb += read_sz;

	return read_buffer;
}

void
vis_find_blobs_through_scanlines(uint8_t *yuyv, int width, int height,
				struct blob_position *blobs_out)
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
	uint8_t *extmem;
	int x, i, j, cache, val_hyst_count, sat_hyst_count;
	unsigned int y, wind_y;
	int32_t _y, _u, _v, r, g, b, h, s, v;
	uint8_t back_buffer_idx, colour_value, old_colour_value;
	uint8_t drb, drg, dgb;

	extmem = yuyv;
	reset_dma_state(&extmem);

	blobs = blobs_out;
	memset(blobs, 0, MAX_BLOBS * sizeof(*blobs));
	num_blobs = 0;
	spans = spans_a;
	ospans = spans_b;
	memset(spans, 0, sizeof(spans_a));
	memset(ospans, 0, sizeof(spans_a));
	span = 0;

	/* Spin through all scanlines, + 1 */
	for (y = 0, wind_y = 0; y < height + 1; y++, wind_y++) {
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

		/* If we're done with one dma buffer, get the next */
		if ((y % NUM_SCANLINES_TO_READ) == 0) {
			wind_y = 0;
			yuyv = get_next_buffer(&extmem, y);
		}

		for (x = 0; x < line_cache_sz; x++) {
			get_yuv(x, wind_y, _y, _u, _v);
			yuv_2_rgb(_y, _u, _v, r, g, b);
			rgb_2_hsv(r, g, b, h, s, v);
			cache += h;
			back_buffer[back_buffer_idx++] = h;
			back_buffer_idx %= line_cache_sz;
		}

		for (x = line_cache_sz; x < width; x++) {
			old_colour_value = colour_value;
			get_yuv(x, wind_y, _y, _u, _v);
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

#ifndef USE_DSP
			if (span >= SPANS) {
				fprintf(stderr, "Out of spans storage\n");
				break;
			}
#endif
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
