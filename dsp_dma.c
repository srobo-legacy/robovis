#include <stdint.h>

#define REG(addr) *(uint32_t*)((addr))

#define DMA_TPCC_CCERR		0x01C00318
#define DMA_TPCC_EEVAL		0x01C00320
#define DMA_TPCC_DRAEL		0x01C00340
#define DMA_TPCC_DRAEH		0x01C00344

#define DMA_TPCC_QESTAT		0x01C00400
#define DMA_TPCC_QSTAT0		0x01C00600
#define DMA_TPCC_QSTAT1		0x01C00600
#define GET_QESTAT(q, e) REG(DMA_TPCC_QESTAT + (q*0x40) + (e*4))
#define DMA_TPCC_CCSTAT		0x01C00640

#define DMA_TPCC_MPFAR		0x01C00800
#define DMA_TPCC_MPFSR		0x01C00804
#define DMA_TPCC_MPFCR		0x01C00808
#define DMA_TPCC_MPPAG		0x01C0080C
#define DMA_TPCC_MPPABASE	0x01C00810
#define DMA_TPCC_MPAA(r) REG(DMA_TPCC_MPPABASE + (r * 4))

#define DMA_TPCC_ER		0x01C01000
#define DMA_TPCC_ESRL		0x01C01010
#define DMA_TPCC_ECRL		0x01C01018
#define DMA_TPCC_IPRL		0x01C01068
#define DMA_TPCC_ICRL		0x01C01070

#define DMA_TPTC_INTEN		0x01C10108
#define DMA_TPTC_ERRSTAT	0x01C10120
#define DMA_TPTC_ERRDET		0x01C1012C
#define DMA_TPTC_RDRATE		0x01C10140

#define PUT_DRAEL(val, idx) REG(DMA_TPCC_DRAEL + ((idx) * 8)) = (val)
#define PUT_DRAEH(val, idx) REG(DMA_TPCC_DRAEH + ((idx) * 8)) = (val)
#define PUT_TPTC_REG(val, reg, tptc) REG(reg + (tptc*0x400)) = (val)

#define PUT_DMA_CHAN_MAP(param, chan) REG(0x01C00100+(chan*4)) = ((param) << 5)

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
	PUT_DRAEL(0xFFFFFFFF, 0);
	PUT_DRAEL(0xFFFFFFFF, 1);
	PUT_DRAEL(0xFFFFFFFF, 2);
	PUT_DRAEL(0xFFFFFFFF, 3);
	PUT_DRAEL(0xFFFFFFFF, 4);
	PUT_DRAEL(0xFFFFFFFF, 5);
	PUT_DRAEL(0xFFFFFFFF, 6);
	PUT_DRAEL(0xFFFFFFFF, 7);
	PUT_DRAEH(0xFFFFFFFF, 0);
	PUT_DRAEH(0xFFFFFFFF, 1);
	PUT_DRAEH(0xFFFFFFFF, 2);
	PUT_DRAEH(0xFFFFFFFF, 3);
	PUT_DRAEH(0xFFFFFFFF, 4);
	PUT_DRAEH(0xFFFFFFFF, 5);
	PUT_DRAEH(0xFFFFFFFF, 6);
	PUT_DRAEH(0xFFFFFFFF, 7);

	for (int i = 0; i < 508; i++)
		DMA_TPCC_MPAA(i) = 0xFEFF;

	return;
}

void
setup_simple_dma(void *src, void *dst, uint16_t cnt)
{

	/* Rather than playing about with a million and one different config
	 * knobs that TIs DMA controller has, start a single, 1D transfer from
	 * one point to another. */

	/* Clear first channels intr bit, just in case */
	REG(DMA_TPCC_ICRL) = 1;

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
	REG(DMA_TPCC_ECRL) = 1;
	REG(DMA_TPCC_ESRL) = 1;

	return;
}

void
wait_for_dma_completion()
{

	while ((REG(DMA_TPCC_IPRL) & 1) == 0)
		;

	/* Clear intr 1 */
	REG(DMA_TPCC_ICRL) = 1;
}
