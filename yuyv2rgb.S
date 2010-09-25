	.file	"yuyv2rgb.c"

; NB, my count of cycles in rev c0a539175c3eb4575d55320edaa41ef535dec0b7 is
; 183 plus 3 paths that lead to 5 extra cycles. My count for rev
; a85b8ad1c87697f7b1ee56a91e75848d418d99c4 says this is now 21 cycles ever time.

	.text
	.globl	yuyv2rgb
	.align	5
	.type	yuyv2rgb,@function
yuyv2rgb:
		mvk	.S1	298,	A9
	||	mvk	.S2	-128,	B2

		mv		A8,	B7
	||	add		A6,	B2,	A6
	||	add		B4,	B2,	B4
	||	mvk		409,	A0
	||	mvk	.S2	100,	B0
	||	mpy32	.M1	A4,	A9,	A4

		mpy32	.M1	A6,	A0,	A9
	||	mpy32	.M2	B4,	B0,	B5
	||	mvk	.S1	-4640,	A0
	||	mvk	.S2	208,	B1

		mpy32	.M1X	A6,	B1,	A1
	||	mvk	.S1	516,	A2

		mpy32	.M1X	A2,	B4,	A2

		; We're now at a critical path bit that can't be further broken
		; down. Interlace with some constant loading for next section
		add		A4,	A0,	A4	; Depends on A4 mpy32...

		add		A4,	A9,	A9	; Depends on prev insn
	||	sub		A4,	B5,	A17	; Depends on B5 mpy
	||	mvk		255,	A3
	||	mvk		255,	B2

		sub		A17,	A1,	A17
	||	mvk		0,	A6
	||	mvk		0,	B4

		add		A4,	A2,	A18
		; Clip r value on A side, g on B side, b on A
	||	shr	.S1	A9,	8,	A5	; calc final value
	||	b	.S2	B3			; EPILOG: return
		; Have to have precisely 5 insns following the return branch,
		; or otherwise insert some nops

		shr	.S2X	A17,	8,	B17
	||	shr	.S1	A18,	8,	A4
	||	max2		A6,	A5,	A19

		max2		B4,	B17,	B9
	||	max2		A6,	A4,	A21
	||	min2		A19,	A3,	A19

		min2		B9,	B2,	B9
	||	min2		A3,	A21,	A21
	||	mvkh		0		A19

		mvkh		0,		A21
	||	mvkh		0,		B9
	||	stw	.D2T1	A19,		*B6
	||	mv		B7,		A0
		; Store rgb values back to output. If they're not word
		; aligned pointers, that's the callers problem.
		stw	.D2T1	A21,		*B8
	||	stw	.D1T2	B9,		*A0

