showpicture
	lda $4710 ; load and set background
	sta $d020
	sta $d021

	ldx #$00 ; rest x-register

loaddccimage
	lda $3f40,x ; copy char data from image
	sta $0400,x ; to screen
	lda $4040,x
	sta $0500,x
	lda $4140,x
	sta $0600,x
	lda $4240,x
	sta $0700,x

	lda $4328,x ; copy color data from image
	sta $d800,x ; to screen
	lda $4428,x
	sta $d900,x
	lda $4528,x
	sta $da00,x
	lda $4628,x
	sta $db00,x

	inx
	bne loaddccimage

	lda #$3b
	sta $d011
	lda #$18
	sta $d016
	lda #$18
	sta $d018

	loop
	jmp loop

	rts
