#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <dbapi.h>

#include "visfunc.h"
#include "dsp_comms.h"

static bool dsp_open = false;
static DSP_HPROCESSOR dsp_handle = NULL;
static DSP_HNODE node;
static DSP_HSTREAM stream;

static struct DSP_UUID uuid = {0x3E7AEA34, 0xEC66, 0x4C5F, 0xBC, 0x11,
				{0x48, 0xDE, 0xE1, 0x21, 0x2C, 0x8F}};

static struct blob_position blobs[MAX_BLOBS];

int
check_dsp_open()
{
	DBAPI status;

	if (dsp_open)
		return 0;

	status = DspManager_Open(0, NULL);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't open dsp manager, %X\n", (int)status);
		return 1;
	}

	status = DSPProcessor_Attach(0, NULL, &dsp_handle);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't attach to dsp 0: %X\n", (int)status);
		DspManager_Close(0, NULL);
		return 1;
	}

	dsp_open = true;
	return 0;
}

void
close_dsp()
{

	dsp_open = false;
	DSPProcessor_Detach(&dsp_handle);
	DspManager_Close(0, NULL);
	return;
}

int
register_and_alloc_node()
{
	DBAPI status;

	DSPManager_UnregisterObject(&uuid, DSP_DCDNODETYPE);
	DSPManager_UnregisterObject(&uuid, DSP_DCDLIBRARYTYPE);

	status = DSPManager_RegisterObject(&uuid, DSP_DCDNODETYPE, "dsp.doff");
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't register dsp code with bridgedriver, "
				"%X\n", (int)status);
		return 1;
	}

	status = DSPManager_RegisterObject(&uuid,DSP_DCDLIBRARYTYPE,"dsp.doff");
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't register dsp code with bridgedriver, "
				"%X\n", (int)status);
		return 1;
	}

	/* Right - it's registered. Now lets try and run it. */
	status = DSPNode_Allocate(dsp_handle, &uuid, NULL, NULL, &node);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Failed to allocate dsp node (%X) from "
				"bridgedriver\n", (int)status);
		return 1;
	}

	return 0;
}

int
terminate(DSP_HNODE node)
{
	DBAPI status;
	DSP_STATUS retval;

	status = DSPNode_Delete(node);
	if (DSP_FAILED(status))
		fprintf(stderr, "Error deleting dsp node, %X\n", (int)status);

	status = DSPNode_Terminate(node, &retval);
	if (DSP_FAILED(status))
		fprintf(stderr, "Can't terminate dsp node, %X\n", (int)status);

	return 0;
}

void
dereg_node()
{

	DSPManager_UnregisterObject(&uuid, DSP_DCDNODETYPE);
	DSPManager_UnregisterObject(&uuid, DSP_DCDLIBRARYTYPE);
}

int
open_dsp_and_prepare_buffers(int buffer_sz)
{
	struct DSP_STRMATTR attrs;
	DBAPI status;

	stream = NULL;
	if (buffer_sz & 3) {
		fprintf(stderr, "Buffer size when creating dsp node must be "
				"a multiple of 4\n");
		return 1;
	}

	if (check_dsp_open()) {
		fprintf(stderr, "Couldn't open DSP\n");
		return 1;
	}

	/* Register and allocate the dsp node, but don't create */
	if (register_and_alloc_node()) {
		fprintf(stderr, "Couldn't allocate dsp node\n");
		return 1;
	}

	/* Create some streams to plug into dsp node */
	attrs.uSegid = 0;
	attrs.uBufsize = buffer_sz / 4; /* Words not byte */
	attrs.uNumBufs = 2;
	attrs.uAlignment = 0;
	attrs.uTimeout = 10000; /* No idea what scale this is */
	attrs.lMode = STRMMODE_PROCCOPY;

	status = DSPNode_Connect((void*)DSP_HGPPNODE, 0, node, 0, &attrs);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't create dsp input stream, %X\n",
				(int)status);
		return 1;
	}

	/* Hmkay, now it should be possible to create and execute node */
	status = DSPNode_Create(node);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't create dsp node: %X\n", (int)status);
		goto fail;
	}

	status = DSPNode_Run(node);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't run dsp node: %X\n", (int)status);
		goto fail;
	}

	status = DSPStream_Open(node, DSP_TONODE, 0, NULL, &stream);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't open dsp input stream (%X)\n",
				(int)status);
		goto streamout;
	}

	/* Success */
	return 0;

	streamout:
	DSPStream_Close(stream);

	fail:
	DSPNode_Delete(node);

	return 1;
}

