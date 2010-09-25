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

		mvk	.S1	516,	A0
		mpy32	.M1	A7,	A0,	A0
		nop	.S1	3
		add	.L1	A4,	A0,	A18

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

		; A16 -> is this > 0?
		mv		A16,	A0
		shr	.S1	A9,	8,	A4	; calc final value
		mvk	.S1	255,	A5
		cmplt	.L1	A4,	A5,	A2	; if calc'd > 255,
		mvk	.S1	0,	A1

		; select from 255 or calcval
	[ A2]	mv		A4,	A5		; It's < 255, select
	[!A2]	mv		A5,	A5		; >= 255, clip

		; And if it was < 0, clip to 0
	[!A0]	mv		A1,	A5
		; save
		stw		A5,	*-A15(8)
.BB1_3:


		mvk	.S1	-1,	A4
		cmpgt	.L1	A17,	A4,	A4

		shr	.S1	A17,	8,	A3	; calc final value
		mvk	.S1	255,	A5
		cmplt	.L1	A3,	A5,	A2	; if calc'd > 255,
		mvk	.S1	0,	A1

		; select from 255 or calcval
	[ A2]	mv		A3,	A6		; It's < 255, select
	[!A2]	mv		A5,	A6		; >= 255, clip

		; And if it was < 0, clip to 0
		mv 		A4,	A0
	[!A0]	mv		A1,	A6
		; save
		stw		A6,	*-A15(12)


		mvk	.S1	-1,	A4
		cmpgt	.L1	A18,	A4,	A4

		shr	.S1	A18,	8,	A3	; calc final value
		mvk	.S1	255,	A5
		cmplt	.L1	A3,	A5,	A2	; if calc'd > 255,
		mvk	.S1	0,	A1

		; select from 255 or calcval
	[ A2]	mv		A3,	A6		; It's < 255, select
	[!A2]	mv		A5,	A6		; >= 255, clip

		; And if it was < 0, clip to 0
		mv 		A4,	A0
	[!A0]	mv		A1,	A6
		; save
		mv		A6,	A0


		ldw		*-A15(32),	A1
		ldw		*-A15(8),	A2
		nop		4
		stw		A2,	*A1


		ldw		*-A15(28),	A1
		ldw		*-A15(12),	A2
		nop	.S1	4
		stw		A2,	*A1


		ldw		*-A15(24),	A1
		nop	.S1	4
		stw		A0,	*A1


; epilog
		ldw		*-A15(4),	B3
		mv		A15,	B15
	||	ldw		*A15,	A15
		nop		4

		bnop	.S2	B3,	5

