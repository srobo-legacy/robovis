#ifndef _ROBOVIS_DSP_API_H_
#define _ROBOVIS_DSP_API_H_

#include "visfunc.h"

int check_dsp_open();
int open_dsp_and_prepare_buffers(int buffer_sz);
int issue_buffer_to_dsp(void *data, int sz);
struct blob_position *recv_blob_info(int timeout_ms);
void remove_buffer_from_dsp();
void wind_up_dsp();

#endif /* _ROBOVIS_DSP_API_H_ */
