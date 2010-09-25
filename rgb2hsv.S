	.file	"rgb2hsv.c"


	.text
	.globl	rgb2hsv
	.align	5
	.type	rgb2hsv,@function
rgb2hsv:
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
	||	ldw		*A25(A20),	A7	; Preload for calch
		shru	.S1	A0,	12,	A23
		; Can't make this any shorter, branch to writeout executes
		; up to this point
	||	mv		A6,	B0		; Move stuff around for
	||	mv		B4,	A5		; calch code

.calch:
	[ A1]	b	.S1	.clipping
	||	sub		B4,	B0,	B9
	||	sub		A6,	A4,	A3
	||	cmpeq		A17,	A4,	A2
	||	cmpeq		B4,	A17,	B1

		sub		A4,	A5,	A8
	||	cmpeq		A17,	A6,	A0
	||[!A2]	mvk		0,	B9
	||[!B1]	mv		B9,	A3
	||	mvk		0,	B1

	[!A0]	mv		A3,	A8
	||[ B1]	addk		60,	B1
	||	mvkl		262144,	A6

	[ A0]	addk		120,	B1
	||	mvkh	.S1	262144,	A6
	||	mpy32	.M1	A8,	A7,	A0
	||	mvk		15,	B2

		; This entire sequence is critical-path'd up
		nop	.S1	3
		mpy32	.M1X	A0,	B2,	A0
		nop	.S1	3
		add	.L1	A0,	A6,	A0
		shr	.S1	A0,	19,	A0
		add		A0,	B1,	A24


.clipping:
		mvk		255,	A3
	||	mvk		255,	B2
		mvk		0,	A4
	||	mvk		0,	B4

		max2		A4,	A24,	A24
	||	max2		B4,	A23,	B5
		min2		A3,	A24,	A24
	||	min2		B2,	B5,	B5
		mvkh		0,	A24
	||	mvkh		0,	B5
	||	max2		A4,	A17,	A17

		min2		A3,	A17,	A17

		mvkh		0,	A17
	||	mv		B5,	A26

.writeout:


		stw		A24,	*B6
		stw		A26,	*B7
		stw		A17,	*B8

		bnop	.S2	B3,	5

