	.file	"visfunc.c"


#define		ST_RETADDR	4
#define		ST_SAVED_A10	8
#define		ST_SAVED_A11	12
#define		ST_SAVED_A12	16
#define		ST_SAVED_A13	20
#define		ST_WIDTH	28
#define		ST_RAW_DATA	48
	.text
	.globl	vis_find_blobs_through_scanlines
	.align	5
	.type	vis_find_blobs_through_scanlines,@function
vis_find_blobs_through_scanlines:
		mvk		136,	A0
	||	mv		B15,	A1
		stw		A15,	*B15
	||	stw		B3,	*-A1(ST_RETADDR)
	||	mv		B15,	A15
	||	sub		B15,	A0	,B15

		stw		A10,	*-A15(ST_SAVED_A10)
		stw		A11,	*-A15(ST_SAVED_A11)
		stw		A12,	*-A15(ST_SAVED_A12)
		stw		A13,	*-A15(ST_SAVED_A13)
		mv		B6,	A10
		mv		A6,	A11
		mv		B4,	A3
		stw		A3,	*-A15(ST_WIDTH)
		mv		A4,	A0
		stw		A0,	*-A15(ST_RAW_DATA)
		mvkl	.S1	dma_buffer,	A3
		mvkl	.S1	284180480,	A5
		mvkl	.S1	working_buffer,	A6
		mvkl	.S1	284196864,	A7
		mvkh	.S1	dma_buffer,	A3
		mvkh	.S1	284180480,	A5
		mvkh	.S1	working_buffer,	A6
		mvkh	.S1	284196864,	A7
		stw		A5,	*A3
		stw		A7,	*A6
		sub	.D2	B15,	0,	B15
		mvk	.S1	15360,	A6
		mvk	.S1	0,	A12
		mvkl	.S1	blobs,	A13
		mv		A5,	B4
		callp	.S2	setup_simple_dma
		add	.D2X	B15,	A12,	B15
		mvkh	.S1	blobs,	A13
		stw		A10,	*A13
		mvkl	.S1	32768,	A6
		sub	.D2	B15,	0,	B15
		mvkh	.S1	32768,	A6
		mvkl	.S1	num_blobs,	A13
		mv		A10,	A4
		mv		A12,	B4
		callp	.S2	memset
		add	.D2X	B15,	A12,	B15
		mvkl	.S1	spans,	A3
		mvkh	.S1	num_blobs,	A13
		mvkl	.S1	spans_a,	A4
		mvkl	.S1	ospans,	A5
		mvkl	.S1	spans_b,	A10
		mvkh	.S1	spans,	A3
		stw		A12,	*A13
		mvkh	.S1	spans_a,	A4
		mvkh	.S1	ospans,	A5
		stw		A4,	*A3
		mvkh	.S1	spans_b,	A10
		stw		A10,	*A5
		sub	.D2	B15,	0,	B15
		mvk	.S1	1056,	A13
		mv		A12,	B4
		mv		A13,	A6
		callp	.S2	memset
		add	.D2X	B15,	A12,	B15
		mvkl	.S1	span,	A14
		sub	.D2	B15,	0,	B15
		mv		A10,	A4
		mv		A12,	B4
		mv		A13,	A6
		callp	.S2	memset
		add	.D2X	B15,	A12,	B15
		mvkh	.S1	span,	A14
		cmpeq	.L1	-1,	A11,	A3
		stw		A12,	*A14
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_122
		nop	.S1	4

		ldw		*-A15(28),	A3
		nop	.S1	4
		mv		A3,	A0
		stw		A0,	*-A15(100)
		mv		A11,	A1
		mvk	.S1	-32,	A3
		stw		A1,	*A15(A3)
		mvk	.S1	1,	A3
		add	.L1	A1,	1,	A4
		cmpgtu	.L1	A4,	A3,	A5
		mv		A5,	A1
	[!A1]	mv	.S1	A3,	A4
		mvkl	.S1	204800,	A3
		mvkl	.S1	spans_a,	A5
		mvkl	.S1	spans_b,	A6
		mvk	.S1	15360,	A7
		mvk	.S1	0,	A8
		ldw		*-A15(48),	A1
		nop	.S1	4
		add	.L1	A1,	A7,	A7
		shl	.S1	A0,	1,	A9
		add	.L1	A4,	-1,	A4
		mvkh	.S1	204800,	A3
		mvk	.S1	320,	A16
		mvkh	.S1	spans_a,	A5
		mvkh	.S1	spans_b,	A6
		mv		A7,	A0
		stw		A0,	*-A15(112)
		mv		A9,	A0
		stw		A0,	*-A15(124)
		mv		A4,	A0
		mvk	.S1	-33,	A4
		stw		A0,	*A15(A4)
		mv		A8,	A0
		stw		A0,	*-A15(76)
		mv		A3,	A0
		stw		A0,	*-A15(116)
		mv		A16,	A0
		stw		A0,	*-A15(120)
		mv		A8,	A0
		stw		A0,	*-A15(28)
		mv		A5,	A1
		stw		A1,	*-A15(36)
		mv		A6,	A1
		stw		A1,	*-A15(32)
		mv		A0,	A1
		stw		A1,	*-A15(96)
		stw		A0,	*-A15(108)
.BB1_2:

		mvk	.S1	0,	A10
		sub	.D2	B15,	0,	B15
		mvk	.S1	1056,	A6
		ldw		*-A15(32),	A0
		nop	.S1	4
		mv		A0,	A4
		mv		A10,	B4
		callp	.S2	memset
		add	.D2X	B15,	A10,	B15
		mvk	.S1	-23,	A3
		add	.L1	A15,	A3,	A3
		mvkl	.S1	ospans,	A4
		mvkl	.S1	spans,	A5
		mvkh	.S1	ospans,	A4
		stb		A10,	*-A15(23)
		stb		A10,	*+A3(1)
		stb		A10,	*+A3(2)
		mvkl	.S1	ospan,	A3
		mvkh	.S1	spans,	A5
		ldw		*-A15(36),	A1
		nop	.S1	4
		stw		A1,	*A4
		mvkl	.S1	span,	A4
		mvkh	.S1	ospan,	A3
		ldw		*-A15(32),	A0
		nop	.S1	4
		stw		A0,	*A5
		mvkh	.S1	span,	A4
		ldw		*-A15(28),	A0
		nop	.S1	4
		stw		A0,	*A3
		stw		A10,	*A4
		mvk	.S1	-32,	A3
		ldw		*A15(A3),	A0
		nop	.S1	4
		ldw		*-A15(96),	A1
		nop	.S1	4
		cmpeq	.L1	A0,	A1,	A3
		mv		A3,	A0
	[!A0]	b	.S1	.BB1_4
		nop	.S1	4

		b	.S1	.BB1_110
		nop	.S1	4
.BB1_4:

		mvk	.S1	0,	A10
		sub	.D2	B15,	0,	B15
		mvk	.S1	24,	A3
		ldw		*-A15(96),	A0
		nop	.S1	4
		mv		A0,	A4
		mv		A3,	B4
		callp	.S2	__remu
		add	.D2X	B15,	A10,	B15
		cmpeq	.L1	0,	A4,	A3
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_6
		nop	.S1	4

		b	.S1	.BB1_7
		nop	.S1	4
.BB1_6:

		mvk	.S1	8,	A10
		sub	.D2	B15,	8,	B15
		mvkl	.S1	dma_buffer,	A11
		mvkl	.S1	working_buffer,	A12
		callp	.S2	wait_for_dma_completion
		add	.D2X	B15,	A10,	B15
		mvkh	.S1	dma_buffer,	A11
		mvkh	.S1	working_buffer,	A12
		ldw		*A11,	A0
		nop	.S1	4
		stw		A0,	*-A15(48)
		ldw		*A12,	A3
		nop	.S1	4
		mvk	.S1	24,	A4
		stw		A3,	*A11
		mvkl	.S1	65535,	A5
		mvk	.S1	15360,	A6
		ldw		*-A15(120),	A1
		nop	.S1	4
		cmplt	.L1	A1,	A4,	A4
		stw		A0,	*A12
		mv		A4,	A0
		ldw		*-A15(116),	A1
		nop	.S1	4
		mv		A1,	A10
	[!A0]	mv	.S1	A6,	A10
		mvkh	.S1	65535,	A5
		mvk	.S1	0,	A11
		sub	.D2	B15,	0,	B15
		and	.L1	A10,	A5,	A6
		ldw		*-A15(112),	A0
		nop	.S1	4
		mv		A0,	A4
		mv		A3,	B4
		callp	.S2	setup_simple_dma
		add	.D2X	B15,	A11,	B15
		ldw		*-A15(112),	A0
		nop	.S1	4
		mv		A0,	A3
		add	.L1	A3,	A10,	A3
		mv		A3,	A0
		stw		A0,	*-A15(112)
		mv		A11,	A0
		stw		A0,	*-A15(108)
