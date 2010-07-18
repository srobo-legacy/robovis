	.file	"visfunc.cpp"


	.text
	.globl	vis_find_blobs_through_scanlines
	.align	5
	.type	vis_find_blobs_through_scanlines,@function
vis_find_blobs_through_scanlines:
mvk		136,	A0
	||	mv		B15,	A1
		stw		A15,	*B15
	||	stw		B3,	*-A1(4)
	||	mv		B15,	A15
	||	sub		B15,	A0	,B15

		stw		A10,	*-A15(8)
		stw		A11,	*-A15(12)
		stw		A12,	*-A15(16)
		stw		A13,	*-A15(20)
		mv		B6,	A10
		mv		A6,	A11
		mv		B4,	A3
		stw		A3,	*-A15(28)
		mv		A4,	A0
		stw		A0,	*-A15(88)
		mvkl	.S1	_ZL10dma_buffer,	A3
		mvkl	.S1	284180480,	A5
		mvkl	.S1	_ZL14working_buffer,	A6
		mvkl	.S1	284196864,	A7
		mvkh	.S1	_ZL10dma_buffer,	A3
		mvkh	.S1	284180480,	A5
		mvkh	.S1	_ZL14working_buffer,	A6
		mvkh	.S1	284196864,	A7
		stw		A5,	*A3
		stw		A7,	*A6
		sub	.D2	B15,	0,	B15
		mvk	.S1	15360,	A6
		mvk	.S1	0,	A12
		mvkl	.S1	_ZL5blobs,	A13
		mv		A5,	B4
		callp	.S2	setup_simple_dma
		add	.D2X	B15,	A12,	B15
		mvkh	.S1	_ZL5blobs,	A13
		stw		A10,	*A13
		mvkl	.S1	32768,	A6
		sub	.D2	B15,	0,	B15
		mvkh	.S1	32768,	A6
		mvkl	.S1	_ZL9num_blobs,	A13
		mv		A10,	A4
		mv		A12,	B4
		callp	.S2	memset
		add	.D2X	B15,	A12,	B15
		mvkl	.S1	_ZL5spans,	A3
		mvkh	.S1	_ZL9num_blobs,	A13
		mvkl	.S1	_ZL7spans_a,	A4
		mvkl	.S1	_ZL6ospans,	A5
		mvkl	.S1	_ZL7spans_b,	A10
		mvkh	.S1	_ZL5spans,	A3
		stw		A12,	*A13
		mvkh	.S1	_ZL7spans_a,	A4
		mvkh	.S1	_ZL6ospans,	A5
		stw		A4,	*A3
		mvkh	.S1	_ZL7spans_b,	A10
		stw		A10,	*A5
		sub	.D2	B15,	0,	B15
		mvk	.S1	1056,	A13
		mv		A12,	B4
		mv		A13,	A6
		callp	.S2	memset
		add	.D2X	B15,	A12,	B15
		mvkl	.S1	_ZL4span,	A14
		sub	.D2	B15,	0,	B15
		mv		A10,	A4
		mv		A12,	B4
		mv		A13,	A6
		callp	.S2	memset
		add	.D2X	B15,	A12,	B15
		mvkh	.S1	_ZL4span,	A14
		cmpeq	.L1	-1,	A11,	A3
		stw		A12,	*A14
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_108
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
		mvkl	.S1	_ZL7spans_a,	A5
		mvkl	.S1	_ZL7spans_b,	A6
		mvk	.S1	15360,	A7
		mvk	.S1	0,	A8
		ldw		*-A15(88),	A1
		nop	.S1	4
		add	.L1	A1,	A7,	A7
		shl	.S1	A0,	1,	A9
		add	.L1	A4,	-1,	A4
		mvkh	.S1	204800,	A3
		mvk	.S1	320,	A16
		mvkh	.S1	_ZL7spans_a,	A5
		mvkh	.S1	_ZL7spans_b,	A6
		mv		A7,	A0
		stw		A0,	*-A15(112)
		mv		A9,	A0
		stw		A0,	*-A15(124)
		mv		A4,	A0
		mvk	.S1	-33,	A4
		stw		A0,	*A15(A4)
		mv		A8,	A0
		stw		A0,	*-A15(72)
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
		mvkl	.S1	_ZL6ospans,	A4
		mvkl	.S1	_ZL5spans,	A5
		mvkh	.S1	_ZL6ospans,	A4
		stb		A10,	*-A15(23)
		stb		A10,	*+A3(1)
		stb		A10,	*+A3(2)
		mvkl	.S1	_ZL5ospan,	A3
		mvkh	.S1	_ZL5spans,	A5
		ldw		*-A15(36),	A1
		nop	.S1	4
		stw		A1,	*A4
		mvkl	.S1	_ZL4span,	A4
		mvkh	.S1	_ZL5ospan,	A3
		ldw		*-A15(32),	A0
		nop	.S1	4
		stw		A0,	*A5
		mvkh	.S1	_ZL4span,	A4
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

		b	.S1	.BB1_97
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

		mvk	.S1	0,	A10
		sub	.D2	B15,	0,	B15
		mvkl	.S1	_ZL10dma_buffer,	A11
		mvkl	.S1	_ZL14working_buffer,	A12
		callp	.S2	wait_for_dma_completion
		add	.D2X	B15,	A10,	B15
		mvkh	.S1	_ZL10dma_buffer,	A11
		mvkh	.S1	_ZL14working_buffer,	A12
		ldw		*A11,	A0
		nop	.S1	4
		stw		A0,	*-A15(88)
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
		mv		A1,	A11
	[!A0]	mv	.S1	A6,	A11
		mvkh	.S1	65535,	A5
		sub	.D2	B15,	0,	B15
		and	.L1	A11,	A5,	A6
		ldw		*-A15(112),	A0
		nop	.S1	4
		mv		A0,	A4
		mv		A3,	B4
		callp	.S2	setup_simple_dma
		add	.D2X	B15,	A10,	B15
		ldw		*-A15(112),	A0
		nop	.S1	4
		mv		A0,	A3
		add	.L1	A3,	A11,	A3
		mv		A3,	A0
		stw		A0,	*-A15(112)
		mv		A10,	A0
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
		stw		A0,	*-A15(60)
		mv		A3,	A0
		stw		A0,	*-A15(44)
		mv		A3,	A1
		stw		A1,	*-A15(56)
		mv		A0,	A1
		stw		A1,	*-A15(48)
		stw		A0,	*-A15(32)
