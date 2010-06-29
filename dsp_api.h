#ifndef _ROBOVIS_DSP_API_H_
#define _ROBOVIS_DSP_API_H_

#include "visfunc.h"

int open_dsp_and_prepare_buffers(int buffer_sz);
int issue_buffer_to_dsp(void *data, int sz);
int recv_blob_info(struct blob_positions *blobs, int max_num, int timeout_ms);
void wind_up_dsp();

#endif /* _ROBOVIS_DSP_API_H_ */
