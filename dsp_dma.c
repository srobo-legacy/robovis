#include <stdint.h>

#define DMA_PARAM_BASE		0x01C04000
#define DMA_PARAM_OPT		0
#define DMA_PARAM_SRCADDR	4
#define DMA_PARAM_ABCNT		8
#define DMA_PARAM_DSTADDR	0xC
#define DMA_PARAM_ABSTRIDE	0x10
#define DMA_PARAM_LNK		0x14
#define DMA_PARAM_CDSTRIDE	0x18
#define DMA_PARAM_CCNT		0x1C

/* Note to self - the following doesn't trigger Alistairs alignment checker */
#define PUT_DMA_CONF(val, field, param) *((uint32_t*)(DMA_PARAM_BASE + ((param) * 0x20) + (field))) = (val);

void
setup_simple_dma(void *src, void *dst, uint16_t cnt)
{

	/* Rather than playing about with a million and one different config
	 * knobs that TIs DMA controller has, start a single, 1D transfer from
	 * one point to another. */

	/* All zeros config - no interrupts, chaining, weird completion, weird
	 * fifo situations. Just a 1D transfer. */
	PUT_DMA_CONF(0, DMA_PARAM_OPT, 0);
	PUT_DMA_CONF((uint32_t)src, DMA_PARAM_SRCADDR, 0);
	PUT_DMA_CONF(0x10000 | cnt, DMA_PARAM_ABCNT, 0);
	PUT_DMA_CONF((uint32_t)dst, DMA_PARAM_DSTADDR, 0);
	PUT_DMA_CONF(0, DMA_PARAM_ABSTRIDE, 0);
	PUT_DMA_CONF(0, DMA_PARAM_LNK, 0);
	PUT_DMA_CONF(0, DMA_PARAM_CDSTRIDE, 0);
	PUT_DMA_CONF(1, DMA_PARAM_CCNT, 0);

	return;
}
