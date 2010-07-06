#define SR_NODE_GUID_STRING "3E7AEA34_EC66_4C5F_BC11_48DEE1212C8F"
#define SR_NODE_CREATE_FUNC "create"
#define SR_NODE_EXECUTE_FUNC "execute"
#define SR_NODE_DELETE_FUNC "delete"
#define SR_NODE_NAME "bees"
#define SR_NODE_INPUT_STREAMS "1"
#define SR_NODE_OUTPUT_STREAMS "0"

#include <std.h>
#include <stdlib.h>
#include <rmsdefs.h>
#include <rms_sh.h>
#include <node.h>
#include <dbtype.h>
#include <dbdefs.h>
#include <rmstypes.h>

#include <sr_dcd.h>

#include "dsp_comms.h"

void *MEM_valloc(int seg_id, int size, int align);
void SYS_printf(const char *fmt, ...);

struct state {
	STRM_Handle in_handle;
	unsigned int in_size;
	uint8_t *in_buf;
};

void
panic()
{
	int *beards;

	beards = (void*) 0xFACEBEE5;
	*beards = 0;
	return;
}

int
create(int arg_len, char *arg_str, int num_in_streams,
		uint32_t in_stream_handles[], int num_out_streams,
		uint32_t out_stream_handles[], NODE_EnvPtr node)
{

	/* Happily there's no setup or takedown required for this node, seeing
	 * how data buffers are mapped from the ARM core and then sent to us
	 * in a message */
	return RMS_EOK;
}

int
execute(NODE_EnvPtr node)
{
	RMS_DSPMSG msg;
	struct blob_position *blobs;
	uint8_t *in_buf;
	uint32_t context;
	Uns streams, msgs; /* Uns? Sounds like a war crime to me */
	int i;

	while (1) {
		NODE_wait(node, NULL, 0, NODE_FOREVER, &msgs);
		SYS_printf("after wait, %d msgs\n", msgs);
		if (msgs == 0)
			panic();

		/* We expect only two messages from the dsp */
		switch (msg.cmd) {
		case MSG_START_PROCESSING:
			/* Hand off buffer to yuyv beating code. This message
			 * has only one argument, the dsp side address of the
			 * buffer to beat */
			SYS_printf("Starting to beat buffer at %x\n", msg.arg1);
			blobs = vis_find_blobs_through_scanlines(
					(void*)msg.arg1, CAMWIDTH,
							CAMHEIGHT);

			/* Pump out some blob information. For now, just pump
			 * out nothing instead, worry about actual data later */
			msg.cmd = MSG_NO_MORE_BLOBS;
			msg.arg1 = 0;
			msg.arg2 = 0;
			NODE_putMsg(node, NODE_TOGPP, &msg, NODE_FOREVER);
			break;

		case RMS_EXIT:

			/* In yet another delightful turn of events, when
			 * instructed to exit there's nothing to free/disable */
			return RMS_EOK;

		default:
			SYS_printf("Unrecognized node msg %x\n", msg.cmd);
			panic();
		}
	}

	return RMS_EOK;
}

int
delete(NODE_EnvPtr node)
{

	/* See create routine, there's no setup or takedown required */
	return RMS_EOK;
}