.BB1_7:

		mvk	.S1	0,	A3
		ldw		*-A15(124),	A0
		nop	.S1	4
		ldw		*-A15(108),	A1
		nop	.S1	4
		mpy32	.M1	A0,	A1,	A4
		nop	.S1	3
		mv		A4,	A0
		stw		A0,	*-A15(64)
		mv		A3,	A0
		stw		A0,	*-A15(44)
		mv		A3,	A1
		stw		A1,	*-A15(60)
		mv		A0,	A1
		stw		A1,	*-A15(52)
		stw		A0,	*-A15(32)
.BB1_8:

		ldw		*-A15(44),	A0
		nop	.S1	4
		and	.L1	-4,	A0,	A3
		ldw		*-A15(64),	A0
		nop	.S1	4
		add	.L1	A3,	A0,	A3
		or	.D1	1,	A3,	A4
		ldw		*-A15(52),	A0
		nop	.S1	4
		and	.L1	1,	A0,	A5
		shr	.S1	A4,	0,	A4
		ldw		*-A15(48),	A0
		nop	.S1	4
		add	.L1	A3,	A0,	A6
		ldbu		*A0(A4),	A0
		nop	.S1	4
		stw		A0,	*-A15(28)
		ldbu		*+A6(3),	A0
		nop	.S1	4
		cmpeq	.L1	0,	A5,	A4
		mv		A3,	A1
		mv		A4,	A2
	[ A2]	b	.S1	.BB1_10
		nop	.S1	4

		ldw		*-A15(48),	A2
		nop	.S1	4
		add	.L1	A1,	A2,	A1
		ldbu		*+A1(2),	A1
		nop	.S1	4
		b	.S1	.BB1_11
		nop	.S1	4
.BB1_10:

		shr	.S1	A1,	0,	A1
		ldw		*-A15(48),	A2
		nop	.S1	4
		ldbu		*A2(A1),	A1
		nop	.S1	4
.BB1_11:

		mvk	.S1	298,	A3
		addk	.S1	-128,	A0
		mvk	.S1	409,	A4
		mpy32	.M1	A1,	A3,	A3
		nop	.S1	3
		mvk	.S1	-4768,	A5
		add	.L1	A3,	A5,	A3
		mpy32	.M1	A0,	A4,	A4
		nop	.S1	3
		add	.L1	A4,	A3,	A4
		addk	.S1	128,	A4
		mvk	.S1	-1,	A5
		ldw		*-A15(28),	A1
		nop	.S1	4
		addk	.S1	-128,	A1
		cmpgt	.L1	A4,	A5,	A5
		stw		A1,	*-A15(36)
		mv		A3,	A1
		stw		A1,	*-A15(56)
		mv		A5,	A1
	[ A1]	b	.S1	.BB1_13
		nop	.S1	4

		mvk	.S1	0,	A4
		mv		A4,	A1
		stw		A1,	*-A15(40)
		b	.S1	.BB1_14
		nop	.S1	4
.BB1_13:

		mv		A4,	A1
		mvk	.S1	0,	A3
		shr	.S1	A1,	8,	A4
		mvk	.S1	255,	A5
		cmpgt	.L1	A4,	A5,	A6
		cmplt	.L1	A1,	A3,	A7
		mv		A6,	A1
	[!A1]	mv	.S1	A3,	A5
		or	.D1	A6,	A7,	A3
		mv		A3,	A1
	[!A1]	mv	.S1	A4,	A5
		mv		A5,	A1
		stw		A1,	*-A15(40)
.BB1_14:

		mvk	.S1	100,	A3
		mvk	.S1	128,	A4
		ldw		*-A15(36),	A1
		nop	.S1	4
		mpy32	.M1	A1,	A3,	A3
		nop	.S1	3
		mvk	.S1	208,	A5
		sub	.L1	A4,	A3,	A3
		mpy32	.M1	A0,	A5,	A4
		nop	.S1	3
		sub	.L1	A3,	A4,	A3
		ldw		*-A15(56),	A0
		nop	.S1	4
		add	.L1	A3,	A0,	A3
		mvk	.S1	-1,	A4
		cmpgt	.L1	A3,	A4,	A4
		mv		A4,	A0
	[ A0]	b	.S1	.BB1_16
		nop	.S1	4

		mvk	.S1	0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(28)
		b	.S1	.BB1_17
		nop	.S1	4
.BB1_16:

		mv		A3,	A0
		mvk	.S1	0,	A3
		shr	.S1	A0,	8,	A4
		mvk	.S1	255,	A5
		cmpgt	.L1	A4,	A5,	A6
		cmplt	.L1	A0,	A3,	A7
		mv		A6,	A0
	[!A0]	mv	.S1	A3,	A5
		or	.D1	A6,	A7,	A3
		mv		A3,	A0
	[!A0]	mv	.S1	A4,	A5
		mv		A5,	A0
		stw		A0,	*-A15(28)
.BB1_17:

		mvk	.S1	516,	A3
		ldw		*-A15(36),	A0
		nop	.S1	4
		mpy32	.M1	A0,	A3,	A3
		nop	.S1	3
		ldw		*-A15(56),	A0
		nop	.S1	4
		add	.L1	A3,	A0,	A3
		addk	.S1	128,	A3
		mvk	.S1	-1,	A4
		cmpgt	.L1	A3,	A4,	A4
		mv		A4,	A0
	[ A0]	b	.S1	.BB1_19
		nop	.S1	4

		mvk	.S1	0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(36)
		b	.S1	.BB1_20
		nop	.S1	4
.BB1_19:

		mv		A3,	A0
		mvk	.S1	0,	A3
		shr	.S1	A0,	8,	A4
		mvk	.S1	255,	A5
		cmpgt	.L1	A4,	A5,	A6
		cmplt	.L1	A0,	A3,	A7
		mv		A6,	A0
	[!A0]	mv	.S1	A3,	A5
		or	.D1	A6,	A7,	A3
		mv		A3,	A0
	[!A0]	mv	.S1	A4,	A5
		mv		A5,	A0
		stw		A0,	*-A15(36)
.BB1_20:

		ldw		*-A15(28),	A0
		nop	.S1	4
		ldw		*-A15(36),	A1
		nop	.S1	4
		cmpgt	.L1	A0,	A1,	A3
		cmplt	.L1	A0,	A1,	A4
		mv		A3,	A2
		mv		A0,	A3
	[!A2]	mv	.S1	A1,	A3
		mv		A4,	A2
	[!A2]	mv	.S1	A1,	A0
		ldw		*-A15(40),	A1
		nop	.S1	4
		mv		A1,	A4
		cmpgt	.L1	A4,	A3,	A4
		mv		A1,	A5
		cmplt	.L1	A5,	A0,	A5
		mv		A4,	A2
		mv		A1,	A4
	[!A2]	mv	.S1	A3,	A4
		mv		A5,	A2
	[!A2]	mv	.S1	A0,	A1
		cmpeq	.L1	0,	A4,	A3
		mv		A3,	A0
	[!A0]	b	.S1	.BB1_22
		nop	.S1	4

		mvk	.S1	0,	A4
		mv		A4,	A1
		stw		A1,	*-A15(28)
		b	.S1	.BB1_27
		nop	.S1	4
.BB1_22:

		mv		A4,	A0
		cmpeq	.L1	A0,	A1,	A3
		mv		A3,	A2
	[!A2]	b	.S1	.BB1_24
		nop	.S1	4

		mvk	.S1	0,	A4
		mv		A4,	A0
		b	.S1	.BB1_26
		nop	.S1	4