.BB1_8:

		ldw		*-A15(44),	A0
		nop	.S1	4
		and	.L1	-4,	A0,	A3
		ldw		*-A15(60),	A0
		nop	.S1	4
		add	.L1	A3,	A0,	A3
		ldw		*-A15(48),	A0
		nop	.S1	4
		and	.L1	1,	A0,	A4
		add	.L1	A3,	2,	A5
		cmpeq	.L1	0,	A4,	A4
		mv		A4,	A0
		mv		A3,	A4
	[!A0]	mv	.S1	A5,	A4
		ldw		*-A15(88),	A0
		nop	.S1	4
		add	.L1	A3,	A0,	A5
		shr	.S1	A4,	0,	A4
		ldbu		*+A5(3),	A5
		nop	.S1	4
		ldbu		*A0(A4),	A4
		nop	.S1	4
		mvk	.S1	298,	A6
		addk	.S1	-128,	A5
		mvk	.S1	409,	A7
		mpy32	.M1	A4,	A6,	A4
		nop	.S1	3
		mvk	.S1	-4768,	A6
		or	.D1	1,	A3,	A3
		add	.L1	A4,	A6,	A4
		mpy32	.M1	A5,	A7,	A6
		nop	.S1	3
		shr	.S1	A3,	0,	A3
		add	.L1	A6,	A4,	A6
		ldbu		*A0(A3),	A3
		nop	.S1	4
		addk	.S1	128,	A6
		mvk	.S1	-1,	A7
		addk	.S1	-128,	A3
		cmpgt	.L1	A6,	A7,	A7
		mv		A3,	A0
		stw		A0,	*-A15(36)
		mv		A5,	A0
		mv		A4,	A1
		stw		A1,	*-A15(52)
		mv		A7,	A1
	[ A1]	b	.S1	.BB1_10
		nop	.S1	4

		mvk	.S1	0,	A6
		mv		A6,	A1
		stw		A1,	*-A15(40)
		b	.S1	.BB1_11
		nop	.S1	4
.BB1_10:

		mv		A6,	A1
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
.BB1_11:

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
		ldw		*-A15(52),	A0
		nop	.S1	4
		add	.L1	A3,	A0,	A3
		mvk	.S1	-1,	A4
		cmpgt	.L1	A3,	A4,	A4
		mv		A4,	A0
	[ A0]	b	.S1	.BB1_13
		nop	.S1	4

		mvk	.S1	0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(28)
		b	.S1	.BB1_14
		nop	.S1	4
.BB1_13:

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
.BB1_14:

		mvk	.S1	516,	A3
		ldw		*-A15(36),	A0
		nop	.S1	4
		mpy32	.M1	A0,	A3,	A3
		nop	.S1	3
		ldw		*-A15(52),	A0
		nop	.S1	4
		add	.L1	A3,	A0,	A3
		addk	.S1	128,	A3
		mvk	.S1	-1,	A4
		cmpgt	.L1	A3,	A4,	A4
		mv		A4,	A0
	[ A0]	b	.S1	.BB1_16
		nop	.S1	4

		mvk	.S1	0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(36)
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
		stw		A0,	*-A15(36)
.BB1_17:

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
	[!A0]	b	.S1	.BB1_19
		nop	.S1	4

		mvk	.S1	0,	A4
		mv		A4,	A1
		stw		A1,	*-A15(28)
		b	.S1	.BB1_25
		nop	.S1	4
.BB1_19:

		mv		A4,	A0
		cmpeq	.L1	A0,	A1,	A3
		mv		A3,	A2
	[!A2]	b	.S1	.BB1_21
		nop	.S1	4

		mvk	.S1	0,	A4
		mv		A4,	A0
		b	.S1	.BB1_24
		nop	.S1	4
.BB1_21:

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
		mvkl	.S1	_ZL11trans_table,	A6
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
		mvkh	.S1	_ZL11trans_table,	A6
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
	[ A0]	b	.S1	.BB1_23
		nop	.S1	4

		mv		A3,	A0
		b	.S1	.BB1_24
		nop	.S1	4
.BB1_23:

		mvk	.S1	255,	A0
		stw		A0,	*-A15(28)
		b	.S1	.BB1_25
		nop	.S1	4
.BB1_24:

		mvk	.S1	0,	A3
		cmplt	.L1	A0,	A3,	A4
		mv		A4,	A1
	[!A1]	mv	.S1	A0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(28)
.BB1_25:

		mvk	.S1	255,	A3
		ldw		*-A15(56),	A0
		nop	.S1	4
		add	.L1	A0,	1,	A4
		and	.L1	A0,	A3,	A10
		mvk	.S1	0,	A11
		sub	.D2	B15,	0,	B15
		and	.L1	A4,	A3,	A4
		mvk	.S1	3,	A3
		ldw		*-A15(48),	A0
		nop	.S1	4
		add	.L1	A0,	1,	A12
		mv		A3,	B4
		callp	.S2	__remu
		add	.D2X	B15,	A11,	B15
		mv		A4,	A0
		stw		A0,	*-A15(56)
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
		stw		A0,	*-A15(48)
		mv		A5,	A0
		stw		A0,	*-A15(44)
		mv		A7,	A0
	[!A0]	b	.S1	.BB1_8
		nop	.S1	4

		mvk	.S1	3,	A3
		ldw		*-A15(100),	A0
		nop	.S1	4
		cmpgt	.L1	A0,	A3,	A3
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_29
		nop	.S1	4

		mvk	.S1	3,	A3
		mv		A3,	A0
		b	.S1	.BB1_82
		nop	.S1	4
.BB1_28:

		ldw		*-A15(100),	A0
		nop	.S1	4
		b	.S1	.BB1_82
		nop	.S1	4
.BB1_29:

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
		stw		A1,	*-A15(56)
		stw		A0,	*-A15(64)
		mv		A4,	A0
		stw		A0,	*-A15(76)
		mv		A3,	A0
		stw		A0,	*-A15(68)
		mv		A3,	A1
		stw		A1,	*-A15(48)
		stw		A0,	*-A15(92)
		mv		A1,	A0
		stw		A0,	*-A15(52)
