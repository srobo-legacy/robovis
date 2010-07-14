#include <stdint.h>

#define DMA_TPCC_ESR0		0x01C01010

#define DMA_TPTC_INTEN		0x01C10108
#define DMA_TPTC_RDRATE		0x01C10140

#define PUT_REG(addr) *(uint32_t*)((addr))
#define PUT_TPTC_REG(val, reg, tptc) PUT_REG(reg + (tptc*0x400)) = (val)

#define PUT_DMA_CHAN_MAP(param, chan) PUT_REG(0x01C00100+(chan*4)) = ((param) << 5)

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
configure_dma()
{

	/* No interrupts, ever */
	PUT_TPTC_REG(0, DMA_TPTC_INTEN, 0);
	/* Fastest read possible */
	PUT_TPTC_REG(0, DMA_TPTC_RDRATE, 0);
	/* Map param entry 0 to dma channel 0 */
	PUT_DMA_CHAN_MAP(0, 0);

	/* XXX - will bridgedriver firmware enable DMA accesses in DRAE? */
	return;
}

void
setup_simple_dma(void *src, void *dst, uint16_t cnt)
{

	/* Rather than playing about with a million and one different config
	 * knobs that TIs DMA controller has, start a single, 1D transfer from
	 * one point to another. */

	/* Options bit - generate intr on completion. This never reaches the
	 * processor because TPCC IER isn't enabled, but we can poll the intr
	 * status register to detect completion */
	PUT_DMA_CONF(0x100000, DMA_PARAM_OPT, 0);
	PUT_DMA_CONF((uint32_t)src, DMA_PARAM_SRCADDR, 0);
	PUT_DMA_CONF(0x10000 | cnt, DMA_PARAM_ABCNT, 0);
	PUT_DMA_CONF((uint32_t)dst, DMA_PARAM_DSTADDR, 0);
	PUT_DMA_CONF(0, DMA_PARAM_ABSTRIDE, 0);
	PUT_DMA_CONF(0, DMA_PARAM_LNK, 0);
	PUT_DMA_CONF(0, DMA_PARAM_CDSTRIDE, 0);
	PUT_DMA_CONF(1, DMA_PARAM_CCNT, 0);

	/* Trigger event 0, starting DMA channel 0 */
	PUT_REG(DMA_TPCC_ESR0) = 1;

	return;
}
