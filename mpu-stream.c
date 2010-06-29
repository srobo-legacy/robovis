#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <dbapi.h>

bool dsp_open = false;
DSP_HPROCESSOR dsp_handle = NULL;

int
check_dsp_open()
{
	DBAPI status;

	if (dsp_open)
		return 0;

	status = DspManager_Open(0, NULL);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't open dsp manager, %X\n", status);
		return 1;
	}

	status = DSPProcessor_Attach(0, NULL, &dsp_handle);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't attach to dsp 0: %X\n", status);
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

DSP_HNODE
register_and_create(struct DSP_UUID *uuid)
{
	struct DSP_MSG msg;
	DSP_HNODE node;
	DBAPI status, retval;

	retval = 0xFACEBEE5;

	/* Generate a uuid to feed bridge api */
	uuid->ulData1 = 0x7129518D;
	uuid->usData2 = 0xCB99;
	uuid->usData3 = 0x449C;
	uuid->ucData4 = 0x80;
	uuid->ucData5 = 0x20;
	uuid->ucData6[0] = 0x5B;
	uuid->ucData6[1] = 0xBE;
	uuid->ucData6[2] = 0x90;
	uuid->ucData6[3] = 0xCA;
	uuid->ucData6[4] = 0xD8;
	uuid->ucData6[5] = 0xA0;
	DSPManager_UnregisterObject(uuid, DSP_DCDNODETYPE);
	DSPManager_UnregisterObject(uuid, DSP_DCDLIBRARYTYPE);

	status = DSPManager_RegisterObject(uuid, DSP_DCDNODETYPE,
						"dsp-stream.doff");
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't register file, doff missing?\n");
		return NULL;
	}
	status = DSPManager_RegisterObject(uuid, DSP_DCDLIBRARYTYPE,
						"dsp-stream.doff");
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't register file, doff missing?\n");
		return NULL;
	}

	/* Right - it's registered. Now lets try and run it. */
	status = DSPNode_Allocate(dsp_handle, uuid, NULL, NULL, &node);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Failed to allocate node (%X): not a "
				"code problem, something else?\n", status);
		return NULL;
	}

	return node;
}

int
terminate(DSP_HNODE node)
{
	DBAPI status;
	DSP_STATUS retval;

	status = DSPNode_Delete(node);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Error deleting node, %X\n");
	}

	status = DSPNode_Terminate(node, &retval);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't terminate node, %X\n", status);
	}

	return 0;
}

void
dereg_node(struct DSP_UUID *uuid)
{

	DSPManager_UnregisterObject(uuid, DSP_DCDNODETYPE);
	DSPManager_UnregisterObject(uuid, DSP_DCDLIBRARYTYPE);
}

int
main(int argc, char **argv)
{
	uint8_t output_buffer[1024];
	uint8_t input_buffer[1024];
	struct DSP_UUID uuid;
	struct DSP_STRMATTR attrs;
	uint8_t *reclaimed;
	DSP_HNODE node;
	DSP_HSTREAM str_in, str_out;
	unsigned long reclaimed_bytes, reclaimed_sz, reclaimed_baton;
	DBAPI status;

	if (check_dsp_open()) {
		fprintf(stderr, "Can't open DSP\n");
		return 1;
	}

printf("deathcakes %s %d\n", __FILE__, __LINE__);
	/* Register and create the dsp node, but don't create */
	node = register_and_create(&uuid);
	if (node == NULL) {
		fprintf(stderr, "Couldn't allocate dsp node\n");
		return 1;
	}

	/* Create some streams to plug into dsp node */
	attrs.uSegid = 0;
	attrs.uBufsize = 256; /* Words not byte */
	attrs.uNumBufs = 1;
	attrs.uAlignment = 0;
	attrs.uTimeout = 10000; /* No idea what scale this is */
	attrs.lMode = STRMMODE_PROCCOPY;

printf("deathcakes %s %d\n", __FILE__, __LINE__);
	status = DSPNode_Connect(node, 0, (void*)DSP_HGPPNODE, 0, &attrs);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't create dsp output stream, %X\n",
				status);
		return 1;
	}

