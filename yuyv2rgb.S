	.file	"yuyv2rgb.c"


	.text
	.globl	yuv2rgb
	.align	5
	.type	yuv2rgb,@function
yuv2rgb:
		mvk		24,	A0
	||	mv		B15,	A1
		stw		A15,	*B15
	||	stw		B3,	*-A1(4)
	||	mv		B15,	A15
	||	sub		B15,	A0	,B15

		mv		B4,	A3
		mvk	.S1	298,	A5
		addk	.S1	-128,	A6
		mvk	.S1	409,	A7
		mpy32	.M1	A4,	A5,	A4
		nop	.S1	3
		mvk	.S1	-4640,	A5
		add	.L1	A4,	A5,	A4
		mpy32	.M1	A6,	A7,	A5
		nop	.S1	3
		add	.L1	A4,	A5,	A5
		mvk	.S1	-1,	A7
		addk	.S1	-128,	A3
		cmpgt	.L1	A5,	A7,	A7
		mv		A3,	A0
		stw		A0,	*-A15(8)
		mv		A6,	A0
		mv		A4,	A1
		stw		A1,	*-A15(12)
		mv		A7,	A1
	[ A1]	b	.S1	.BB1_2
		nop	.S1	4

		mvk	.S1	0,	A5
		mv		A5,	A1
		stw		A1,	*-A15(16)
		b	.S1	.BB1_3
		nop	.S1	4
.BB1_2:

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
		stw		A1,	*-A15(16)
.BB1_3:

		mvk	.S1	100,	A3
		ldw		*-A15(8),	A1
		nop	.S1	4
		mpy32	.M1	A1,	A3,	A3
		nop	.S1	3
		mvk	.S1	208,	A4
		ldw		*-A15(12),	A1
		nop	.S1	4
		sub	.L1	A1,	A3,	A3
		mpy32	.M1	A0,	A4,	A4
		nop	.S1	3
		sub	.L1	A3,	A4,	A3
		mvk	.S1	-1,	A4
		cmpgt	.L1	A3,	A4,	A4
		mv		A4,	A0
	[ A0]	b	.S1	.BB1_5
		nop	.S1	4

		mvk	.S1	0,	A3
		mv		A3,	A0
		b	.S1	.BB1_6
		nop	.S1	4
.BB1_5:

		mv		A3,	A0
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
.BB1_6:

		mvk	.S1	516,	A3
		ldw		*-A15(8),	A1
		nop	.S1	4
		mpy32	.M1	A1,	A3,	A3
		nop	.S1	3
		ldw		*-A15(12),	A1
		nop	.S1	4
		add	.L1	A1,	A3,	A3
		mvk	.S1	-1,	A4
		cmpgt	.L1	A3,	A4,	A4
		mv		A4,	A1
	[ A1]	b	.S1	.BB1_8
		nop	.S1	4

		mvk	.S1	0,	A3
		mv		A3,	A1
		b	.S1	.BB1_9
		nop	.S1	4
.BB1_8:

		mv		A3,	A1
		mvk	.S1	0,	A3
		shr	.S1	A1,	8,	A4
		mvk	.S1	255,	A5
		cmpgt	.L1	A4,	A5,	A6
		cmplt	.L1	A1,	A3,	A1
		mv		A6,	A2
	[!A2]	mv	.S1	A3,	A5
		or	.D1	A6,	A1,	A1
	[!A1]	mv	.S1	A4,	A5
		mv		A5,	A1
.BB1_9:

		ldw		*-A15(16),	A2
		nop	.S1	4
		add	.L1	A0,	A2,	A3
		add	.L1	A3,	A1,	A4
		ldw		*-A15(4),	B3
		mv		A15,	B15
	||	ldw		*A15,	A15
		nop		4

		bnop	.S2	B3,	5