.BB1_30:

		ldw		*-A15(76),	A0
		nop	.S1	4
		and	.L1	-4,	A0,	A0
		ldw		*-A15(104),	A1
		nop	.S1	4
		add	.L1	A0,	A1,	A0
		ldw		*-A15(64),	A1
		nop	.S1	4
		and	.L1	1,	A1,	A3
		add	.L1	A0,	2,	A4
		cmpeq	.L1	0,	A3,	A3
		mv		A3,	A1
		mv		A0,	A3
	[!A1]	mv	.S1	A4,	A3
		ldw		*-A15(88),	A1
		nop	.S1	4
		add	.L1	A0,	A1,	A4
		shr	.S1	A3,	0,	A3
		ldbu		*+A4(3),	A4
		nop	.S1	4
		ldbu		*A1(A3),	A3
		nop	.S1	4
		mvk	.S1	298,	A5
		addk	.S1	-128,	A4
		mvk	.S1	409,	A6
		mpy32	.M1	A3,	A5,	A3
		nop	.S1	3
		mvk	.S1	-4768,	A5
		or	.D1	1,	A0,	A0
		add	.L1	A3,	A5,	A3
		mpy32	.M1	A4,	A6,	A5
		nop	.S1	3
		shr	.S1	A0,	0,	A0
		add	.L1	A5,	A3,	A5
		ldbu		*A1(A0),	A0
		nop	.S1	4
		addk	.S1	128,	A5
		mvk	.S1	-1,	A6
		addk	.S1	-128,	A0
		cmpgt	.L1	A5,	A6,	A6
		stw		A0,	*-A15(28)
		mv		A4,	A0
		mv		A3,	A1
		stw		A1,	*-A15(36)
		mv		A6,	A1
	[ A1]	b	.S1	.BB1_32
		nop	.S1	4

		mvk	.S1	0,	A5
		mv		A5,	A1
		stw		A1,	*-A15(40)
		b	.S1	.BB1_33
		nop	.S1	4
.BB1_32:

		mv		A5,	A1
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
.BB1_33:

		mvk	.S1	100,	A3
		mvk	.S1	128,	A4
		ldw		*-A15(28),	A1
		nop	.S1	4
		mpy32	.M1	A1,	A3,	A3
		nop	.S1	3
		mvk	.S1	208,	A5
		sub	.L1	A4,	A3,	A3
		mpy32	.M1	A0,	A5,	A0
		nop	.S1	3
		sub	.L1	A3,	A0,	A0
		ldw		*-A15(36),	A1
		nop	.S1	4
		add	.L1	A0,	A1,	A0
		mvk	.S1	-1,	A3
		cmpgt	.L1	A0,	A3,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_35
		nop	.S1	4

		mvk	.S1	0,	A0
		stw		A0,	*-A15(44)
		b	.S1	.BB1_36
		nop	.S1	4
.BB1_35:

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
.BB1_36:

		mvk	.S1	516,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		mpy32	.M1	A1,	A0,	A0
		nop	.S1	3
		ldw		*-A15(36),	A1
		nop	.S1	4
		add	.L1	A0,	A1,	A0
		addk	.S1	128,	A0
		mvk	.S1	-1,	A3
		cmpgt	.L1	A0,	A3,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_38
		nop	.S1	4

		mvk	.S1	0,	A0
		stw		A0,	*-A15(36)
		b	.S1	.BB1_39
		nop	.S1	4
.BB1_38:

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
.BB1_39:

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
	[!A0]	b	.S1	.BB1_41
		nop	.S1	4

		mvk	.S1	0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(80)
		stw		A0,	*-A15(60)
		b	.S1	.BB1_50
		nop	.S1	4
.BB1_41:

		sub	.L1	A4,	A3,	A0
		mv		A3,	A1
		mvkl	.S1	_ZL11trans_table,	A3
		ldw		*-A15(28),	A2
		nop	.S1	4
		shl	.S1	A2,	2,	A4
		mvkh	.S1	_ZL11trans_table,	A3
		shr	.S1	A4,	2,	A4
		ldw		*A3(A4),	A3
		nop	.S1	4
		mpy32	.M1	A3,	A0,	A3
		nop	.S1	3
		shru	.S1	A3,	12,	A3
		cmpeq	.L1	A2,	A1,	A4
		mv		A3,	A1
		mv		A4,	A2
	[!A2]	b	.S1	.BB1_43
		nop	.S1	4

		mvk	.S1	0,	A0
		b	.S1	.BB1_46
		nop	.S1	4
.BB1_43:

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
		mvkl	.S1	_ZL11trans_table,	A6
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
		mvkh	.S1	_ZL11trans_table,	A6
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
	[ A2]	b	.S1	.BB1_45
		nop	.S1	4

		b	.S1	.BB1_46
		nop	.S1	4
.BB1_45:

		mvk	.S1	255,	A0
		stw		A0,	*-A15(60)
		b	.S1	.BB1_47
		nop	.S1	4
.BB1_46:

		mvk	.S1	0,	A3
		cmplt	.L1	A0,	A3,	A4
		mv		A4,	A2
	[!A2]	mv	.S1	A0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(60)
.BB1_47:

		mvk	.S1	255,	A0
		cmpgtu	.L1	A1,	A0,	A3
		mvk	.S1	256,	A4
		mv		A3,	A2
	[!A2]	mv	.S1	A1,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		cmplt	.L1	A1,	A4,	A3
		stw		A0,	*-A15(80)
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_49
		nop	.S1	4

		mvk	.S1	255,	A0
		stw		A0,	*-A15(28)
		b	.S1	.BB1_50
		nop	.S1	4
.BB1_49:

		mvk	.S1	0,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		cmplt	.L1	A1,	A0,	A3
		mv		A3,	A2
	[!A2]	mv	.S1	A1,	A0
		stw		A0,	*-A15(28)
.BB1_50:

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
		stw		A5,	*-A15(84)
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
		ldw		*-A15(84),	A5
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
		ldw		*-A15(60),	A1
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
		ldw		*-A15(84),	A5
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
		ldw		*-A15(60),	A1
		nop	.S1	4
		stb		A1,	*A6(A3)
		mv		A14,	A2
		stw		A2,	*-A15(32)
		mv		A4,	A1
		mv		A5,	A2
		stw		A2,	*-A15(36)
		mv		A7,	A2
	[ A2]	b	.S1	.BB1_54
		nop	.S1	4

		mvk	.S1	255,	A3
		and	.L1	A0,	A3,	A3
		mvk	.S1	19,	A4
		cmpgtu	.L1	A3,	A4,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_54
		nop	.S1	4

		mvk	.S1	255,	A3
		and	.L1	A1,	A3,	A3
		mvk	.S1	19,	A4
		cmpgtu	.L1	A3,	A4,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_54
		nop	.S1	4

		mvk	.S1	255,	A3
		ldw		*-A15(36),	A2
		nop	.S1	4
		and	.L1	A2,	A3,	A3
		mvk	.S1	20,	A4
		cmpltu	.L1	A3,	A4,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_73
		nop	.S1	4
