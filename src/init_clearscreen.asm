init_screen     ldx #$00        ; set X to zero (black color code)
                stx $d021        ; set background color
                stx $d020        ; set border color

clear           lda #$20         ; #$20 is the spacebar Screen Code
                sta $0400,x      ; fill four areas with 256 spacebar characters
                sta $0500,x
                sta $0600,x
                sta $06e8,x
                lda #$01         ; set foreground in Color RAM
                sta $d800,x
                sta $d900,x
                sta $da00,x
                sta $dae8,x
                inx              
                bne clear        ; branch if x not equal to 0
                rts
