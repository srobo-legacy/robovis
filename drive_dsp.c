#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <dbapi.h>

#include "visfunc.h"
#include "dsp_api.h"
#include "dsp_comms.h"

static bool dsp_open = false;
static DSP_HPROCESSOR dsp_handle = NULL;
static DSP_HNODE node;
static void *reserved_dsp_vma;
static void *dsp_mapped_vma;
static void *blobs_dsp_vma;
static void *blobs_dsp_mapped_vma;

static struct blob_position blobs[MAX_BLOBS] __attribute__((aligned(4096)));

static struct DSP_UUID uuid = {0x3E7AEA34, 0xEC66, 0x4C5F, 0xBC, 0x11,
				{0x48, 0xDE, 0xE1, 0x21, 0x2C, 0x8F}};

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
	DBAPI status;
	int aligned_size, blobs_sz;

	blobs_sz = MAX_BLOBS * sizeof(struct blob_position);

	if (check_dsp_open()) {
		fprintf(stderr, "Couldn't open DSP\n");
		return 1;
	}

	/* Register and allocate the dsp node, but don't create */
	if (register_and_alloc_node()) {
		fprintf(stderr, "Couldn't allocate dsp node\n");
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

	/* It appears that the DSP-side API croaks when handed a buffer ~150k in
	 * size - I've no idea where the limitation comes in, but it's making it
	 * impossible to perform the desired image processing over the stream
	 * API.
	 * So instead we reserve-and-map the callers buffer into DSP address
	 * space, and send a message pointing the DSP at it */
	aligned_size = (buffer_sz + 0xFFF) & ~0xFFF;
	status = DSPProcessor_ReserveMemory(dsp_handle, aligned_size,
						&reserved_dsp_vma);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't reserve dsp-side memory space: %X\n",
							(uint32_t)status);
		goto fail;
	}

	/* Get some space and map in the blobs array */
	status = DSPProcessor_ReserveMemory(dsp_handle, blobs_sz,
						&blobs_dsp_vma);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't reserve dsp-side memory space for "
				"blobs, %X\n", (uint32_t)status);
		DSPProcessor_UnMap(dsp_handle, dsp_mapped_vma);
		DSPProcessor_UnReserveMemory(dsp_handle, reserved_dsp_vma);
		goto fail;
	}

	status = DSPProcessor_Map(dsp_handle, blobs, blobs_sz, blobs_dsp_vma,
						&blobs_dsp_mapped_vma, 0);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't map mpu blobs memory to dsp space: "
				"%X\n", (uint32_t)status);
		DSPProcessor_UnReserveMemory(dsp_handle, blobs_dsp_vma);
		DSPProcessor_UnMap(dsp_handle, dsp_mapped_vma);
		DSPProcessor_UnReserveMemory(dsp_handle, reserved_dsp_vma);
		goto fail;
	}

	return 0;

	fail:
	DSPNode_Delete(node);

	return 1;
}

int
issue_buffer_to_dsp(void *data, int sz)
{
	struct DSP_MSG msg;
	DBAPI status;
	int aligned_size, blobs_sz;

	blobs_sz = MAX_BLOBS * sizeof(struct blob_position);

	/* Map the buffer we've been handled into the dsp memory space. I
	 * presume that this also wires the buffer into memory */
	aligned_size = (sz + 0xFFF) & ~0xFFF;
	status = DSPProcessor_Map(dsp_handle, data, aligned_size,
				reserved_dsp_vma, &dsp_mapped_vma, 0);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't map mpu memory to dsp space: %X\n",
							(uint32_t)status);
		DSPProcessor_UnReserveMemory(dsp_handle, reserved_dsp_vma);
		return 1;
	}

	/* Flush ARM's cache to memory. NOTE: this always fails for the
	 * framebuffer, so we don't do it.- it appears dspbridge expects this
	 * data to always lie in memory allocated to the process. In actuality
	 * the buffer is mmaped from a v4l fd into the process. I don't know why
	 * these two things are different, but they are.
	 * Giving it some thought, it doesn't actually matter whether this
	 * succeeds or fails: USB should be dmaing requests straight into the
	 * buffer itself, so it never actually touches the ARM cache.
	 * And we don't need to flush it for blobs, because we read them, not
	 * write them to the dsp. So actually at this point, do nothing */

	/* On second thoughts, we may as well invalidate the cache of blobs,
	 * just in case some numptie wrote to it, a flush occurs and it writes
	 * on top of what the dsp wrote */
	DSPProcessor_InvalidateMemory(dsp_handle, blobs, blobs_sz);

	/* Now send a message to dsp pointing at the chunk of memory to work
	 * on. In theory we could use some message flags to translate between
	 * mpu and dsp addresses in this, but there's no point as the map above
	 * has already given us the address */
	msg.dwCmd = MSG_START_PROCESSING;
	msg.dwArg1 = (uint32_t)dsp_mapped_vma;
	msg.dwArg2 = (uint32_t)blobs_dsp_mapped_vma;
	status = DSPNode_PutMessage(node, &msg, DSP_FOREVER);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Unable to send start message to dsp node: %x\n"
							, (uint32_t)status);
		DSPProcessor_UnMap(dsp_handle, dsp_mapped_vma);
		DSPProcessor_UnReserveMemory(dsp_handle, reserved_dsp_vma);
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
	DBAPI status;

	status = DSPNode_GetMessage(node, &msg, timeout_ms);

	/* If it timed out, return to caller */
	if (DSP_FAILED(status))
		return NULL;

	/* Happily the return procedure is now just to wait until completion and
	 * receive the done signal. We then invalidate the mpu side cache to
	 * ensure that we don't get a stale view of data */
	if (msg.dwCmd != MSG_DONE) {
		fprintf(stderr, "Got unexpected msg 0x%X from dsp while waiting"
				" for done signal\n", (uint32_t)msg.dwCmd);
		return NULL;
	}

	DSPProcessor_InvalidateMemory(dsp_handle, blobs, MAX_BLOBS *
					sizeof(struct blob_position));

	/* kdone */
	return blobs;
}

void
remove_buffer_from_dsp()
{

	DSPProcessor_UnMap(dsp_handle, dsp_mapped_vma);
	DSPProcessor_UnReserveMemory(dsp_handle, reserved_dsp_vma);
	return;
}


void
wind_up_dsp()
{

	/* We assume there's nothing in flight while we're shutting down */
	terminate(node);
	dereg_node(&uuid);
	close_dsp();
	return;
}
