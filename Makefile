SRFLAGS= -DCAMWIDTH=320 -DCAMHEIGHT=240 -DUSE_DSP

CFLAGS += -Wall -Wextra -Werror -O3 -funroll-loops -fomit-frame-pointer
CFLAGS += $(SRFLAGS)
CFLAGS += -L../dsp-code/mpu_lib -lbridge

CBFLAGS = `pkg-config --cflags blobslib`
LDBFLAGS = `pkg-config --libs blobslib`
OPENCV_CFLAGS += `pkg-config --cflags opencv` -Wall
OPENCV_LDFLAGS += `pkg-config --libs opencv`

CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++

# Python 2.4 doesn't support pkg-config; bodge this to your own include path
PY_CFLAGS += -I/usr/include/python2.4

hueblobs: hueblobs.c visfunc.o v4l.o drive_dsp.o
	$(CXX) -o $@ $(OPENCV_CFLAGS) $< $(OPENCV_LDFLAGS) $(CFLAGS) visfunc.o v4l.o drive_dsp.o

visfunc.o: visfunc.cpp
	$(CXX) $< $(OPENCV_CFLAGS) $(CFLAGS) -c -o $@ -fPIC

v4l.o: v4l.c
	$(CC) -o $@ $< $(CFLAGS) -c -fPIC

# FIXME: mpu include stuff is in a different repo. Eww.
drive_dsp.o: drive_dsp.c
	$(CC) -o $@ $< $(CFLAGS) -c -fPIC -I../dsp-code/mpu_include


# DSP side rules
dsp.o: dsp.c
	env CROSS_COMPILE=tic64x- llvmc -Wllc,-march,tms320c64x -hosttools -I../dsp-code/dsp_include -I../dsp-code/mpu_include -c dsp.c -o dsp.o $(SRFLAGS)

dsp_visfunc.o: visfunc.cpp
	env CROSS_COMPILE=tic64x- llvmc -Wllc,-march,tms320c64x -hosttools -I../dsp-code/dsp_include -I../dsp-code/mpu_include -c visfunc.cpp -o dsp_visfunc.o $(SRFLAGS)

dsp.doff: dsp.o dsp_visfunc.o
	tic64x-ld dsp.o dsp_visfunc.o -o dsp.doff --oformat=doff-c64x -r

.PHONY: clean

clean:
	-rm -f hueblobs visfunc.o v4l.o drive_dsp.o dsp.o dsp_visfunc.o dsp.doff
