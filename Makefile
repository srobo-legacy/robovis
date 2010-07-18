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
DSP_CC = clang -ccc-host-triple tms320c64x-unknown-unknown
DSP_CXX = $(DSP_CC)
DSP_CFLAGS = -I../dsp-code/dsp_include -I../dsp-code/mpu_include -O3
DSP_LDFLAGS = -L../dsp-code/dsp_lib

# Python 2.4 doesn't support pkg-config; bodge this to your own include path
PY_CFLAGS += -I/usr/include/python2.4

hueblobs: hueblobs.c v4l.o drive_dsp.o
	$(CXX) -o $@ $(OPENCV_CFLAGS) $< $(OPENCV_LDFLAGS) $(CFLAGS) v4l.o drive_dsp.o

v4l.o: v4l.c
	$(CC) -o $@ $< $(CFLAGS) -c -fPIC

# FIXME: mpu include stuff is in a different repo. Eww.
drive_dsp.o: drive_dsp.c
	$(CC) -o $@ $< $(CFLAGS) -c -fPIC -I../dsp-code/mpu_include


# DSP side rules
dsp.o: dsp.c
	$(DSP_CC) $(DSP_CFLAGS) -c dsp.c -o dsp.o $(SRFLAGS)

dsp_dma.o: dsp_dma.c
	$(DSP_CC) $(DSP_CFLAGS) -c dsp_dma.c -o dsp_dma.o $(SRFLAGS)

visfunc.o: visfunc.c
	$(DSP_CC) $(DSP_CFLAGS) -c visfunc.c -o visfunc.o $(SRFLAGS)

dsp.doff: dsp.o visfunc.o dsp_dma.o
	tic64x-ld $(DSP_LDFLAGS) dsp.o dsp_dma.o visfunc.o -lsr_hacks -o dsp.doff --oformat=doff-c64x -r

.PHONY: clean

clean:
	-rm -f hueblobs visfunc.o v4l.o drive_dsp.o dsp.o dsp_visfunc.o dsp.doff
