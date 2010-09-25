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

		; save output pointers, load constants for comparisons
		mvk		-1,	A6
	||	mv		A5,	B0
		mvk		0,	A4
	||	mv		A8,	B1
		mvk		255,	A3
	||	mv		A3,	B2


		shr	.S1	A9,	8,	A5	; calc final value
		cmplt	.L1	A5,	A3,	A1	; if calc'd > 255,

		; select from 255 or calcval
	[ A1]	mv		A5,	A19		; It's < 255, select
	[!A1]	mv		A3,	A19		; >= 255, clip

		; And if it was < 0, clip to 0. A16 contains previous comarison
		mv		A16,	A0
	[!A0]	mv		A4,	A19
.BB1_3:


		cmpgt	.L1	A17,	A6,	A0

		shr	.S1	A17,	8,	A5	; calc final value
		cmplt	.L1	A5,	A3,	A1	; if calc'd > 255,

		; select from 255 or calcval
	[ A1]	mv		A5,	A20		; It's < 255, select
	[!A1]	mv		A3,	A20		; >= 255, clip

		; And if it was < 0, clip to 0
	[!A0]	mv		A4,	A20


		cmpgt	.L1	A18,	A6,	A0

		shr	.S1	A18,	8,	A5	; calc final value
		cmplt	.L1	A5,	A3,	A1	; if calc'd > 255,

		; select from 255 or calcval
	[ A1]	mv		A5,	A21		; It's < 255, select
	[!A1]	mv		A3,	A21		; >= 255, clip

		; And if it was < 0, clip to 0
	[!A0]	mv		A4,	A21

; epilog
		ldw		*-A15(4),	B3
		mv		A15,	B15
	||	ldw		*A15,	A15

		; Store rgb values back to output. If they're not word
		; aligned pointers, that's the callers problem.
		stw	.D2T1	A19,		*B0
		stw	.D2T1	A20,		*B1
		stw	.D2T1	A21,		*B2

		bnop	.S2	B3,	5

