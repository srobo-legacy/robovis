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

void
store_rgb_image(const char *file, uint8_t *yuyv, int width, int height)
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