.BB1_24:

		sub	.L1	A4,	A1,	A3
		mv		A3,	A1
		mvk	.S1	0,	A3
		ldw		*-A15(28),	A2
		nop	.S1	4
		mv		A2,	A4
		ldw		*-A15(36),	A2
		nop	.S1	4
		mv		A2,	A5
		sub	.L1	A4,	A5,	A4
		ldw		*-A15(40),	A2
		nop	.S1	4
		cmpeq	.L1	A0,	A2,	A5
		mvkl	.S1	trans_table,	A6
		shl	.S1	A1,	2,	A7
		mv		A5,	A1
	[!A1]	mv	.S1	A3,	A4
		ldw		*-A15(36),	A1
		nop	.S1	4
		mv		A1,	A3
		sub	.L1	A3,	A2,	A3
		ldw		*-A15(28),	A1
		nop	.S1	4
		mv		A1,	A8
		cmpeq	.L1	A0,	A8,	A5
		mv		A5,	A1
	[!A1]	mv	.S1	A4,	A3
		ldw		*-A15(28),	A1
		nop	.S1	4
		mv		A1,	A4
		sub	.L1	A2,	A4,	A4
		ldw		*-A15(36),	A1
		nop	.S1	4
		mv		A1,	A8
		cmpeq	.L1	A0,	A8,	A0
		mvkh	.S1	trans_table,	A6
		shr	.S1	A7,	2,	A7
	[!A0]	mv	.S1	A3,	A4
		ldw		*A6(A7),	A3
		nop	.S1	4
		mvkl	.S1	262144,	A6
		mpy32	.M1	A4,	A3,	A3
		nop	.S1	3
		mvk	.S1	15,	A4
		mpy32	.M1	A3,	A4,	A3
		nop	.S1	3
		mvkh	.S1	262144,	A6
		add	.L1	A3,	A6,	A3
		shr	.S1	A3,	19,	A3
		mv		A3,	A4
		addk	.S1	60,	A4
		mv		A5,	A1
	[!A1]	mv	.S1	A3,	A4
		mv		A4,	A3
		addk	.S1	120,	A3
	[!A0]	mv	.S1	A4,	A3
		mvk	.S1	255,	A0
		cmpgt	.L1	A3,	A0,	A0
	[ A0]	b	.S1	.BB1_123
		nop	.S1	4

		mv		A3,	A0
.BB1_26:

		mvk	.S1	0,	A3
		cmplt	.L1	A0,	A3,	A4
		mv		A4,	A1
	[!A1]	mv	.S1	A0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(28)
.BB1_27:

		mvk	.S1	255,	A3
		ldw		*-A15(60),	A0
		nop	.S1	4
		add	.L1	A0,	1,	A4
		and	.L1	A0,	A3,	A10
		mvk	.S1	0,	A11
		sub	.D2	B15,	0,	B15
		and	.L1	A4,	A3,	A4
		mvk	.S1	3,	A3
		ldw		*-A15(52),	A0
		nop	.S1	4
		add	.L1	A0,	1,	A12
		mv		A3,	B4
		callp	.S2	__remu
		add	.D2X	B15,	A11,	B15
		mv		A4,	A0
		stw		A0,	*-A15(60)
		mvk	.S1	-23,	A3
		add	.L1	A15,	A3,	A3
		shr	.S1	A10,	0,	A4
		ldw		*-A15(44),	A0
		nop	.S1	4
		add	.L1	A0,	2,	A5
		ldw		*-A15(28),	A0
		nop	.S1	4
		ldw		*-A15(32),	A1
		nop	.S1	4
		add	.L1	A0,	A1,	A6
		cmpeq	.L1	3,	A12,	A7
		stb		A0,	*A3(A4)
		mv		A6,	A1
		stw		A1,	*-A15(32)
		mv		A12,	A0
		stw		A0,	*-A15(52)
		mv		A5,	A0
		stw		A0,	*-A15(44)
		mv		A7,	A0
	[ A0]	b	.S1	.BB1_29
		nop	.S1	4

		b	.S1	.BB1_8
		nop	.S1	4
.BB1_29:

		mvk	.S1	3,	A3
		ldw		*-A15(100),	A0
		nop	.S1	4
		cmpgt	.L1	A0,	A3,	A3
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_31
		nop	.S1	4

		mvk	.S1	3,	A3
		mv		A3,	A0
		b	.S1	.BB1_88
		nop	.S1	4
.BB1_31:

		mvk	.S1	3,	A0
		mvk	.S1	0,	A3
		mvk	.S1	6,	A4
		ldw		*-A15(124),	A1
		nop	.S1	4
		ldw		*-A15(108),	A2
		nop	.S1	4
		mpy32	.M1	A1,	A2,	A5
		nop	.S1	3
		mv		A5,	A1
		stw		A1,	*-A15(104)
		mv		A0,	A1
		stw		A1,	*-A15(60)
		stw		A0,	*-A15(68)
		mv		A4,	A0
		stw		A0,	*-A15(80)
		mv		A3,	A0
		stw		A0,	*-A15(72)
		mv		A3,	A1
		stw		A1,	*-A15(52)
		stw		A0,	*-A15(92)
		mv		A1,	A0
		stw		A0,	*-A15(56)
.BB1_32:

		ldw		*-A15(80),	A0
		nop	.S1	4
		and	.L1	-4,	A0,	A0
		ldw		*-A15(104),	A1
		nop	.S1	4
		add	.L1	A0,	A1,	A0
		or	.D1	1,	A0,	A3
		ldw		*-A15(68),	A1
		nop	.S1	4
		and	.L1	1,	A1,	A4
		shr	.S1	A3,	0,	A3
		ldw		*-A15(48),	A1
		nop	.S1	4
		add	.L1	A0,	A1,	A5
		ldbu		*A1(A3),	A1
		nop	.S1	4
		stw		A1,	*-A15(28)
		ldbu		*+A5(3),	A1
		nop	.S1	4
		cmpeq	.L1	0,	A4,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_34
		nop	.S1	4

		ldw		*-A15(48),	A2
		nop	.S1	4
		add	.L1	A0,	A2,	A0
		ldbu		*+A0(2),	A0
		nop	.S1	4
		b	.S1	.BB1_35
		nop	.S1	4
.BB1_34:

		shr	.S1	A0,	0,	A0
		ldw		*-A15(48),	A2
		nop	.S1	4
		ldbu		*A2(A0),	A0
		nop	.S1	4
.BB1_35:

		mvk	.S1	298,	A3
		addk	.S1	-128,	A1
		mvk	.S1	409,	A4
		mpy32	.M1	A0,	A3,	A0
		nop	.S1	3
		mvk	.S1	-4768,	A3
		add	.L1	A0,	A3,	A0
		mpy32	.M1	A1,	A4,	A3
		nop	.S1	3
		add	.L1	A3,	A0,	A3
		addk	.S1	128,	A3
		mvk	.S1	-1,	A4
		ldw		*-A15(28),	A2
		nop	.S1	4
		addk	.S1	-128,	A2
		cmpgt	.L1	A3,	A4,	A4
		stw		A2,	*-A15(36)
		stw		A0,	*-A15(28)
		mv		A4,	A0
	[ A0]	b	.S1	.BB1_37
		nop	.S1	4

		mvk	.S1	0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(40)
		b	.S1	.BB1_38
		nop	.S1	4
.BB1_37:

		mv		A3,	A0
		mvk	.S1	0,	A3
		shr	.S1	A0,	8,	A4
		mvk	.S1	255,	A5
		cmpgt	.L1	A4,	A5,	A6
		cmplt	.L1	A0,	A3,	A0
		mv		A6,	A2
	[!A2]	mv	.S1	A3,	A5
		or	.D1	A6,	A0,	A0
	[!A0]	mv	.S1	A4,	A5
		mv		A5,	A0
		stw		A0,	*-A15(40)
.BB1_38:

		mvk	.S1	100,	A0
		mvk	.S1	128,	A3
		ldw		*-A15(36),	A2
		nop	.S1	4
		mpy32	.M1	A2,	A0,	A0
		nop	.S1	3
		mvk	.S1	208,	A4
		sub	.L1	A3,	A0,	A0
		mpy32	.M1	A1,	A4,	A3
		nop	.S1	3
		sub	.L1	A0,	A3,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		add	.L1	A0,	A1,	A0
		mvk	.S1	-1,	A3
		cmpgt	.L1	A0,	A3,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_40
		nop	.S1	4

		mvk	.S1	0,	A0
		stw		A0,	*-A15(44)
		b	.S1	.BB1_41
		nop	.S1	4
.BB1_40:

		mvk	.S1	0,	A3
		shr	.S1	A0,	8,	A4
		mvk	.S1	255,	A5
		cmpgt	.L1	A4,	A5,	A6
		cmplt	.L1	A0,	A3,	A0
		mv		A6,	A1
	[!A1]	mv	.S1	A3,	A5
		or	.D1	A6,	A0,	A0
	[!A0]	mv	.S1	A4,	A5
		mv		A5,	A0
		stw		A0,	*-A15(44)
.BB1_41:

		mvk	.S1	516,	A0
		ldw		*-A15(36),	A1
		nop	.S1	4
		mpy32	.M1	A1,	A0,	A0
		nop	.S1	3
		ldw		*-A15(28),	A1
		nop	.S1	4
		add	.L1	A0,	A1,	A0
		addk	.S1	128,	A0
		mvk	.S1	-1,	A3
		cmpgt	.L1	A0,	A3,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_43
		nop	.S1	4

		mvk	.S1	0,	A0
		stw		A0,	*-A15(36)
		b	.S1	.BB1_44
		nop	.S1	4