.BB1_54:

		mvk	.S1	299,	A3
		ldw		*-A15(32),	A2
		nop	.S1	4
		cmpgt	.L1	A2,	A3,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_58
		nop	.S1	4

		mvk	.S1	255,	A3
		and	.L1	A0,	A3,	A0
		mvk	.S1	19,	A3
		cmpgtu	.L1	A0,	A3,	A0
	[ A0]	b	.S1	.BB1_58
		nop	.S1	4

		mvk	.S1	255,	A0
		and	.L1	A1,	A0,	A0
		mvk	.S1	19,	A3
		cmpgtu	.L1	A0,	A3,	A0
	[ A0]	b	.S1	.BB1_58
		nop	.S1	4

		mvk	.S1	255,	A0
		ldw		*-A15(36),	A1
		nop	.S1	4
		and	.L1	A1,	A0,	A0
		mvk	.S1	20,	A3
		cmpltu	.L1	A0,	A3,	A0
	[ A0]	b	.S1	.BB1_73
		nop	.S1	4
.BB1_58:

		mvk	.S1	59,	A0
		ldw		*-A15(80),	A1
		nop	.S1	4
		cmpgt	.L1	A1,	A0,	A0
	[ A0]	b	.S1	.BB1_62
		nop	.S1	4

		ldw		*-A15(52),	A1
		nop	.S1	4
		add	.L1	A1,	1,	A0
		mvk	.S1	1,	A3
		cmpgt	.L1	A0,	A3,	A3
		mv		A0,	A1
		stw		A1,	*-A15(52)
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_61
		nop	.S1	4

		ldw		*-A15(68),	A0
		nop	.S1	4
		stw		A0,	*-A15(28)
		b	.S1	.BB1_74
		nop	.S1	4
.BB1_61:

		mvk	.S1	0,	A0
		stw		A0,	*-A15(28)
		b	.S1	.BB1_74
		nop	.S1	4
.BB1_62:

		mvk	.S1	59,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		cmpgt	.L1	A1,	A0,	A0
	[ A0]	b	.S1	.BB1_66
		nop	.S1	4

		ldw		*-A15(48),	A0
		nop	.S1	4
		add	.L1	A0,	1,	A0
		mvk	.S1	1,	A3
		cmpgt	.L1	A0,	A3,	A3
		stw		A0,	*-A15(48)
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_65
		nop	.S1	4

		ldw		*-A15(68),	A0
		nop	.S1	4
		stw		A0,	*-A15(28)
		b	.S1	.BB1_74
		nop	.S1	4
.BB1_65:

		mvk	.S1	0,	A0
		stw		A0,	*-A15(28)
		b	.S1	.BB1_74
		nop	.S1	4
.BB1_66:

		mvk	.S1	30,	A0
		ldw		*-A15(32),	A1
		nop	.S1	4
		cmpgtu	.L1	A1,	A0,	A0
	[ A0]	b	.S1	.BB1_68
		nop	.S1	4
.BB1_67:

		mvk	.S1	0,	A0
		mvk	.S1	1,	A3
		stw		A0,	*-A15(52)
		mv		A3,	A1
		stw		A1,	*-A15(28)
		stw		A0,	*-A15(48)
		b	.S1	.BB1_74
		nop	.S1	4
.BB1_68:

		mv		A1,	A0
		addk	.S1	-300,	A0
		mvk	.S1	45,	A3
		cmpgtu	.L1	A0,	A3,	A0
	[ A0]	b	.S1	.BB1_70
		nop	.S1	4

		mvk	.S1	0,	A0
		mvk	.S1	2,	A3
		stw		A0,	*-A15(52)
		mv		A3,	A1
		stw		A1,	*-A15(28)
		stw		A0,	*-A15(48)
		b	.S1	.BB1_74
		nop	.S1	4
.BB1_70:

		ldw		*-A15(32),	A0
		nop	.S1	4
		addk	.S1	-180,	A0
		mvk	.S1	90,	A3
		cmpgtu	.L1	A0,	A3,	A0
	[ A0]	b	.S1	.BB1_72
		nop	.S1	4

		mvk	.S1	0,	A0
		mvk	.S1	3,	A3
		stw		A0,	*-A15(52)
		mv		A3,	A1
		stw		A1,	*-A15(28)
		stw		A0,	*-A15(48)
		b	.S1	.BB1_74
		nop	.S1	4
.BB1_72:

		ldw		*-A15(32),	A0
		nop	.S1	4
		addk	.S1	-450,	A0
		mvk	.S1	106,	A3
		cmpltu	.L1	A0,	A3,	A0
	[ A0]	b	.S1	.BB1_67
		nop	.S1	4
.BB1_73:

		mvk	.S1	0,	A0
		mv		A0,	A1
		stw		A1,	*-A15(52)
		stw		A0,	*-A15(28)
		mv		A1,	A0
		stw		A0,	*-A15(48)
.BB1_74:

		mvk	.S1	255,	A0
		ldw		*-A15(68),	A1
		nop	.S1	4
		and	.L1	A1,	A0,	A3
		ldw		*-A15(28),	A1
		nop	.S1	4
		and	.L1	A1,	A0,	A0
		cmpeq	.L1	A3,	A0,	A0
	[ A0]	b	.S1	.BB1_81
		nop	.S1	4

		mvkl	.S1	_ZL4span,	A0
		mvkh	.S1	_ZL4span,	A0
		mvkl	.S1	_ZL5spans,	A3
		ldw		*A0,	A0
		nop	.S1	4
		mvkh	.S1	_ZL5spans,	A3
		ldw		*A3,	A3
		nop	.S1	4
		shl	.S1	A0,	5,	A4
		add	.L1	A3,	A4,	A4
		ldhu		*+A4(2),	A4
		nop	.S1	4
		ldw		*-A15(96),	A1
		nop	.S1	4
		cmpeq	.L1	A1,	A4,	A4
		mv		A3,	A1
		mv		A4,	A2
	[ A2]	b	.S1	.BB1_77
		nop	.S1	4
