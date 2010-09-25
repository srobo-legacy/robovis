#include "visfunc.h"

void
yuyv2rgb(int y, int u, int v, int *r, int *g, int *b)
{
	int rr, bb, gg;

	yuv_2_rgb(y, u, v, rr, gg, bb);

	*r = rr;
	*g = gg;
	*b = bb;
	return;
}