.BB1_43:

		mvk	.S1	0,	A3
		shr	.S1	A0,	8,	A4
		mvk	.S1	255,	A5
		cmpgt	.L1	A4,	A5,	A6
		cmplt	.L1	A0,	A3,	A0
		mv		A6,	A1
	[!A1]	mv	.S1	A3,	A5
		or	.D1	A6,	A0,	A0
	[!A0]	mv	.S1	A4,	A5
		mv		A5,	A0
		stw		A0,	*-A15(36)
.BB1_44:

		ldw		*-A15(44),	A0
		nop	.S1	4
		ldw		*-A15(36),	A1
		nop	.S1	4
		cmpgt	.L1	A0,	A1,	A3
		cmplt	.L1	A0,	A1,	A4
		mv		A3,	A2
		mv		A0,	A3
	[!A2]	mv	.S1	A1,	A3
		mv		A4,	A2
	[!A2]	mv	.S1	A1,	A0
		ldw		*-A15(40),	A1
		nop	.S1	4
		mv		A1,	A4
		cmpgt	.L1	A4,	A3,	A4
		mv		A1,	A5
		cmplt	.L1	A5,	A0,	A5
		mv		A4,	A2
		mv		A1,	A4
	[!A2]	mv	.S1	A3,	A4
		mv		A5,	A2
		mv		A1,	A3
	[!A2]	mv	.S1	A0,	A3
		cmpeq	.L1	0,	A4,	A0
		mv		A4,	A1
		stw		A1,	*-A15(28)
	[!A0]	b	.S1	.BB1_46
		nop	.S1	4

		mvk	.S1	0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(84)
		stw		A0,	*-A15(64)
		b	.S1	.BB1_55
		nop	.S1	4
.BB1_46:

		sub	.L1	A4,	A3,	A0
		mv		A3,	A1
		mvkl	.S1	trans_table,	A3
		ldw		*-A15(28),	A2
		nop	.S1	4
		shl	.S1	A2,	2,	A4
		mvkh	.S1	trans_table,	A3
		shr	.S1	A4,	2,	A4
		ldw		*A3(A4),	A3
		nop	.S1	4
		mpy32	.M1	A3,	A0,	A3
		nop	.S1	3
		shru	.S1	A3,	12,	A3
		cmpeq	.L1	A2,	A1,	A4
		mv		A3,	A1
		mv		A4,	A2
	[!A2]	b	.S1	.BB1_49
		nop	.S1	4

		mvk	.S1	0,	A0
.BB1_48:

		mvk	.S1	0,	A3
		cmplt	.L1	A0,	A3,	A4
		mv		A4,	A2
	[!A2]	mv	.S1	A0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(64)
		b	.S1	.BB1_52
		nop	.S1	4
.BB1_49:

		mvk	.S1	0,	A3
		ldw		*-A15(44),	A2
		nop	.S1	4
		mv		A2,	A4
		ldw		*-A15(36),	A2
		nop	.S1	4
		mv		A2,	A5
		sub	.L1	A4,	A5,	A4
		ldw		*-A15(28),	A2
		nop	.S1	4
		mv		A2,	A5
		ldw		*-A15(40),	A2
		nop	.S1	4
		mv		A2,	A6
		cmpeq	.L1	A5,	A6,	A5
		mvkl	.S1	trans_table,	A6
		shl	.S1	A0,	2,	A0
		mv		A5,	A2
	[!A2]	mv	.S1	A3,	A4
		ldw		*-A15(36),	A2
		nop	.S1	4
		mv		A2,	A3
		ldw		*-A15(40),	A2
		nop	.S1	4
		mv		A2,	A5
		sub	.L1	A3,	A5,	A3
		ldw		*-A15(28),	A2
		nop	.S1	4
		mv		A2,	A5
		ldw		*-A15(44),	A2
		nop	.S1	4
		mv		A2,	A7
		cmpeq	.L1	A5,	A7,	A5
		mv		A5,	A2
	[!A2]	mv	.S1	A4,	A3
		ldw		*-A15(40),	A2
		nop	.S1	4
		mv		A2,	A4
		ldw		*-A15(44),	A2
		nop	.S1	4
		mv		A2,	A7
		sub	.L1	A4,	A7,	A4
		ldw		*-A15(28),	A2
		nop	.S1	4
		mv		A2,	A7
		ldw		*-A15(36),	A2
		nop	.S1	4
		mv		A2,	A8
		cmpeq	.L1	A7,	A8,	A7
		mvkh	.S1	trans_table,	A6
		shr	.S1	A0,	2,	A0
		mv		A7,	A2
	[!A2]	mv	.S1	A3,	A4
		ldw		*A6(A0),	A0
		nop	.S1	4
		mvkl	.S1	262144,	A3
		mpy32	.M1	A4,	A0,	A0
		nop	.S1	3
		mvk	.S1	15,	A4
		mpy32	.M1	A0,	A4,	A0
		nop	.S1	3
		mvkh	.S1	262144,	A3
		add	.L1	A0,	A3,	A0
		shr	.S1	A0,	19,	A0
		mv		A0,	A3
		addk	.S1	60,	A3
		mv		A5,	A2
	[!A2]	mv	.S1	A0,	A3
		mv		A3,	A0
		addk	.S1	120,	A0
		mv		A7,	A2
	[!A2]	mv	.S1	A3,	A0
		mvk	.S1	255,	A3
		cmpgt	.L1	A0,	A3,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_51
		nop	.S1	4

		b	.S1	.BB1_48
		nop	.S1	4
.BB1_51:

		mvk	.S1	255,	A0
		stw		A0,	*-A15(64)
.BB1_52:

		mvk	.S1	255,	A0
		cmpgtu	.L1	A1,	A0,	A3
		mvk	.S1	256,	A4
		mv		A3,	A2
	[!A2]	mv	.S1	A1,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		cmplt	.L1	A1,	A4,	A3
		stw		A0,	*-A15(84)
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_54
		nop	.S1	4

		mvk	.S1	255,	A0
		stw		A0,	*-A15(28)
		b	.S1	.BB1_55
		nop	.S1	4
.BB1_54:

		mvk	.S1	0,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		cmplt	.L1	A1,	A0,	A3
		mv		A3,	A2
	[!A2]	mv	.S1	A1,	A0
		stw		A0,	*-A15(28)
.BB1_55:

		mvk	.S1	255,	A0
		ldw		*-A15(92),	A1
		nop	.S1	4
		and	.L1	A1,	A0,	A3
		add	.L1	A1,	1,	A4
		ldw		*-A15(40),	A1
		nop	.S1	4
		ldw		*-A15(36),	A2
		nop	.S1	4
		mv		A2,	A6
		sub	.L1	A1,	A6,	A5
		stw		A5,	*-A15(88)
		ldw		*-A15(44),	A2
		nop	.S1	4
		sub	.L1	A1,	A2,	A5
		stw		A5,	*-A15(40)
		ldw		*-A15(36),	A1
		nop	.S1	4
		mv		A1,	A6
		sub	.L1	A2,	A6,	A10
		mvk	.S1	-23,	A5
		add	.L1	A15,	A5,	A6
		stw		A6,	*-A15(36)
		shr	.S1	A3,	0,	A3
		stw		A3,	*-A15(44)
		ldw		*-A15(88),	A5
		nop	.S1	4
		shr	.S1	A5,	31,	A11
		ldw		*-A15(40),	A5
		nop	.S1	4
		shr	.S1	A5,	31,	A12
		shr	.S1	A10,	31,	A13
		mvk	.S1	0,	A7
		stw		A7,	*-A15(92)
		sub	.D2	B15,	0,	B15
		and	.L1	A4,	A0,	A4
		mvk	.S1	3,	A0
		ldbu		*A6(A3),	A8
		nop	.S1	4
		ldw		*-A15(64),	A1
		nop	.S1	4
		mv		A1,	A9
		ldw		*-A15(32),	A2
		nop	.S1	4
		add	.L1	A9,	A2,	A9
		sub	.L1	A9,	A8,	A14
		mvk	.S1	300,	A8
		stw		A8,	*-A15(32)
		mv		A0,	B4
		callp	.S2	__remu
		ldw		*-A15(92),	A7
		nop	.S1	4
		add	.D2X	B15,	A7,	B15
		mv		A4,	A0
		stw		A0,	*-A15(92)
		ldw		*-A15(88),	A5
		nop	.S1	4
		add	.L1	A5,	A11,	A0
		ldw		*-A15(40),	A5
		nop	.S1	4
		add	.L1	A5,	A12,	A4
		add	.L1	A10,	A13,	A5
		xor	.D1	A0,	A11,	A0
		xor	.D1	A4,	A12,	A4
		xor	.D1	A5,	A13,	A5
		ldw		*-A15(32),	A8
		nop	.S1	4
		cmplt	.L1	A14,	A8,	A7
		ldw		*-A15(36),	A6
		nop	.S1	4
		ldw		*-A15(44),	A3
		nop	.S1	4
		ldw		*-A15(64),	A1
		nop	.S1	4
		stb		A1,	*A6(A3)
		mv		A14,	A2
		stw		A2,	*-A15(32)
		mv		A4,	A1
		mv		A5,	A2
		stw		A2,	*-A15(36)
		mv		A7,	A2
	[ A2]	b	.S1	.BB1_59
		nop	.S1	4

		mvk	.S1	255,	A3
		and	.L1	A0,	A3,	A3
		mvk	.S1	19,	A4
		cmpgtu	.L1	A3,	A4,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_59
		nop	.S1	4

		mvk	.S1	255,	A3
		and	.L1	A1,	A3,	A3
		mvk	.S1	19,	A4
		cmpgtu	.L1	A3,	A4,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_59
		nop	.S1	4

		mvk	.S1	255,	A3
		ldw		*-A15(36),	A2
		nop	.S1	4
		and	.L1	A2,	A3,	A3
		mvk	.S1	20,	A4
		cmpltu	.L1	A3,	A4,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_78
		nop	.S1	4
