CFLAGS += -Wall -Wextra -Werror -O3 -funroll-loops -fomit-frame-pointer

CFLAGS += -DCAMWIDTH=320 -DCAMHEIGHT=240

CBFLAGS = `pkg-config --cflags blobslib`
LDBFLAGS = `pkg-config --libs blobslib`
OPENCV_CFLAGS += `pkg-config --cflags opencv` -Wall
OPENCV_LDFLAGS += `pkg-config --libs opencv`

CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++

# Python 2.4 doesn't support pkg-config; bodge this to your own include path
PY_CFLAGS += -I/usr/include/python2.4

hueblobs: hueblobs.c visfunc.o v4l.o drive_dsp.o
	$(CXX) -o $@ $(OPENCV_CFLAGS) $< $(OPENCV_LDFLAGS) $(CFLAGS) visfunc.o v4l.o

visfunc.o: visfunc.cpp
	$(CXX) $< $(OPENCV_CFLAGS) $(CFLAGS) -c -o $@ -fPIC

v4l.o: v4l.c
	$(CC) -o $@ $< $(CFLAGS) -c -fPIC

# FIXME: mpu include stuff is in a different repo. Eww.
drive_dsp.o: drive_dsp.c
	$(CC) -o $@ $< $(CFLAGS) -c -fPIC -I../dsp-code/mpu_include

.PHONY: clean

clean:
	-rm -f hueblobs visfunc.o v4l.o