printf("deathcakes %s %d\n", __FILE__, __LINE__);
	status = DSPNode_Connect((void*)DSP_HGPPNODE, 0, node, 0, &attrs);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't create dsp intpu stream, %X\n",
				status);
		return 1;
	}

	/* Hmkay, now it should be possible to create and execute node */
printf("deathcakes %s %d\n", __FILE__, __LINE__);
	status = DSPNode_Create(node);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't create dsp node: %X\n", status);
		goto out;
	}
printf("deathcakes %s %d\n", __FILE__, __LINE__);

	status = DSPNode_Run(node);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't run dsp node: %X\n", status);
		goto out;
	}
printf("deathcakes %s %d\n", __FILE__, __LINE__);

	status = DSPStream_Open(node, DSP_TONODE, 0, NULL, &str_in);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't open dsp input stream (%X)\n",
				status);
		goto streamout;
	}

	status = DSPStream_Open(node, DSP_FROMNODE, 0, NULL, &str_out);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't open dsp output stream (%X)\n",
				status);
		goto streamout;
	}
printf("deathcakes %s %d\n", __FILE__, __LINE__);

	status = DSPStream_PrepareBuffer(str_in, sizeof(input_buffer),
							input_buffer);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't prepare dsp input buffer\n");
		goto streamout;
	}

	status = DSPStream_PrepareBuffer(str_out, sizeof(output_buffer),
							output_buffer);
	if (DSP_FAILED(status)) {
		fprintf(stderr,  "Couldn't prepare dsp output buffer\n");
		goto streamout;
	}

	/* Actually do some things */
	memset(input_buffer, 0, sizeof(input_buffer));
	memset(output_buffer, 0, sizeof(output_buffer));
printf("deathcakes %s %d\n", __FILE__, __LINE__);

	/* Put buffer into streams - zeros should arrive at dsp */
	status = DSPStream_Issue(str_in, input_buffer, 1024, 1024, 0);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't issue buffer to input stream: %X\n",
				status);
		goto streamout;
	}

	status = DSPStream_Reclaim(str_in, &reclaimed, &reclaimed_bytes,
					&reclaimed_sz, &reclaimed_baton);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't retrieve buffer from input stream: "
				"%X\n", status);
		goto streamout;
	}

	/* Now issue buffer into output stream, retrieve output */
	status = DSPStream_Issue(str_out, output_buffer, 1024, 1024, 0);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't put output buffer into stream: %X\n",	
				status);
		goto streamout;
	}

	status = DSPStream_Reclaim(str_out, &reclaimed, &reclaimed_bytes,
					&reclaimed_sz, &reclaimed_baton);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't retrieve output buffer from stream: "
				"%X\n", status);
		goto streamout;
	}

printf("deathcakes %s %d\n", __FILE__, __LINE__);
	/* Let's actually see whether anything happened to it */
	if (reclaimed_bytes != 1024) {
		fprintf(stderr, "Reclaimed buffer is not of expected size\n");
	} else {
		memset(input_buffer, 1, sizeof(input_buffer));
		if (!memcmp(reclaimed, input_buffer, reclaimed_bytes)) {
			fprintf(stderr, "It matched! :O\n");
		} else {
			fprintf(stderr, "Data in output buffer didn't match\n");
		}
	}

	streamout:
printf("deathcakes %s %d\n", __FILE__, __LINE__);
	DSPStream_UnprepareBuffer(str_in, sizeof(input_buffer), input_buffer);
	DSPStream_UnprepareBuffer(str_out, sizeof(output_buffer),output_buffer);

	status = DSPStream_Close(str_in);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldn't close dsp input stream (%X)\n",
				status);
	}

	status = DSPStream_Close(str_out);
	if (DSP_FAILED(status)) {
		fprintf(stderr, "Couldnt close ddsp output stream (%X)\n",
				status);
	}
printf("deathcakes %s %d\n", __FILE__, __LINE__);

	out:
	terminate(node);
	dereg_node(&uuid);
	close_dsp();

	return 0;
}