.BB1_59:

		mvk	.S1	299,	A3
		ldw		*-A15(32),	A2
		nop	.S1	4
		cmpgt	.L1	A2,	A3,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_63
		nop	.S1	4

		mvk	.S1	255,	A3
		and	.L1	A0,	A3,	A0
		mvk	.S1	19,	A3
		cmpgtu	.L1	A0,	A3,	A0
	[ A0]	b	.S1	.BB1_63
		nop	.S1	4

		mvk	.S1	255,	A0
		and	.L1	A1,	A0,	A0
		mvk	.S1	19,	A3
		cmpgtu	.L1	A0,	A3,	A0
	[ A0]	b	.S1	.BB1_63
		nop	.S1	4

		mvk	.S1	255,	A0
		ldw		*-A15(36),	A1
		nop	.S1	4
		and	.L1	A1,	A0,	A0
		mvk	.S1	20,	A3
		cmpltu	.L1	A0,	A3,	A0
	[ A0]	b	.S1	.BB1_78
		nop	.S1	4
.BB1_63:

		mvk	.S1	59,	A0
		ldw		*-A15(84),	A1
		nop	.S1	4
		cmpgt	.L1	A1,	A0,	A0
	[ A0]	b	.S1	.BB1_67
		nop	.S1	4

		ldw		*-A15(56),	A1
		nop	.S1	4
		add	.L1	A1,	1,	A0
		mvk	.S1	1,	A3
		cmpgt	.L1	A0,	A3,	A3
		mv		A0,	A1
		stw		A1,	*-A15(56)
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_66
		nop	.S1	4

		ldw		*-A15(72),	A0
		nop	.S1	4
		stw		A0,	*-A15(28)
		b	.S1	.BB1_79
		nop	.S1	4
.BB1_66:

		mvk	.S1	0,	A0
		stw		A0,	*-A15(28)
		b	.S1	.BB1_79
		nop	.S1	4
.BB1_67:

		mvk	.S1	59,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		cmpgt	.L1	A1,	A0,	A0
	[ A0]	b	.S1	.BB1_71
		nop	.S1	4

		ldw		*-A15(52),	A0
		nop	.S1	4
		add	.L1	A0,	1,	A0
		mvk	.S1	1,	A3
		cmpgt	.L1	A0,	A3,	A3
		stw		A0,	*-A15(52)
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_70
		nop	.S1	4

		ldw		*-A15(72),	A0
		nop	.S1	4
		stw		A0,	*-A15(28)
		b	.S1	.BB1_79
		nop	.S1	4
.BB1_70:

		mvk	.S1	0,	A0
		stw		A0,	*-A15(28)
		b	.S1	.BB1_79
		nop	.S1	4
.BB1_71:

		mvk	.S1	30,	A0
		ldw		*-A15(32),	A1
		nop	.S1	4
		cmpgtu	.L1	A1,	A0,	A0
	[ A0]	b	.S1	.BB1_73
		nop	.S1	4
.BB1_72:

		mvk	.S1	0,	A0
		mvk	.S1	1,	A3
		stw		A0,	*-A15(56)
		mv		A3,	A1
		stw		A1,	*-A15(28)
		stw		A0,	*-A15(52)
		b	.S1	.BB1_79
		nop	.S1	4
.BB1_73:

		mv		A1,	A0
		addk	.S1	-300,	A0
		mvk	.S1	45,	A3
		cmpgtu	.L1	A0,	A3,	A0
	[ A0]	b	.S1	.BB1_75
		nop	.S1	4

		mvk	.S1	0,	A0
		mvk	.S1	2,	A3
		stw		A0,	*-A15(56)
		mv		A3,	A1
		stw		A1,	*-A15(28)
		stw		A0,	*-A15(52)
		b	.S1	.BB1_79
		nop	.S1	4
.BB1_75:

		ldw		*-A15(32),	A0
		nop	.S1	4
		addk	.S1	-180,	A0
		mvk	.S1	90,	A3
		cmpgtu	.L1	A0,	A3,	A0
	[ A0]	b	.S1	.BB1_77
		nop	.S1	4

		mvk	.S1	0,	A0
		mvk	.S1	3,	A3
		stw		A0,	*-A15(56)
		mv		A3,	A1
		stw		A1,	*-A15(28)
		stw		A0,	*-A15(52)
		b	.S1	.BB1_79
		nop	.S1	4
.BB1_77:

		ldw		*-A15(32),	A0
		nop	.S1	4
		addk	.S1	-450,	A0
		mvk	.S1	106,	A3
		cmpltu	.L1	A0,	A3,	A0
	[ A0]	b	.S1	.BB1_72
		nop	.S1	4
.BB1_78:

		mvk	.S1	0,	A0
		mv		A0,	A1
		stw		A1,	*-A15(56)
		stw		A0,	*-A15(28)
		mv		A1,	A0
		stw		A0,	*-A15(52)
.BB1_79:

		mvk	.S1	255,	A0
		ldw		*-A15(72),	A1
		nop	.S1	4
		and	.L1	A1,	A0,	A3
		ldw		*-A15(28),	A1
		nop	.S1	4
		and	.L1	A1,	A0,	A0
		cmpeq	.L1	A3,	A0,	A0
	[ A0]	b	.S1	.BB1_86
		nop	.S1	4

		mvkl	.S1	span,	A0
		mvkh	.S1	span,	A0
		mvkl	.S1	spans,	A3
		ldw		*A0,	A0
		nop	.S1	4
		mvkh	.S1	spans,	A3
		ldw		*A3,	A3
		nop	.S1	4
		shl	.S1	A0,	5,	A4
		add	.L1	A3,	A4,	A4
		ldbu		*+A4(3),	A5
		nop	.S1	4
		shl	.S1	A5,	8,	A5
		ldbu		*+A4(2),	A4
		nop	.S1	4
		or	.D1	A5,	A4,	A4
		ldw		*-A15(96),	A1
		nop	.S1	4
		cmpeq	.L1	A1,	A4,	A4
		mv		A3,	A1
		mv		A4,	A2
	[ A2]	b	.S1	.BB1_82
		nop	.S1	4
.BB1_81:

		b	.S1	.BB1_85
		nop	.S1	4
.BB1_82:

		shl	.S1	A0,	5,	A3
		add	.L1	A1,	A3,	A3
		ldhu		*+A3(16),	A3
		nop	.S1	4
		cmpeq	.L1	0,	A3,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_81
		nop	.S1	4

		shl	.S1	A0,	5,	A3
		shr	.S1	A3,	1,	A3
		ldhu		*A1(A3),	A3
		nop	.S1	4
		ldw		*-A15(68),	A2
		nop	.S1	4
		sub	.L1	A2,	A3,	A3
		mvk	.S1	4,	A4
		cmplt	.L1	A3,	A4,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_81
		nop	.S1	4

		shl	.S1	A0,	5,	A0
		mvkl	.S1	span,	A3
		add	.L1	A1,	A0,	A0
		mvkl	.S1	spans,	A1
		mvkh	.S1	span,	A3
		ldw		*-A15(60),	A2
		nop	.S1	4
		sth		A2,	*+A0(4)
		mvkh	.S1	spans,	A1
		ldw		*A3,	A0
		nop	.S1	4
		ldw		*A1,	A4
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		ldw		*-A15(76),	A2
		nop	.S1	4
		mv		A2,	A5
		shru	.S1	A5,	8,	A5
		add	.L1	A4,	A0,	A0
		stb		A2,	*+A0(6)
		stb		A5,	*+A0(7)
		ldw		*A3,	A0
		nop	.S1	4
		ldw		*A1,	A4
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		add	.L1	A4,	A0,	A0
		ldw		*-A15(60),	A2
		nop	.S1	4
		mv		A2,	A4
		shru	.S1	A4,	8,	A4
		stb		A2,	*+A0(10)
		stb		A4,	*+A0(11)
		ldw		*A3,	A0
		nop	.S1	4
		ldw		*A1,	A4
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		add	.L1	A4,	A0,	A0
		ldw		*-A15(76),	A2
		nop	.S1	4
		stb		A2,	*+A0(14)
		stb		A5,	*+A0(15)
		ldw		*A3,	A0
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		ldw		*A1,	A4
		nop	.S1	4
		add	.L1	A4,	A0,	A5
		shr	.S1	A0,	0,	A0
		ldb		*+A5(1),	A6
		nop	.S1	4
		ldbu		*A4(A0),	A0
		nop	.S1	4
		shl	.S1	A6,	8,	A4
		or	.D1	A4,	A0,	A0
		sth		A0,	*+A5(8)
		ldw		*A3,	A0
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		ldw		*A1,	A4
		nop	.S1	4
		add	.L1	A4,	A0,	A0
		ldb		*+A0(3),	A4
		nop	.S1	4
		ldbu		*+A0(2),	A5
		nop	.S1	4
		shl	.S1	A4,	8,	A4
		or	.D1	A4,	A5,	A4
		sth		A4,	*+A0(12)
		ldw		*A3,	A0
		nop	.S1	4
		add	.L1	A0,	1,	A0
		stw		A0,	*A3
		ldw		*A1,	A1
		nop	.S1	4
