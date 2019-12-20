

init_text ldx #$00
loop_text  
        lda line1,x      ; read characters from line1 table of text...
        sta $0590,x      ; ...and store in screen ram near the center row
        lda line2,x      ; read characters from line1 table of text...
        sta $05e0,x      ; ...and put 2 rows below line1
        inx              ; increment x, which increments both the next char in string and position on screen
        cpx #$28         ; finished when all 40 cols of a line are processed -- compare x to value of 40
        bne loop_text    ; the branch command bne will jump back to our label loop_text if the comparison is not true. 
        rts


init_secondary_text ldy #$00
loop_secondary_text  
        lda line3,y      ; read characters from line1 table of text...
        sta $0630,y      ; ...and store in screen ram near the center row
        iny              ; increment x, which increments both the next char in string and position on screen
        cpy #$28         ; finished when all 40 cols of a line are processed -- compare x to value of 40
        bne loop_secondary_text    ; the branch command bne will jump back to our label loop_text if the comparison is not true. 
        rts
        