.BB1_76:

		b	.S1	.BB1_80
		nop	.S1	4
.BB1_77:

		shl	.S1	A0,	5,	A3
		add	.L1	A1,	A3,	A3
		ldhu		*+A3(16),	A3
		nop	.S1	4
		cmpeq	.L1	0,	A3,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_76
		nop	.S1	4

		shl	.S1	A0,	5,	A3
		shr	.S1	A3,	1,	A3
		ldhu		*A1(A3),	A3
		nop	.S1	4
		ldw		*-A15(64),	A2
		nop	.S1	4
		sub	.L1	A2,	A3,	A3
		mvk	.S1	4,	A4
		cmplt	.L1	A3,	A4,	A3
		mv		A3,	A2
	[ A2]	b	.S1	.BB1_76
		nop	.S1	4

		shl	.S1	A0,	5,	A0
		mvkl	.S1	_ZL4span,	A3
		add	.L1	A1,	A0,	A0
		mvkl	.S1	_ZL5spans,	A1
		mvkh	.S1	_ZL4span,	A3
		ldw		*-A15(56),	A2
		nop	.S1	4
		sth		A2,	*+A0(4)
		mvkh	.S1	_ZL5spans,	A1
		ldw		*A3,	A0
		nop	.S1	4
		ldw		*A1,	A4
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		add	.L1	A4,	A0,	A0
		ldw		*-A15(72),	A2
		nop	.S1	4
		sth		A2,	*+A0(6)
		ldw		*A3,	A0
		nop	.S1	4
		ldw		*A1,	A4
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		add	.L1	A4,	A0,	A0
		ldw		*-A15(56),	A2
		nop	.S1	4
		sth		A2,	*+A0(10)
		ldw		*A3,	A0
		nop	.S1	4
		ldw		*A1,	A4
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		add	.L1	A4,	A0,	A0
		ldw		*-A15(72),	A2
		nop	.S1	4
		sth		A2,	*+A0(14)
		ldw		*A3,	A0
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		ldw		*A1,	A4
		nop	.S1	4
		shr	.S1	A0,	1,	A5
		ldh		*A4(A5),	A5
		nop	.S1	4
		add	.L1	A4,	A0,	A0
		sth		A5,	*+A0(8)
		ldw		*A3,	A0
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		ldw		*A1,	A4
		nop	.S1	4
		add	.L1	A4,	A0,	A0
		ldh		*+A0(2),	A4
		nop	.S1	4
		sth		A4,	*+A0(12)
		ldw		*A3,	A0
		nop	.S1	4
		add	.L1	A0,	1,	A0
		stw		A0,	*A3
		ldw		*A1,	A1
		nop	.S1	4
.BB1_80:

		shl	.S1	A0,	5,	A0
		mvkl	.S1	_ZL4span,	A3
		shr	.S1	A0,	1,	A0
		mvkl	.S1	_ZL5spans,	A4
		mvkh	.S1	_ZL4span,	A3
		ldw		*-A15(56),	A2
		nop	.S1	4
		sth		A2,	*A1(A0)
		mvkh	.S1	_ZL5spans,	A4
		ldw		*A3,	A0
		nop	.S1	4
		ldw		*A4,	A5
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		add	.L1	A5,	A0,	A0
		ldw		*-A15(72),	A1
		nop	.S1	4
		sth		A1,	*+A0(2)
		ldw		*A3,	A0
		nop	.S1	4
		ldw		*A4,	A3
		nop	.S1	4
		shl	.S1	A0,	5,	A0
		mvk	.S1	255,	A4
		add	.L1	A3,	A0,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		and	.L1	A1,	A4,	A3
		sth		A3,	*+A0(16)
.BB1_81:

		ldw		*-A15(64),	A0
		nop	.S1	4
		add	.L1	A0,	1,	A0
		ldw		*-A15(76),	A1
		nop	.S1	4
		add	.L1	A1,	2,	A3
		ldw		*-A15(56),	A1
		nop	.S1	4
		add	.L1	A1,	1,	A4
		ldw		*-A15(100),	A1
		nop	.S1	4
		cmpeq	.L1	A1,	A0,	A5
		mv		A3,	A1
		stw		A1,	*-A15(76)
		stw		A0,	*-A15(64)
		mv		A4,	A1
		stw		A1,	*-A15(56)
		mv		A5,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		stw		A1,	*-A15(68)
	[ A0]	b	.S1	.BB1_28
		nop	.S1	4
		b	.S1	.BB1_30
		nop	.S1	4
.BB1_82:

		mvkl	.S1	_ZL4span,	A3
		mvkh	.S1	_ZL4span,	A3
		mvkl	.S1	_ZL5spans,	A4
		ldw		*A3,	A3
		nop	.S1	4
		mvkh	.S1	_ZL5spans,	A4
		ldw		*A4,	A4
		nop	.S1	4
		shl	.S1	A3,	5,	A5
		add	.L1	A4,	A5,	A5
		ldhu		*+A5(16),	A5
		nop	.S1	4
		cmpeq	.L1	0,	A5,	A5
		mv		A3,	A1
		mv		A5,	A2
	[!A2]	b	.S1	.BB1_84
		nop	.S1	4

		b	.S1	.BB1_85
		nop	.S1	4
.BB1_84:

		mv		A4,	A2
		shl	.S1	A1,	5,	A1
		mvkl	.S1	_ZL4span,	A3
		add	.L1	A2,	A1,	A1
		mvkl	.S1	_ZL5spans,	A4
		mvkh	.S1	_ZL4span,	A3
		sth		A0,	*+A1(4)
		mvkh	.S1	_ZL5spans,	A4
		ldw		*A3,	A1
		nop	.S1	4
		ldw		*A4,	A5
		nop	.S1	4
		shl	.S1	A1,	5,	A1
		add	.L1	A5,	A1,	A1
		ldw		*-A15(72),	A2
		nop	.S1	4
		sth		A2,	*+A1(6)
		ldw		*A3,	A1
		nop	.S1	4
		ldw		*A4,	A5
		nop	.S1	4
		shl	.S1	A1,	5,	A1
		add	.L1	A5,	A1,	A1
		sth		A0,	*+A1(10)
		ldw		*A3,	A1
		nop	.S1	4
		ldw		*A4,	A5
		nop	.S1	4
		shl	.S1	A1,	5,	A1
		add	.L1	A5,	A1,	A1
		sth		A2,	*+A1(14)
		ldw		*A3,	A1
		nop	.S1	4
		shl	.S1	A1,	5,	A1
		ldw		*A4,	A5
		nop	.S1	4
		shr	.S1	A1,	1,	A6
		ldh		*A5(A6),	A6
		nop	.S1	4
		add	.L1	A5,	A1,	A1
		sth		A6,	*+A1(8)
		ldw		*A3,	A1
		nop	.S1	4
		ldw		*A4,	A4
		nop	.S1	4
		shl	.S1	A1,	5,	A1
		add	.L1	A4,	A1,	A1
		sth		A2,	*+A1(12)
		ldw		*A3,	A1
		nop	.S1	4
		add	.L1	A1,	1,	A1
		stw		A1,	*A3