.BB1_85:

		shl	.S1	A0,	5,	A0
		mvkl	.S1	span,	A3
		shr	.S1	A0,	0,	A4
		add	.L1	A1,	A0,	A0
		ldw		*-A15(60),	A2
		nop	.S1	4
		shru	.S1	A2,	8,	A5
		mvkl	.S1	spans,	A6
		mvkh	.S1	span,	A3
		stb		A2,	*A1(A4)
		stb		A5,	*+A0(1)
		mvkh	.S1	spans,	A6
		ldw		*A3,	A0
		nop	.S1	4
		ldw		*A6,	A4
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		add	.L1	A4,	A0,	A0
		ldw		*-A15(76),	A1
		nop	.S1	4
		shru	.S1	A1,	8,	A4
		stb		A1,	*+A0(2)
		stb		A4,	*+A0(3)
		ldw		*A3,	A0
		nop	.S1	4
		ldw		*A6,	A3
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		add	.L1	A3,	A0,	A0
		mvk	.S1	0,	A3
		ldw		*-A15(28),	A1
		nop	.S1	4
		stb		A1,	*+A0(16)
		stb		A3,	*+A0(17)
.BB1_86:

		ldw		*-A15(68),	A0
		nop	.S1	4
		add	.L1	A0,	1,	A0
		ldw		*-A15(80),	A1
		nop	.S1	4
		add	.L1	A1,	2,	A3
		ldw		*-A15(60),	A1
		nop	.S1	4
		add	.L1	A1,	1,	A4
		ldw		*-A15(100),	A1
		nop	.S1	4
		cmpeq	.L1	A1,	A0,	A5
		mv		A3,	A1
		stw		A1,	*-A15(80)
		stw		A0,	*-A15(68)
		mv		A4,	A1
		stw		A1,	*-A15(60)
		mv		A5,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		stw		A1,	*-A15(72)
	[!A0]	b	.S1	.BB1_32
		nop	.S1	4

		ldw		*-A15(100),	A0
		nop	.S1	4
.BB1_88:

		mvkl	.S1	span,	A3
		mvkh	.S1	span,	A3
		mvkl	.S1	spans,	A4
		ldw		*A3,	A3
		nop	.S1	4
		mvkh	.S1	spans,	A4
		ldw		*A4,	A4
		nop	.S1	4
		shl	.S1	A3,	5,	A5
		add	.L1	A4,	A5,	A5
		ldbu		*+A5(17),	A6
		nop	.S1	4
		shl	.S1	A6,	8,	A6
		ldbu		*+A5(16),	A5
		nop	.S1	4
		or	.D1	A6,	A5,	A5
		cmpeq	.L1	0,	A5,	A5
		mv		A3,	A1
		mv		A5,	A2
	[!A2]	b	.S1	.BB1_90
		nop	.S1	4

		b	.S1	.BB1_91
		nop	.S1	4
.BB1_90:

		mv		A4,	A2
		shl	.S1	A1,	5,	A1
		mvkl	.S1	span,	A3
		add	.L1	A2,	A1,	A1
		mvkl	.S1	spans,	A4
		mvkh	.S1	span,	A3
		sth		A0,	*+A1(4)
		mvkh	.S1	spans,	A4
		ldw		*A3,	A1
		nop	.S1	4
		ldw		*A4,	A5
		nop	.S1	4
		shl	.S1	A1,	5,	A1
		ldw		*-A15(76),	A2
		nop	.S1	4
		shru	.S1	A2,	8,	A6
		add	.L1	A5,	A1,	A1
		stb		A2,	*+A1(6)
		stb		A6,	*+A1(7)
		ldw		*A3,	A1
		nop	.S1	4
		ldw		*A4,	A5
		nop	.S1	4
		shl	.S1	A1,	5,	A1
		add	.L1	A5,	A1,	A1
		shru	.S1	A0,	8,	A5
		stb		A0,	*+A1(10)
		stb		A5,	*+A1(11)
		ldw		*A3,	A1
		nop	.S1	4
		ldw		*A4,	A5
		nop	.S1	4
		shl	.S1	A1,	5,	A1
		add	.L1	A5,	A1,	A1
		stb		A2,	*+A1(14)
		stb		A6,	*+A1(15)
		ldw		*A3,	A1
		nop	.S1	4
		shl	.S1	A1,	5,	A1
		ldw		*A4,	A5
		nop	.S1	4
		add	.L1	A5,	A1,	A7
		shr	.S1	A1,	0,	A1
		ldb		*+A7(1),	A8
		nop	.S1	4
		ldbu		*A5(A1),	A1
		nop	.S1	4
		shl	.S1	A8,	8,	A5
		or	.D1	A5,	A1,	A1
		sth		A1,	*+A7(8)
		ldw		*A3,	A1
		nop	.S1	4
		ldw		*A4,	A4
		nop	.S1	4
		shl	.S1	A1,	5,	A1
		add	.L1	A4,	A1,	A1
		stb		A2,	*+A1(12)
		stb		A6,	*+A1(13)
		ldw		*A3,	A1
		nop	.S1	4
		add	.L1	A1,	1,	A1
		stw		A1,	*A3
.BB1_91:

		mvk	.S1	0,	A3
		cmpgt	.L1	A1,	A3,	A3
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_93
		nop	.S1	4
.BB1_92:

		b	.S1	.BB1_109
		nop	.S1	4
.BB1_93:

		mvk	.S1	0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(56)
.BB1_94:

		ldw		*-A15(56),	A0
		nop	.S1	4
		stw		A0,	*-A15(52)
		mvkl	.S1	spans,	A3
		mvkl	.S1	ospan,	A4
		mvkl	.S1	ospans,	A5
		mvkh	.S1	spans,	A3
		mvkh	.S1	ospan,	A4
		mvkh	.S1	ospans,	A5
		ldw		*A3,	A3
		nop	.S1	4
		shl	.S1	A0,	5,	A6
		add	.L1	A3,	A6,	A6
		add	.L1	A0,	1,	A7
		ldw		*A4,	A0
		nop	.S1	4
		stw		A0,	*-A15(32)
		ldw		*A5,	A4
		nop	.S1	4
		mvk	.S1	0,	A5
		mv		A7,	A0
		stw		A0,	*-A15(56)
		mv		A3,	A0
		stw		A0,	*-A15(60)
		mv		A4,	A0
		mv		A6,	A1
		stw		A1,	*-A15(36)
		mv		A6,	A1
		stw		A1,	*-A15(40)
		mv		A6,	A1
		stw		A1,	*-A15(44)
		mv		A5,	A1
		stw		A1,	*-A15(28)
