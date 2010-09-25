	.file	"rgb2hsv.c"


	.text
	.globl	rgb2hsv
	.align	5
	.type	rgb2hsv,@function
rgb2hsv:
		mvk		40,	A0
	||	mv		B15,	A1
		stw		A15,	*B15
	||	stw		B3,	*-A1(4)
	||	mv		B15,	A15
	||	sub		B15,	A0	,B15

		mv		B8,	A3
		mv		B6,	A5
		mv		B4,	A7

		max2		A4,	B4,	A0
		max2		A6,	A0,	A0
		min2		A4,	B4,	A1
		min2		A6,	A1,	A1
		mvkh		0,		A0
		mvkh		0,		A1
		mv		A0,		A17
		mv		A1,		A9

		cmpeq	.L1	0,	A17,	A16
		mv		A5,	A0
		stw		A0,	*-A15(24)
		mv		A8,	A0
		stw		A0,	*-A15(20)
		mv		A3,	A0
		stw		A0,	*-A15(16)
		mv		A17,	A0
		stw		A0,	*-A15(8)
		mv		A16,	A0

		; If v == 0, jmp - this is a valid branch to keep
	[!A0]	b	.S1	.BB1_2
		nop	.S1	5

		mvk	.S1	0,	A7
		mv		A7,	A0		; s and h = 0?
		stw		A0,	*-A15(12)
		b	.S1	.BB1_11
		nop	.S1	5
.BB1_2:

		sub	.L1	A17,	A9,	A20	; diff = max - min
		mv		A9,	A1
		mvkl	.S1	trans_table,	A3
		mvkh	.S1	trans_table,	A3
		ldw		*A3(A17),	A3
		nop	.S1	4
		mpy32	.M1	A3,	A20,	A0
		nop	.S1	3
		shru	.S1	A0,	12,	A0
		cmpeq	.L1	A17,	A1,	A3	; if (diff != 0)?
		stw		A0,	*-A15(28)
		mv		A3,	A0
	[!A0]	b	.S1	.BB1_5			; if nz, do some calcs
		nop	.S1	5

		mvk	.S1	0,	A7
		mv		A7,	A0
.BB1_4:

		; Looks like, despite being high up in this function, this
		; corresponds to the end of the if (diff != 0) block
		mvk	.S1	0,	A3
		cmplt	.L1	A0,	A3,	A4
		mv		A4,	A1
	[!A1]	mv	.S1	A0,	A3
		mv		A3,	A0
		stw		A0,	*-A15(12)
		b	.S1	.BB1_8
		nop	.S1	5
.BB1_5:
		; for this block, 'v' is A17
		mv		A6,	A21			; keep 'b' value
		sub	.L1	A7,	A21,	A9
		sub	.L1	A21,	A4,	A3
		sub	.L1	A4,	A7,	A8
		cmpeq	.L1	A17,	A4,	A2
		cmpeq	.L1	A17,	A7,	A1
		cmpeq	.L1	A17,	A21,	A0
	[!A2]	mvk	.S1	0,	A9
	[!A1]	mv	.S1	A9,	A3
	[!A0]	mv	.S1	A3,	A8
		mvk		0,	A22
	[ A1]	addk		60,	A22
	[ A0]	addk		120,	A22

		mvkl	.S1	trans_table,	A6
		mvkh	.S1	trans_table,	A6
		ldw		*A6(A20),	A3
		nop	.S1	4
		mvkl	.S1	262144,	A6
		mpy32	.M1	A8,	A3,	A0
		nop	.S1	3
		mvk	.S1	15,	A3
		mpy32	.M1	A0,	A3,	A0
		nop	.S1	3
		mvkh	.S1	262144,	A6
		add	.L1	A0,	A6,	A0
		shr	.S1	A0,	19,	A0
		add		A22,	A0,	A0
		mvk	.S1	255,	A3
		cmpgt	.L1	A0,	A3,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_7
		nop	.S1	5

		b	.S1	.BB1_4
		nop	.S1	5
.BB1_7:

		mvk	.S1	255,	A0
		stw		A0,	*-A15(12)
.BB1_8:

		mvk	.S1	255,	A0
		ldw		*-A15(28),	A1
		nop	.S1	4
		mv		A1,	A3
		cmpgtu	.L1	A3,	A0,	A3
		mvk	.S1	256,	A4
		mv		A3,	A2
	[!A2]	mv	.S1	A1,	A0
		ldw		*-A15(8),	A1
		nop	.S1	4
		cmplt	.L1	A1,	A4,	A3
		mv		A3,	A1
	[ A1]	b	.S1	.BB1_10
		nop	.S1	5

		mvk	.S1	255,	A3
		mv		A3,	A1
		stw		A1,	*-A15(8)
		b	.S1	.BB1_11
		nop	.S1	5
.BB1_10:

		mvk	.S1	0,	A3
		ldw		*-A15(8),	A1
		nop	.S1	4
		cmplt	.L1	A1,	A3,	A4
		mv		A4,	A2
	[!A2]	mv	.S1	A1,	A3
		mv		A3,	A1
		stw		A1,	*-A15(8)
.BB1_11:

		ldw		*-A15(12),	A1
		nop	.S1	4
		ldw		*-A15(24),	A2
		nop	.S1	4
		stw		A1,	*A2
		ldw		*-A15(8),	A1
		nop	.S1	4
		ldw		*-A15(20),	A2
		nop	.S1	4
		stw		A0,	*A2
		ldw		*-A15(16),	A0
		nop	.S1	4
		stw		A1,	*A0


		ldw		*-A15(4),	B3
		mv		A15,	B15
	||	ldw		*A15,	A15
		nop		4

		bnop	.S2	B3,	5

