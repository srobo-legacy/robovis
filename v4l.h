#ifndef _V4L_H_
#define _V4L_H_

#include <stdint.h>

int open_webcam(unsigned int desired_width, unsigned int desired_height);
uint8_t *get_v4l_frame();
void close_webcam();

#endif /*_V4L_H_*/
