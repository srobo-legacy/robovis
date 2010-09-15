#include <stdio.h>
#include <stdlib.h>

#include "hueblobs.h"
#include "visfunc.h"

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

#define flip_y_axis(y, height) ((height) - (y))

void
plot_line_h(uint8_t *data, int stride, int height, int x, int y, int len,
		uint32_t col)
{
	uint8_t *ptr;
	int i;

	y = flip_y_axis(y, height);

	ptr = &data[(stride * y) + (x * 3)];
	for (i = 0; i < len; i++) {
		ptr[0] = col & 0xFF;
		ptr[1] = (col >> 8) & 0xFF;
		ptr[2] = (col >> 16) & 0xFF;
		ptr += 3;
	}

	return;
}

void
plot_line_v(uint8_t *data, int stride, int height, int x, int y, int len,
		uint32_t col)
{
	uint8_t *ptr;
	int i;

	y = flip_y_axis(y, height);

	ptr = &data[(stride * y) + (x * 3)];
	for (i = 0; i < len; i++) {
		ptr[0] = col & 0xFF;
		ptr[1] = (col >> 8) & 0xFF;
		ptr[2] = (col >> 16) & 0xFF;
		ptr -= stride;
	}

	return;
}

void
carve_in_blob_rectangles(uint8_t *data, int width, int height,
			struct blob_position *blobs, int num_blobs)
{
	uint32_t col;
	int i, stride;

	stride = width * 3;
	stride += 3;
	stride &= ~3; /* align to 4 */

	for (i = 0; i < num_blobs; i++) {
		if (blobs[i].colour == RED) col = 0xFF0000;
		else if (blobs[i].colour == GREEN) col = 0x00FF00;
		else if (blobs[i].colour == BLUE) col = 0x0000FF;
		else continue; /* Erk, shouldn't happen */

		/* Draw two horizontal and two vertical lines */
		plot_line_h(data, stride, height, blobs[i].x1, blobs[i].y1,
				blobs[i].x2 - blobs[i].x1, col);
		plot_line_h(data, stride, height, blobs[i].x1, blobs[i].y2,
				blobs[i].x2 - blobs[i].x1, col);
		plot_line_v(data, stride, height, blobs[i].x1, blobs[i].y1,
				blobs[i].y2 - blobs[i].y1, col);
		plot_line_v(data, stride, height, blobs[i].x2, blobs[i].y1,
				blobs[i].y2 - blobs[i].y1, col);
	}

	return;
}

void
store_rgb_image(const char *file, uint8_t *yuyv, int width, int height,
		struct blob_position *blobs, int num_blobs)
{
	struct bmp_header head;
	FILE *foo;
	uint8_t *rgb, *prgb;
	int i, j, y, u, v, r, g, b;

	rgb = (uint8_t*) malloc(width * height * 3);
	prgb = rgb;

	if (rgb == NULL) {
		fprintf(stderr, "Couldn't allocate store_rgb_image buffer\n");
		return;
	}

	for (j = height-1; j >= 0; j--) {
		for (i = 0; i < width; i++) {
			get_yuv(i, j, y, u, v);
			yuv_2_rgb(y, u, v, r, g, b);
			*prgb++ = b;
			*prgb++ = g;
			*prgb++ = r;
		}
	}

	carve_in_blob_rectangles(rgb, width, height, blobs, num_blobs);

	head.magic = 0x4D42; /* Will explode on big endian */
	head.file_size = sizeof(head) + (width * height * 3);
	head.reserved1 = 0;
	head.reserved2 = 0;
	head.data_offset = sizeof(head);
	head.header_size = 40;
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
	fwrite(rgb, width * height * 3, 1, foo);
	fclose(foo);

	free(rgb);

	return;
}