.BB1_95:

		ldw		*-A15(32),	A1
		nop	.S1	4
		ldw		*-A15(28),	A2
		nop	.S1	4
		cmplt	.L1	A1,	A2,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_108
		nop	.S1	4

		mv		A2,	A1
		shl	.S1	A1,	5,	A3
		add	.L1	A0,	A3,	A4
		ldw		*-A15(36),	A1
		nop	.S1	4
		ldbu		*+A1(1),	A5
		nop	.S1	4
		ldbu		*+A4(1),	A4
		nop	.S1	4
		shr	.S1	A3,	0,	A3
		shl	.S1	A5,	8,	A5
		ldbu		*A1,	A6
		nop	.S1	4
		shl	.S1	A4,	8,	A4
		ldbu		*A0(A3),	A3
		nop	.S1	4
		or	.D1	A5,	A6,	A5
		or	.D1	A4,	A3,	A3
		sub	.L1	A5,	A3,	A3
		shr	.S1	A3,	31,	A4
		add	.L1	A3,	A4,	A3
		xor	.D1	A3,	A4,	A3
		mvk	.S1	7,	A4
		cmpgt	.L1	A3,	A4,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_124
		nop	.S1	4

		ldw		*-A15(28),	A1
		nop	.S1	4
		shl	.S1	A1,	5,	A3
		add	.L1	A0,	A3,	A3
		mv		A3,	A1
		ldbu		*+A1(5),	A4
		nop	.S1	4
		ldw		*-A15(40),	A2
		nop	.S1	4
		ldbu		*+A2(5),	A5
		nop	.S1	4
		shl	.S1	A4,	8,	A4
		ldbu		*+A1(4),	A6
		nop	.S1	4
		shl	.S1	A5,	8,	A5
		ldbu		*+A2(4),	A7
		nop	.S1	4
		or	.D1	A5,	A7,	A5
		or	.D1	A4,	A6,	A4
		sub	.L1	A5,	A4,	A4
		shr	.S1	A4,	31,	A6
		add	.L1	A4,	A6,	A4
		xor	.D1	A4,	A6,	A4
		mvk	.S1	7,	A6
		cmpgt	.L1	A4,	A6,	A4
		mv		A4,	A1
	[ A1]	b	.S1	.BB1_124
		nop	.S1	4

		mv		A3,	A1
		ldbu		*+A1(17),	A3
		nop	.S1	4
		ldw		*-A15(44),	A2
		nop	.S1	4
		ldbu		*+A2(17),	A4
		nop	.S1	4
		shl	.S1	A3,	8,	A3
		ldbu		*+A1(16),	A6
		nop	.S1	4
		shl	.S1	A4,	8,	A4
		ldbu		*+A2(16),	A7
		nop	.S1	4
		or	.D1	A3,	A6,	A3
		or	.D1	A4,	A7,	A4
		cmpeq	.L1	A3,	A4,	A3
		mv		A3,	A1
	[!A1]	b	.S1	.BB1_124
		nop	.S1	4

		mv		A5,	A1
		ldw		*-A15(28),	A2
		nop	.S1	4
		shl	.S1	A2,	5,	A3
		add	.L1	A0,	A3,	A0
		ldbu		*+A0(11),	A3
		nop	.S1	4
		shl	.S1	A3,	8,	A3
		ldbu		*+A0(10),	A0
		nop	.S1	4
		or	.D1	A3,	A0,	A0
		cmpgtu	.L1	A0,	A1,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_101
		nop	.S1	4

		mv		A5,	A0
.BB1_101:

		ldw		*-A15(52),	A1
		nop	.S1	4
		shl	.S1	A1,	5,	A3
		mvkl	.S1	ospans,	A4
		mvkl	.S1	spans,	A5
		ldw		*-A15(60),	A1
		nop	.S1	4
		add	.L1	A1,	A3,	A6
		shru	.S1	A0,	8,	A7
		mvkh	.S1	ospans,	A4
		mvkh	.S1	spans,	A5
		stb		A0,	*+A6(10)
		stb		A7,	*+A6(11)
		ldw		*A5,	A0
		nop	.S1	4
		ldw		*A4,	A4
		nop	.S1	4
		ldw		*-A15(28),	A1
		nop	.S1	4
		shl	.S1	A1,	5,	A5
		add	.L1	A4,	A5,	A4
		add	.L1	A0,	A3,	A5
		ldbu		*+A4(9),	A6
		nop	.S1	4
		ldbu		*+A5(1),	A5
		nop	.S1	4
		shr	.S1	A3,	0,	A3
		shl	.S1	A6,	8,	A6
		ldbu		*+A4(8),	A4
		nop	.S1	4
		shl	.S1	A5,	8,	A5
		ldbu		*A0(A3),	A3
		nop	.S1	4
		or	.D1	A6,	A4,	A4
		or	.D1	A5,	A3,	A3
		cmpltu	.L1	A3,	A4,	A5
		mv		A5,	A1
	[ A1]	b	.S1	.BB1_103
		nop	.S1	4

		mv		A4,	A1
		b	.S1	.BB1_104
		nop	.S1	4
.BB1_103:

		mv		A3,	A1
.BB1_104:

		ldw		*-A15(52),	A2
		nop	.S1	4
		shl	.S1	A2,	5,	A3
		mvkl	.S1	ospans,	A4
		mvkl	.S1	spans,	A5
		add	.L1	A0,	A3,	A0
		shru	.S1	A1,	8,	A6
		mvkh	.S1	ospans,	A4
		mvkh	.S1	spans,	A5
		stb		A1,	*+A0(8)
		stb		A6,	*+A0(9)
		ldw		*A5,	A0
		nop	.S1	4
		ldw		*A4,	A4
		nop	.S1	4
		ldw		*-A15(28),	A1
		nop	.S1	4
		shl	.S1	A1,	5,	A5
		add	.L1	A4,	A5,	A4
		add	.L1	A0,	A3,	A3
		ldbu		*+A4(15),	A5
		nop	.S1	4
		ldbu		*+A3(7),	A6
		nop	.S1	4
		shl	.S1	A5,	8,	A5
		ldbu		*+A4(14),	A4
		nop	.S1	4
		shl	.S1	A6,	8,	A6
		ldbu		*+A3(6),	A3
		nop	.S1	4
		or	.D1	A5,	A4,	A4
		or	.D1	A6,	A3,	A3
		cmpgtu	.L1	A3,	A4,	A5
		mv		A5,	A1
	[ A1]	b	.S1	.BB1_106
		nop	.S1	4

		mv		A4,	A1
		b	.S1	.BB1_107
		nop	.S1	4
.BB1_106:

		mv		A3,	A1
.BB1_107:

		ldw		*-A15(52),	A2
		nop	.S1	4
		shl	.S1	A2,	5,	A3
		mvkl	.S1	ospans,	A4
		add	.L1	A0,	A3,	A0
		shru	.S1	A1,	8,	A5
		mvkl	.S1	spans,	A6
		mvkh	.S1	ospans,	A4
		stb		A1,	*+A0(14)
		stb		A5,	*+A0(15)
		mvkh	.S1	spans,	A6
		ldw		*A4,	A0
		nop	.S1	4
		ldw		*-A15(28),	A1
		nop	.S1	4
		shl	.S1	A1,	5,	A5
		add	.L1	A0,	A5,	A0
		ldw		*A6,	A6
		nop	.S1	4
		add	.L1	A6,	A3,	A3
		ldb		*+A0(13),	A6
		nop	.S1	4
		ldbu		*+A0(12),	A0
		nop	.S1	4
		stb		A0,	*+A3(12)
		stb		A6,	*+A3(13)
		ldw		*A4,	A0
		nop	.S1	4
		add	.L1	A0,	A5,	A0
		mvk	.S1	0,	A3
		stb		A3,	*+A0(16)
		stb		A3,	*+A0(17)
.BB1_108:

		mvkl	.S1	span,	A3
		mvkh	.S1	span,	A3
		ldw		*A3,	A3
		nop	.S1	4
		ldw		*-A15(56),	A0
		nop	.S1	4
		cmplt	.L1	A0,	A3,	A3
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_94
		nop	.S1	4
		b	.S1	.BB1_92
		nop	.S1	4
.BB1_109:

		mvkl	.S1	ospan,	A3
		mvkh	.S1	ospan,	A3
		ldw		*A3,	A0
		nop	.S1	4
		stw		A0,	*-A15(28)
.BB1_110:

		mvk	.S1	0,	A3
		ldw		*-A15(28),	A0
		nop	.S1	4
		cmpgt	.L1	A0,	A3,	A3
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_112
		nop	.S1	4
.BB1_111:

		b	.S1	.BB1_120
		nop	.S1	4
.BB1_112:

		mvk	.S1	10,	A3
		mvk	.S1	0,	A4
		mv		A3,	A0
		stw		A0,	*-A15(28)
		mv		A4,	A0
		stw		A0,	*-A15(32)
