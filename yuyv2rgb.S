	.file	"yuyv2rgb.c"


	.text
	.globl	yuyv2rgb
	.align	5
	.type	yuyv2rgb,@function
yuyv2rgb:
		mvk		40,	A0
	||	mv		B15,	A1
		stw		A15,	*B15
	||	stw		B3,	*-A1(4)
	||	mv		B15,	A15
	||	sub		B15,	A0	,B15

		mv		B8,	A3
		mv		B6,	A5
		mv		B4,	A7
		mvk	.S1	298,	A9
		addk	.S1	-128,	A6
		mvk	.S1	409,	A16
		mpy32	.M1	A4,	A9,	A4
		nop	.S1	3
		mvk	.S1	-4640,	A9
		add	.L1	A4,	A9,	A4
		mpy32	.M1	A6,	A16,	A9
		nop	.S1	3
		add	.L1	A4,	A9,	A9
		mvk	.S1	-1,	A16
		addk	.S1	-128,	A7
		cmpgt	.L1	A9,	A16,	A16

		mvk	.S1	100,	A0
		mpy32	.M1	A7,	A0,	A17
		nop		3
		sub	.L1	A4,	A17,	A17

		mvk	.S1	208,	A0
		mpy32	.M1	A6,	A0,	A0
		nop	.S1	3
		sub	.L1	A17,	A0,	A17

		mv		A5,	A0
		stw		A0,	*-A15(32)
		mv		A8,	A0
		stw		A0,	*-A15(28)
		mv		A3,	A0
		stw		A0,	*-A15(24)
		mv		A7,	A0
		stw		A0,	*-A15(16)
		mv		A6,	A0
		stw		A0,	*-A15(12)
		mv		A4,	A0
		stw		A0,	*-A15(20)
		mv		A16,	A0
	[ A0]	b	.S1	.BB1_2
		nop	.S1	4

		mvk	.S1	0,	A9
		mv		A9,	A0
		stw		A0,	*-A15(8)
		b	.S1	.BB1_3
		nop	.S1	4
.BB1_2:

		mv		A9,	A0
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
		stw		A0,	*-A15(8)
.BB1_3:

mv A17, A3	; reload forwarded calc

		mvk	.S1	-1,	A4
		cmpgt	.L1	A3,	A4,	A4
		mv		A4,	A0
	[ A0]	b	.S1	.BB1_5
		nop	.S1	4

		mvk	.S1	0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(12)
		b	.S1	.BB1_6
		nop	.S1	4
.BB1_5:

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
		stw		A0,	*-A15(12)
.BB1_6:

		mvk	.S1	516,	A3
		ldw		*-A15(16),	A0
		nop	.S1	4
		mpy32	.M1	A0,	A3,	A3
		nop	.S1	3
		ldw		*-A15(20),	A0
		nop	.S1	4
		add	.L1	A0,	A3,	A3
		mvk	.S1	-1,	A4
		cmpgt	.L1	A3,	A4,	A4
		mv		A4,	A0
	[ A0]	b	.S1	.BB1_8
		nop	.S1	4

		mvk	.S1	0,	A3
		mv		A3,	A0
		b	.S1	.BB1_9
		nop	.S1	4
.BB1_8:

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
.BB1_9:

		ldw		*-A15(8),	A1
		nop	.S1	4
		mv		A1,	A3
		shru	.S1	A3,	8,	A3
		mv		A1,	A4
		shru	.S1	A4,	16,	A4
		mv		A1,	A5
		shru	.S1	A5,	24,	A5
		ldw		*-A15(12),	A1
		nop	.S1	4
		mv		A1,	A6
		shru	.S1	A6,	8,	A6
		mv		A1,	A7
		shru	.S1	A7,	16,	A7
		mv		A1,	A8
		shru	.S1	A8,	24,	A8
		ldw		*-A15(32),	A1
		nop	.S1	4
		ldw		*-A15(8),	A2
		nop	.S1	4
		stb		A2,	*A1
		stb		A3,	*+A1(1)
		stb		A4,	*+A1(2)
		stb		A5,	*+A1(3)
		shru	.S1	A0,	8,	A3
		shru	.S1	A0,	16,	A4
		shru	.S1	A0,	24,	A5
		ldw		*-A15(28),	A1
		nop	.S1	4
		ldw		*-A15(12),	A2
		nop	.S1	4
		stb		A2,	*A1
		stb		A6,	*+A1(1)
		stb		A7,	*+A1(2)
		stb		A8,	*+A1(3)
		ldw		*-A15(24),	A1
		nop	.S1	4
		stb		A0,	*A1
		stb		A3,	*+A1(1)
		stb		A4,	*+A1(2)
		stb		A5,	*+A1(3)
		ldw		*-A15(4),	B3
		mv		A15,	B15
	||	ldw		*A15,	A15
		nop		4

		bnop	.S2	B3,	5