.BB1_85:

		mvk	.S1	0,	A3
		cmpgt	.L1	A1,	A3,	A3
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_87
		nop	.S1	4
.BB1_86:

		b	.S1	.BB1_96
		nop	.S1	4
.BB1_87:

		mvk	.S1	0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(48)
.BB1_88:

		ldw		*-A15(48),	A0
		nop	.S1	4
		stw		A0,	*-A15(56)
		mvkl	.S1	_ZL5spans,	A3
		mvkl	.S1	_ZL5ospan,	A4
		mvkl	.S1	_ZL6ospans,	A5
		mvkh	.S1	_ZL5spans,	A3
		mvkh	.S1	_ZL5ospan,	A4
		mvkh	.S1	_ZL6ospans,	A5
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
		stw		A0,	*-A15(48)
		mv		A3,	A0
		stw		A0,	*-A15(52)
		mv		A4,	A0
		stw		A0,	*-A15(28)
		mv		A6,	A0
		stw		A0,	*-A15(36)
		mv		A6,	A0
		stw		A0,	*-A15(40)
		mv		A6,	A0
		stw		A0,	*-A15(44)
		mv		A5,	A0
.BB1_89:

		ldw		*-A15(32),	A1
		nop	.S1	4
		cmplt	.L1	A1,	A0,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_95
		nop	.S1	4

		shl	.S1	A0,	5,	A3
		shr	.S1	A3,	1,	A3
		ldw		*-A15(36),	A1
		nop	.S1	4
		ldhu		*A1,	A4
		nop	.S1	4
		ldw		*-A15(28),	A1
		nop	.S1	4
		ldhu		*A1(A3),	A3
		nop	.S1	4
		sub	.L1	A4,	A3,	A3
		shr	.S1	A3,	31,	A4
		add	.L1	A3,	A4,	A3
		xor	.D1	A3,	A4,	A3
		mvk	.S1	7,	A4
		cmpgt	.L1	A3,	A4,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_94
		nop	.S1	4

		shl	.S1	A0,	5,	A3
		ldw		*-A15(28),	A1
		nop	.S1	4
		add	.L1	A1,	A3,	A3
		mv		A3,	A1
		ldw		*-A15(40),	A2
		nop	.S1	4
		ldhu		*+A2(4),	A4
		nop	.S1	4
		ldhu		*+A1(4),	A5
		nop	.S1	4
		sub	.L1	A4,	A5,	A5
		shr	.S1	A5,	31,	A6
		add	.L1	A5,	A6,	A5
		xor	.D1	A5,	A6,	A5
		mvk	.S1	7,	A6
		cmpgt	.L1	A5,	A6,	A5
		mv		A5,	A1
	[ A1]	b	.S1	.BB1_94
		nop	.S1	4

		mv		A3,	A1
		ldhu		*+A1(16),	A3
		nop	.S1	4
		ldw		*-A15(44),	A1
		nop	.S1	4
		ldhu		*+A1(16),	A5
		nop	.S1	4
		cmpeq	.L1	A3,	A5,	A3
		mv		A3,	A1
	[!A1]	b	.S1	.BB1_94
		nop	.S1	4

		mv		A4,	A1
		shl	.S1	A0,	5,	A0
		ldw		*-A15(28),	A2
		nop	.S1	4
		add	.L1	A2,	A0,	A3
		ldhu		*+A3(10),	A3
		nop	.S1	4
		ldw		*-A15(56),	A2
		nop	.S1	4
		shl	.S1	A2,	5,	A4
		cmpgtu	.L1	A3,	A1,	A5
		mvkl	.S1	_ZL6ospans,	A6
		ldw		*-A15(52),	A2
		nop	.S1	4
		add	.L1	A2,	A4,	A7
		mv		A5,	A2
	[!A2]	mv	.S1	A1,	A3
		mvkl	.S1	_ZL5spans,	A5
		mvkh	.S1	_ZL6ospans,	A6
		sth		A3,	*+A7(10)
		mvkh	.S1	_ZL5spans,	A5
		ldw		*A6,	A3
		nop	.S1	4
		add	.L1	A3,	A0,	A3
		ldw		*A5,	A7
		nop	.S1	4
		shr	.S1	A4,	1,	A8
		ldhu		*+A3(8),	A3
		nop	.S1	4
		ldhu		*A7(A8),	A8
		nop	.S1	4
		cmpltu	.L1	A3,	A8,	A9
		add	.L1	A7,	A4,	A7
		mv		A9,	A1
	[!A1]	mv	.S1	A8,	A3
		sth		A3,	*+A7(8)
		ldw		*A6,	A3
		nop	.S1	4
		ldw		*A5,	A7
		nop	.S1	4
		add	.L1	A7,	A4,	A7
		add	.L1	A3,	A0,	A3
		ldhu		*+A3(14),	A3
		nop	.S1	4
		ldhu		*+A7(6),	A8
		nop	.S1	4
		cmpgtu	.L1	A3,	A8,	A9
		mv		A9,	A1
	[!A1]	mv	.S1	A8,	A3
		sth		A3,	*+A7(14)
		ldw		*A6,	A3
		nop	.S1	4
		add	.L1	A3,	A0,	A3
		ldw		*A5,	A5
		nop	.S1	4
		ldh		*+A3(12),	A3
		nop	.S1	4
		add	.L1	A5,	A4,	A4
		sth		A3,	*+A4(12)
		ldw		*A6,	A3
		nop	.S1	4
		add	.L1	A3,	A0,	A0
		mvk	.S1	0,	A3
		sth		A3,	*+A0(16)
		b	.S1	.BB1_95
		nop	.S1	4
