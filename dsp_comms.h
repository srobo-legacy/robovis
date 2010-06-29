#ifndef _ROBOVIS_DSP_COMMS_H_
#define _ROBOVIS_DSP_COMMS_H_

/* Pumping data to the dsp works thus: we send a framebuffer full of YUYV data
 * to the dsp, which performs image calculations upon it, and then sends back
 * a set of messages with the following commands: */

#define MSG_BLOB_RED		0
#define MSG_BLOB_BLUE		1
#define MSG_BLOB_GREEN		2
#define MSG_NO_MORE_BLOBS	3

/* Blob colour is reported in which message it is, x1/y1, x2/y2 are packed into
 * arguments 1 and 2 respectively, x in the lower hword, y in upper hword */

#endif /* _ROBOVIS_DSP_COMMS_H_ */