#include "visfunc.h"

void
rgb2hsv(int r, int g, int b, int *h, int *s, int *v)
{
	int hh, ss, vv;

	rgb_2_hsv(r, g, b, hh, ss, vv);

	*h = hh;
	*s = ss;
	*v = vv;
	return;
}