.BB1_94:

		add	.L1	A0,	1,	A0
		b	.S1	.BB1_89
		nop	.S1	4
.BB1_95:

		mvkl	.S1	_ZL4span,	A3
		mvkh	.S1	_ZL4span,	A3
		ldw		*A3,	A3
		nop	.S1	4
		ldw		*-A15(48),	A0
		nop	.S1	4
		cmplt	.L1	A0,	A3,	A3
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_88
		nop	.S1	4
		b	.S1	.BB1_86
		nop	.S1	4
.BB1_96:

		mvkl	.S1	_ZL5ospan,	A3
		mvkh	.S1	_ZL5ospan,	A3
		ldw		*A3,	A0
		nop	.S1	4
		stw		A0,	*-A15(28)
.BB1_97:

		mvk	.S1	0,	A3
		ldw		*-A15(28),	A0
		nop	.S1	4
		cmpgt	.L1	A0,	A3,	A3
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_99
		nop	.S1	4
.BB1_98:

		b	.S1	.BB1_106
		nop	.S1	4
.BB1_99:

		mvk	.S1	10,	A3
		mvk	.S1	0,	A4
		mv		A3,	A0
		mv		A4,	A1
		stw		A1,	*-A15(28)
.BB1_100:

		mvkl	.S1	_ZL6ospans,	A3
		mvkh	.S1	_ZL6ospans,	A3
		ldw		*A3,	A3
		nop	.S1	4
		add	.L1	A3,	A0,	A4
		ldhu		*+A4(6),	A4
		nop	.S1	4
		ldw		*-A15(28),	A1
		nop	.S1	4
		add	.L1	A1,	1,	A5
		cmpeq	.L1	0,	A4,	A6
		mv		A5,	A1
		stw		A1,	*-A15(28)
		mv		A6,	A1
	[ A1]	b	.S1	.BB1_105
		nop	.S1	4

		mv		A3,	A1
		add	.L1	A1,	A0,	A3
		shr	.S1	A0,	1,	A5
		ldhu		*A1(A5),	A5
		nop	.S1	4
		ldhu		*-A3(2),	A6
		nop	.S1	4
		ldhu		*+A3(4),	A7
		nop	.S1	4
		ldhu		*+A3(2),	A3
		nop	.S1	4
		sub	.L1	A5,	A6,	A8
		sub	.L1	A7,	A3,	A9
		mpy32	.M1	A9,	A8,	A16
		nop	.S1	3
		mvk	.S1	5,	A17
		cmplt	.L1	A16,	A17,	A16
		mv		A16,	A1
	[ A1]	b	.S1	.BB1_105
		nop	.S1	4

		mv		A8,	A1
		mvk	.S1	3,	A8
		cmplt	.L1	A1,	A8,	A8
		mv		A8,	A1
	[ A1]	b	.S1	.BB1_105
		nop	.S1	4

		mv		A9,	A1
		mvk	.S1	3,	A8
		cmplt	.L1	A1,	A8,	A8
		mv		A8,	A1
	[ A1]	b	.S1	.BB1_105
		nop	.S1	4

		mv		A4,	A1
		stw		A1,	*-A15(32)
		mv		A6,	A2
		mv		A3,	A1
		stw		A1,	*-A15(36)
		mv		A5,	A1
		stw		A1,	*-A15(44)
		mv		A7,	A1
		stw		A1,	*-A15(40)
		mvkl	.S1	_ZL9num_blobs,	A3
		mvkh	.S1	_ZL9num_blobs,	A3
		mvkl	.S1	_ZL5blobs,	A4
		ldw		*A3,	A5
		nop	.S1	4
		mvkh	.S1	_ZL5blobs,	A4
		shl	.S1	A5,	5,	A5
		ldw		*A4,	A6
		nop	.S1	4
		shr	.S1	A5,	1,	A5
		sth		A2,	*A6(A5)
		ldw		*A3,	A5
		nop	.S1	4
		ldw		*A4,	A6
		nop	.S1	4
		shl	.S1	A5,	5,	A5
		add	.L1	A6,	A5,	A5
		ldw		*-A15(44),	A1
		nop	.S1	4
		sth		A1,	*+A5(4)
		ldw		*A3,	A5
		nop	.S1	4
		ldw		*A4,	A6
		nop	.S1	4
		shl	.S1	A5,	5,	A5
		add	.L1	A6,	A5,	A5
		ldw		*-A15(36),	A1
		nop	.S1	4
		sth		A1,	*+A5(2)
		ldw		*A3,	A5
		nop	.S1	4
		ldw		*A4,	A6
		nop	.S1	4
		shl	.S1	A5,	5,	A5
		add	.L1	A6,	A5,	A5
		ldw		*-A15(40),	A1
		nop	.S1	4
		sth		A1,	*+A5(6)
		ldw		*A3,	A5
		nop	.S1	4
		ldw		*A4,	A4
		nop	.S1	4
		shl	.S1	A5,	5,	A5
		add	.L1	A4,	A5,	A4
		ldw		*-A15(32),	A1
		nop	.S1	4
		sth		A1,	*+A4(16)
		ldw		*A3,	A4
		nop	.S1	4
		add	.L1	A4,	1,	A4
		stw		A4,	*A3
.BB1_105:

		mvkl	.S1	_ZL5ospan,	A3
		mvkh	.S1	_ZL5ospan,	A3
		ldw		*A3,	A3
		nop	.S1	4
		addk	.S1	32,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		cmplt	.L1	A1,	A3,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_100
		nop	.S1	4
		b	.S1	.BB1_98
		nop	.S1	4
.BB1_106:

		mvk	.S1	-33,	A3
		ldw		*A15(A3),	A0
		nop	.S1	4
		ldw		*-A15(120),	A1
		nop	.S1	4
		add	.L1	A0,	A1,	A3
		mvk	.S1	320,	A4
		cmpeq	.L1	A3,	A4,	A3
		mv		A3,	A0
	[ A0]	b	.S1	.BB1_108
		nop	.S1	4

		ldw		*-A15(96),	A0
		nop	.S1	4
		add	.L1	A0,	1,	A3
		mv		A3,	A0
		stw		A0,	*-A15(96)
		mvkl	.S1	_ZL6ospans,	A3
		mvkl	.S1	_ZL5spans,	A4
		mvkl	.S1	_ZL4span,	A5
		mvkh	.S1	_ZL6ospans,	A3
		mvkh	.S1	_ZL5spans,	A4
		mvkh	.S1	_ZL4span,	A5
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
		ldw		*-A15(72),	A1
		nop	.S1	4
		add	.L1	A1,	1,	A4
		mv		A6,	A1
		stw		A1,	*-A15(108)
		mv		A3,	A1
		stw		A1,	*-A15(120)
		stw		A0,	*-A15(116)
		mv		A4,	A1
		stw		A1,	*-A15(72)
		b	.S1	.BB1_2
		nop	.S1	4