.BB1_113:

		mvkl	.S1	ospans,	A3
		mvkh	.S1	ospans,	A3
		ldw		*A3,	A3
		nop	.S1	4
		ldw		*-A15(28),	A0
		nop	.S1	4
		add	.L1	A3,	A0,	A4
		ldbu		*+A4(7),	A5
		nop	.S1	4
		shl	.S1	A5,	8,	A5
		ldbu		*+A4(6),	A4
		nop	.S1	4
		or	.D1	A5,	A4,	A4
		ldw		*-A15(32),	A0
		nop	.S1	4
		add	.L1	A0,	1,	A5
		cmpeq	.L1	0,	A4,	A6
		mv		A5,	A0
		stw		A0,	*-A15(32)
		mv		A6,	A0
	[ A0]	b	.S1	.BB1_119
		nop	.S1	4

		mvkl	.S1	num_blobs,	A5
		mvkh	.S1	num_blobs,	A5
		ldw		*A5,	A5
		nop	.S1	4
		mvk	.S1	1023,	A6
		cmpgt	.L1	A5,	A6,	A6
		mv		A6,	A0
	[ A0]	b	.S1	.BB1_119
		nop	.S1	4

		mv		A3,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		add	.L1	A0,	A1,	A3
		ldb		*-A3(1),	A6
		nop	.S1	4
		ldb		*+A3(3),	A7
		nop	.S1	4
		ldb		*+A3(1),	A8
		nop	.S1	4
		shr	.S1	A1,	0,	A9
		ldb		*+A3(5),	A16
		nop	.S1	4
		shl	.S1	A6,	8,	A6
		ldbu		*-A3(2),	A17
		nop	.S1	4
		shl	.S1	A7,	8,	A7
		ldbu		*+A3(2),	A18
		nop	.S1	4
		shl	.S1	A8,	8,	A8
		ldbu		*A0(A9),	A9
		nop	.S1	4
		shl	.S1	A16,	8,	A16
		ldbu		*+A3(4),	A3
		nop	.S1	4
		or	.D1	A6,	A17,	A6
		or	.D1	A7,	A18,	A7
		or	.D1	A8,	A9,	A8
		or	.D1	A16,	A3,	A3
		mv		A6,	A0
		mv		A7,	A1
		stw		A1,	*-A15(36)
		mv		A8,	A2
		mv		A3,	A1
		stw		A1,	*-A15(40)
		mvkl	.S1	65535,	A3
		mvkh	.S1	65535,	A3
		and	.L1	A2,	A3,	A6
		and	.L1	A0,	A3,	A7
		mv		A1,	A8
		and	.L1	A8,	A3,	A8
		ldw		*-A15(36),	A1
		nop	.S1	4
		mv		A1,	A9
		and	.L1	A9,	A3,	A3
		sub	.L1	A6,	A7,	A6
		sub	.L1	A8,	A3,	A3
		mpy32	.M1	A3,	A6,	A7
		nop	.S1	3
		mvk	.S1	5,	A8
		cmplt	.L1	A7,	A8,	A7
		mv		A7,	A1
	[ A1]	b	.S1	.BB1_119
		nop	.S1	4

		mv		A6,	A1
		mvk	.S1	3,	A6
		cmplt	.L1	A1,	A6,	A6
		mv		A6,	A1
	[ A1]	b	.S1	.BB1_119
		nop	.S1	4

		mv		A3,	A1
		mvk	.S1	3,	A3
		cmplt	.L1	A1,	A3,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_119
		nop	.S1	4

		mv		A4,	A1
		stw		A1,	*-A15(44)
		mv		A5,	A1
		mvkl	.S1	blobs,	A3
		mvkh	.S1	blobs,	A3
		shl	.S1	A1,	5,	A4
		ldw		*A3,	A5
		nop	.S1	4
		mvkl	.S1	num_blobs,	A6
		shr	.S1	A4,	0,	A7
		add	.L1	A5,	A4,	A4
		shru	.S1	A0,	8,	A8
		mvkh	.S1	num_blobs,	A6
		stb		A0,	*A5(A7)
		stb		A8,	*+A4(1)
		ldw		*A6,	A4
		nop	.S1	4
		ldw		*A3,	A5
		nop	.S1	4
		shl	.S1	A4,	5,	A4
		add	.L1	A5,	A4,	A4
		shru	.S1	A2,	8,	A5
		stb		A2,	*+A4(4)
		stb		A5,	*+A4(5)
		ldw		*A6,	A4
		nop	.S1	4
		ldw		*A3,	A5
		nop	.S1	4
		shl	.S1	A4,	5,	A4
		add	.L1	A5,	A4,	A4
		ldw		*-A15(36),	A0
		nop	.S1	4
		shru	.S1	A0,	8,	A5
		stb		A0,	*+A4(2)
		stb		A5,	*+A4(3)
		ldw		*A6,	A4
		nop	.S1	4
		ldw		*A3,	A5
		nop	.S1	4
		shl	.S1	A4,	5,	A4
		add	.L1	A5,	A4,	A4
		ldw		*-A15(40),	A0
		nop	.S1	4
		shru	.S1	A0,	8,	A5
		stb		A0,	*+A4(6)
		stb		A5,	*+A4(7)
		ldw		*A6,	A4
		nop	.S1	4
		ldw		*A3,	A3
		nop	.S1	4
		shl	.S1	A4,	5,	A4
		add	.L1	A3,	A4,	A3
		ldw		*-A15(44),	A1
		nop	.S1	4
		mv		A1,	A4
		shru	.S1	A4,	8,	A4
		stb		A1,	*+A3(16)
		stb		A4,	*+A3(17)
		ldw		*A6,	A3
		nop	.S1	4
		add	.L1	A3,	1,	A3
		stw		A3,	*A6
.BB1_119:

		mvkl	.S1	ospan,	A3
		mvkh	.S1	ospan,	A3
		ldw		*A3,	A3
		nop	.S1	4
		ldw		*-A15(28),	A0
		nop	.S1	4
		addk	.S1	32,	A0
		ldw		*-A15(32),	A1
		nop	.S1	4
		cmplt	.L1	A1,	A3,	A3
		stw		A0,	*-A15(28)
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_113
		nop	.S1	4
		b	.S1	.BB1_111
		nop	.S1	4
.BB1_120:

		mvk	.S1	-33,	A3
		ldw		*A15(A3),	A0
		nop	.S1	4
		ldw		*-A15(120),	A1
		nop	.S1	4
		add	.L1	A0,	A1,	A3
		mvk	.S1	320,	A4
		cmpeq	.L1	A3,	A4,	A3
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_122
		nop	.S1	4

		ldw		*-A15(96),	A0
		nop	.S1	4
		add	.L1	A0,	1,	A3
		mv		A3,	A0
		stw		A0,	*-A15(96)
		mvkl	.S1	ospans,	A3
		mvkl	.S1	spans,	A4
		mvkl	.S1	span,	A5
		mvkh	.S1	ospans,	A3
		mvkh	.S1	spans,	A4
		mvkh	.S1	span,	A5
		ldw		*-A15(108),	A0
		nop	.S1	4
		add	.L1	A0,	1,	A6
		ldw		*A3,	A0
		nop	.S1	4
		stw		A0,	*-A15(32)
		ldw		*A4,	A0
		nop	.S1	4
		stw		A0,	*-A15(36)
		ldw		*A5,	A0
		nop	.S1	4
		stw		A0,	*-A15(28)
		mv		A1,	A0
		add	.L1	A0,	-1,	A3
		ldw		*-A15(116),	A0
		nop	.S1	4
		addk	.S1	-640,	A0
		ldw		*-A15(76),	A1
		nop	.S1	4
		add	.L1	A1,	1,	A4
		mv		A6,	A1
		stw		A1,	*-A15(108)
		mv		A3,	A1
		stw		A1,	*-A15(120)
		stw		A0,	*-A15(116)
		mv		A4,	A1
		stw		A1,	*-A15(76)
		b	.S1	.BB1_2
		nop	.S1	4
.BB1_122:

		ldw		*-A15(ST_SAVED_A13),	A13
		ldw		*-A15(ST_SAVED_A12),	A12
		ldw		*-A15(ST_SAVED_A11),	A11
		ldw		*-A15(ST_SAVED_A10),	A10
		ldw		*-A15(ST_RETADDR),	B3
		mv		A15,	B15
	||	ldw		*A15,	A15
		nop		4

		bnop	.S2	B3,	5
.BB1_123:

		mvk	.S1	255,	A0
		stw		A0,	*-A15(28)
		b	.S1	.BB1_27
		nop	.S1	4
.BB1_124:

		ldw		*-A15(28),	A1
		nop	.S1	4
		add	.L1	A1,	1,	A3
		mv		A3,	A1
		stw		A1,	*-A15(28)
		b	.S1	.BB1_95
		nop	.S1	4
	.type	blobs,@object
	.lcomm	blobs,4
	.type	num_blobs,@object
	.lcomm	num_blobs,4
	.type	spans_a,@object
	.lcomm	spans_a,1056
	.type	spans,@object
	.lcomm	spans,4
	.type	spans_b,@object
	.lcomm	spans_b,1056
	.type	ospans,@object
	.lcomm	ospans,4
	.type	span,@object
	.lcomm	span,4
	.type	ospan,@object
	.lcomm	ospan,4
	.type	dma_buffer,@object
	.lcomm	dma_buffer,4
	.type	working_buffer,@object
	.lcomm	working_buffer,4

