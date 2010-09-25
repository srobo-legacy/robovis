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
	||	mvk	.S1	298,	A9
	||	mvk	.S2	-128,	B2

		mv		A8,	B7
	||	add		A6,	B2,	A6
	||	mvk		409,	A0
	||	mvk	.S2	208,	B1
	||	mpy32	.M1	A4,	A9,	A4

		mpy32	.M1	A6,	A0,	A9
	||	add		B4,	B2,	B4
	||	mvk	.S1	-4640,	A0
	||	mvk	.S2	100,	B0

		mpy32	.M2	B4,	B0,	B5
	||	mpy32	.M1X	A6,	B1,	A1
	||	mvk	.S1	516,	A2

		mpy32	.M1X	A2,	B4,	A2

		; We're now at a critical path bit that can't be further broken
		; down. Interlace with some constant loading for next section
		add	.L1	A4,	A0,	A4	; Depends on A4 mpy32...
		add	.L1	A4,	A9,	A9	; Depends on prev insn
	||	mvk		255,	A3
	||	mvk		255,	B3
		sub	.L1X	A4,	B5,	A17	; Depends on B5 mpy
	||	mvk		-1,	A6
	||	mvk		-1,	B4
		sub	.L1	A17,	A1,	A17	; Depends on prev insn
	||	add		A4,	A2,	A18
	||	mvk		0,	A4
	||	mvk		0,	B5

		mv		A17,		B16

		; Clip r value on A side, g on B side
		shr	.S1	A9,	8,	A5	; calc final value
		shr	.S2	B16,	8,	B17
	||	cmpgt	.L1	A9,	A6,	A0	; are we > -1?
	||	cmpgt	.L2	B16,	B1,	B0
		cmplt	.L1	A5,	A3,	A1	; if calc'd > 255,
	||	cmplt	.L2	B17,	B3,	B1

		; select from 255 or calcval
	[ A1]	mv		A5,	A19		; It's < 255, select
	||[!A1]	mv		A3,	A19		; >= 255, clip
	||[ B1]	mv		B17,	B9
	||[!B1]	mv		B3,	B9

	[!A0]	mv		A4,	A19		; If it was < 0, clip
	||[!B0]	mv		B5,	B9

		; Clip b value
		shr	.S1	A18,	8,	A5	; calc final value
	||	cmpgt	.L1	A18,	A6,	A0	; are we > -1?
		cmplt	.L1	A5,	A3,	A1	; if calc'd > 255,

	[ A1]	mv		A5,	A21		; It's < 255, select
	||[!A1]	mv		A3,	A21		; >= 255, clip

	[!A0]	mv		A4,	A21		; If it was < 0, clip

; epilog
		ldw		*-A15(4),	B3
		mv		A15,	B15
	||	ldw		*A15,	A15

		; Store rgb values back to output. If they're not word
		; aligned pointers, that's the callers problem.
		stw	.D2T1	A19,		*B6
		stw	.D2T2	B9,		*B7
		stw	.D2T1	A21,		*B8

		bnop	.S2	B3,	5