.BB1_108:

		ldw		*-A15(20),	A13
		nop	.S1	4
		ldw		*-A15(16),	A12
		nop	.S1	4
		ldw		*-A15(12),	A11
		nop	.S1	4
		ldw		*-A15(8),	A10
		nop	.S1	4
ldw		*-A15(4),	B3
		mv		A15,	B15
	||	ldw		*A15,	A15
		nop		4

		bnop	.S2	B3,	5
	.type	_ZL11trans_table,@object
	.data
	.align	2
_ZL11trans_table:
	.word	0
	.word	1044480
	.word	522240
	.word	348160
	.word	261120
	.word	208896
	.word	174080
	.word	149211
	.word	130560
	.word	116053
	.word	104448
	.word	94953
	.word	87040
	.word	80345
	.word	74606
	.word	69632
	.word	65280
	.word	61440
	.word	58027
	.word	54973
	.word	52224
	.word	49737
	.word	47476
	.word	45412
	.word	43520
	.word	41779
	.word	40172
	.word	38684
	.word	37303
	.word	36017
	.word	34816
	.word	33693
	.word	32640
	.word	31651
	.word	30720
	.word	29842
	.word	29013
	.word	28229
	.word	27486
	.word	26782
	.word	26112
	.word	25475
	.word	24869
	.word	24290
	.word	23738
	.word	23211
	.word	22706
	.word	22223
	.word	21760
	.word	21316
	.word	20890
	.word	20480
	.word	20086
	.word	19707
	.word	19342
	.word	18991
	.word	18651
	.word	18324
	.word	18008
	.word	17703
	.word	17408
	.word	17123
	.word	16846
	.word	16579
	.word	16320
	.word	16069
	.word	15825
	.word	15589
	.word	15360
	.word	15137
	.word	14921
	.word	14711
	.word	14507
	.word	14308
	.word	14115
	.word	13926
	.word	13743
	.word	13565
	.word	13391
	.word	13221
	.word	13056
	.word	12895
	.word	12738
	.word	12584
	.word	12434
	.word	12288
	.word	12145
	.word	12006
	.word	11869
	.word	11736
	.word	11605
	.word	11478
	.word	11353
	.word	11231
	.word	11111
	.word	10995
	.word	10880
	.word	10768
	.word	10658
	.word	10550
	.word	10445
	.word	10341
	.word	10240
	.word	10141
	.word	10043
	.word	9947
	.word	9854
	.word	9761
	.word	9671
	.word	9582
	.word	9495
	.word	9410
	.word	9326
	.word	9243
	.word	9162
	.word	9082
	.word	9004
	.word	8927
	.word	8852
	.word	8777
	.word	8704
	.word	8632
	.word	8561
	.word	8492
	.word	8423
	.word	8356
	.word	8290
	.word	8224
	.word	8160
	.word	8097
	.word	8034
	.word	7973
	.word	7913
	.word	7853
	.word	7795
	.word	7737
	.word	7680
	.word	7624
	.word	7569
	.word	7514
	.word	7461
	.word	7408
	.word	7355
	.word	7304
	.word	7253
	.word	7203
	.word	7154
	.word	7105
	.word	7057
	.word	7010
	.word	6963
	.word	6917
	.word	6872
	.word	6827
	.word	6782
	.word	6739
	.word	6695
	.word	6653
	.word	6611
	.word	6569
	.word	6528
	.word	6487
	.word	6447
	.word	6408
	.word	6369
	.word	6330
	.word	6292
	.word	6254
	.word	6217
	.word	6180
	.word	6144
	.word	6108
	.word	6073
	.word	6037
	.word	6003
	.word	5968
	.word	5935
	.word	5901
	.word	5868
	.word	5835
	.word	5803
	.word	5771
	.word	5739
	.word	5708
	.word	5677
	.word	5646
	.word	5615
	.word	5585
	.word	5556
	.word	5526
	.word	5497
	.word	5468
	.word	5440
	.word	5412
	.word	5384
	.word	5356
	.word	5329
	.word	5302
	.word	5275
	.word	5249
	.word	5222
	.word	5196
	.word	5171
	.word	5145
	.word	5120
	.word	5095
	.word	5070
	.word	5046
	.word	5022
	.word	4998
	.word	4974
	.word	4950
	.word	4927
	.word	4904
	.word	4881
	.word	4858
	.word	4836
	.word	4813
	.word	4791
	.word	4769
	.word	4748
	.word	4726
	.word	4705
	.word	4684
	.word	4663
	.word	4642
	.word	4622
	.word	4601
	.word	4581
	.word	4561
	.word	4541
	.word	4522
	.word	4502
	.word	4483
	.word	4464
	.word	4445
	.word	4426
	.word	4407
	.word	4389
	.word	4370
	.word	4352
	.word	4334
	.word	4316
	.word	4298
	.word	4281
	.word	4263
	.word	4246
	.word	4229
	.word	4212
	.word	4195
	.word	4178
	.word	4161
	.word	4145
	.word	4128
	.word	4112
	.word	4096
	.size	_ZL11trans_table, 1024

	.type	_ZL5blobs,@object
	.lcomm	_ZL5blobs,4
	.type	_ZL9num_blobs,@object
	.lcomm	_ZL9num_blobs,4
	.type	_ZL7spans_a,@object
	.lcomm	_ZL7spans_a,1056
	.type	_ZL5spans,@object
	.lcomm	_ZL5spans,4
	.type	_ZL7spans_b,@object
	.lcomm	_ZL7spans_b,1056
	.type	_ZL6ospans,@object
	.lcomm	_ZL6ospans,4
	.type	_ZL4span,@object
	.lcomm	_ZL4span,4
	.type	_ZL5ospan,@object
	.lcomm	_ZL5ospan,4
	.type	_ZL10dma_buffer,@object
	.lcomm	_ZL10dma_buffer,4
	.type	_ZL14working_buffer,@object
	.lcomm	_ZL14working_buffer,4

