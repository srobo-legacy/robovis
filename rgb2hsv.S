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

		mv		A8,	B7
	||	mvk		0,	A26

		; Calculate min/max of [r,g,b], load [h,s,v] = 0 in case we
		; end up with v = 0 and writing out early
		max2		A4,	B4,	A17
	||	min2		B4,	A4,	B9
	||	mvkl		trans_table,	A25
		max2		A6,	A17,	A17
	||	min2		B9,	A6,	B9
	||	mv		A26,	A24
	||	mvkh		trans_table,	A25
		mvkh		0,		A17
	||	mvkh		0,		B9
		cmpeq		0,	A17,	A1
	||	ldw		*A25(A17),	A5	; trans_table load
	||	sub		A17,	B9,	A20	; diff = max - min
		; If v == 0, we write out all zeros
	||[ A1]	b	.S2	.writeout
		; We don't require any nops here - if the branch isn't taken
		; no-one cares, and if it /is/ taken, it still doesn't matter
		; so long as nothing in the following five cycles alters
		; A24, A26, or A17 where the zeros being written out lie

.calcsat:

		mpy32	.M1	A5,	A20,	A0
	||	cmpeq	.L1X	A17,	B9,	A1	; if (diff != 0)?
		nop	.S1	3			; unavoidable
		shru	.S1	A0,	12,	A23
		; Can't make this any shorter, branch to writeout executes
		; up to this point
	[ A1]	b	.S1	.clipping

.calch:
		; for this block, 'v' is A17
		mv		A6,	A21			; keep 'b' value
		sub	.L1X	B4,	A21,	A9
		sub	.L1	A21,	A4,	A3
		sub	.L1X	A4,	B4,	A8
		cmpeq	.L1	A17,	A4,	A2
		cmpeq	.L1X	A17,	B4,	A1
		cmpeq	.L1	A17,	A21,	A0
	[!A2]	mvk	.S1	0,	A9
	[!A1]	mv	.S1	A9,	A3
	[!A0]	mv	.S1	A3,	A8
		mvk		0,	A22
	[ A1]	addk		60,	A22
	[ A0]	addk		120,	A22

		ldw		*A25(A20),	A3
		nop	.S1	4
		mvkl	.S1	262144,	A6
		mvkh	.S1	262144,	A6
		mpy32	.M1	A8,	A3,	A0
		nop	.S1	3
		mvk	.S1	15,	A3
		mpy32	.M1	A0,	A3,	A0
		nop	.S1	3
		add	.L1	A0,	A6,	A0
		shr	.S1	A0,	19,	A0
		add		A22,	A0,	A24



.clipping:
		mvk	.S1	255,	A3
		mvk		0,	A4

		max2		A4,	A24,	A24
		min2		A3,	A24,	A24
		mvkh		0,	A24

		max2		A4,	A23,	A26
		min2		A3,	A26,	A26
		mvkh		0,	A26

		max2		A4,	A17,	A17
		min2		A3,	A17,	A17
		mvkh		0,	A17

.writeout:


		stw		A24,	*B6
		stw		A26,	*B7
		stw		A17,	*B8


		ldw		*-A15(4),	B3
		mv		A15,	B15
	||	ldw		*A15,	A15
		nop		4

		bnop	.S2	B3,	5