int
issue_buffer_to_dsp(void *data, int sz)
{
	DBAPI status;

	/* Prepare buffer for being sent to dsp. AKA, wire it into memory */
	status = DSPStream_PrepareBuffer(stream, sz, data);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't prepare buffer for dsp: %X\n",
								(int)status);
		return 1;
	}

	/* Put buffer into stream */
	status = DSPStream_Issue(stream, data, sz, sz, 0);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't issue buffer to dsp: %X\n",
								(int)status);
		DSPStream_UnprepareBuffer(stream, sz, data);
		return 1;
	}

	/* DSP node will now start beating image data. We return so that
	 * the caller can do, well, stuff. Perhaps we wish to schedule grabbing
	 * another image/frame, or do a little dance */
	return 0;
}

struct blob_position *
recv_blob_info(int timeout_ms)
{
	struct DSP_MSG msg;
	BYTE *data;
	DBAPI status;
	ULONG data_sz, max_data_sz, tmp;
	int num;

	status = DSPNode_GetMessage(node, &msg, timeout_ms);

	/* If it timed out, return to caller */
	if (DSP_FAILED(status))
		return NULL;

	/* If we received a message, more will follow, as the dsp emits them
	 * all in one burst, until a NO_MORE_BLOBS arrives */
	num = 0;
	while (msg.dwCmd != MSG_NO_MORE_BLOBS) {
		blobs[num].minx = blobs[num].maxx = 0;
		blobs[num].miny = blobs[num].maxy = 0;

		blobs[num].x1 = msg.dwArg1 & 0xFFFF;
		blobs[num].y1 = (msg.dwArg1 >> 16) & 0xFFFF;
		blobs[num].x2 = msg.dwArg2 & 0xFFFF;
		blobs[num].y2 = (msg.dwArg2 >> 16) & 0xFFFF;

		switch (msg.dwCmd) {
		case MSG_BLOB_RED:
			blobs[num].colour = RED;
			break;
		case MSG_BLOB_BLUE:
			blobs[num].colour = BLUE;
			break;
		case MSG_BLOB_GREEN:
			blobs[num].colour = GREEN;
			break;
		default:
			fprintf(stderr, "Invalid dsp message 0x%X arrived\n",
								(int)msg.dwCmd);
			memset(&blobs[num], 0, sizeof(blobs[num]));
		}

		num++;

		/* Don't overflow array */
		if (num == MAX_BLOBS)
			num--;

		status = DSPNode_GetMessage(node, &msg, 10000);
		if (DSP_FAILED(status)) {
			fprintf(stderr, "Error %X getting dsp message, before "
					"NO_MORE_BLOBS received\n",(int)status);
			return NULL;
		}
	}

	/* After NO_MORE_BLOBS, node will release the buffer */
	status = DSPStream_Reclaim(stream, &data, &data_sz, &max_data_sz, &tmp);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't retrieve buffer from input stream: "
				"%X\n", (int)status);
		return NULL;
	}

	/* Unwire buffer */
	DSPStream_UnprepareBuffer(stream, max_data_sz, data);

	/* kdone */
	return &blobs[0];
}

void
wind_up_dsp()
{
	DBAPI status;

	/* We assume there's nothing in flight while we're shutting down */

	status = DSPStream_Close(stream);
	if (DSP_FAILED(status))
		fprintf(stderr, "Couldn't close dsp stream (%X)\n",(int)status);

	terminate(node);
	dereg_node(&uuid);
	close_dsp();
	return;
}
