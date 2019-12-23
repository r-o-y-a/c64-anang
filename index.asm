        !cpu 6502
        !to "build/bp.prg",cbm                  ; output file

        !source "src/constants.asm"
        !source "src/load_res.asm"
        !source "src/init_clearscreen.asm"
        !source "src/text_routines.asm"
        !source "src/text.asm"
        !source "src/clear_borders.asm"
        !source "src/change_border.asm"

        * = $0801                                  ; BASIC start address (#2049)
        !byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000
        !byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152
        * = $c000     				; start address for 6502 code

        sei                                     ; set interupt disable flag 
                                                ; so nothing else interupts when we
                                                ; change $314 and then $315

        jsr init_screen                         ; clear the screen
        jsr sid_init                            ; init music routine now
        

        
        lda #$00 
        sta delay_counter

        ; turn off other sources of interupts
        ldy #$7f    ; $7f = %01111111
        sty $dc0d   ; Turn off CIAs Timer interrupts
        sty $dd0d   ; Turn off CIAs Timer interrupts
        lda $dc0d   ; cancel all CIA-IRQs in queue/unprocessed
        lda $dd0d   ; cancel all CIA-IRQs in queue/unprocessed

        lda #$01    ; In the address $D01A we set Bit 0 to let the VIC-II know that  
        sta $d01a   ; we want to request a notification from a raster beam event.

        lda $d011   ; Bit#7 of $d011 is basically...
        and #$7f    ; ...the 9th Bit for $d012
        sta $d011   ; we need to make sure it is set to zero

        lda #<irq   ; point IRQ Vector to our custom irq routine
        ldx #>irq
        sta $314    ; store in $314/$315
        stx $315

        lda #$00    ; init value: 00 - we define at what line number the interrupt should be triggered 
        sta $d012   ; (could use any line num here, just want a notification once per screen refresh)



        cli         ; clear interrupt disable flag
        jmp *       ; infinite loop


; custom interrupt routine -- whenever raster beam reaches line zero, this is executed
irq     dec $d019        ; acknowledge IRQ and notify again on the next screen refresh

   
loop1:  lda #$fb  ; wait for vertical retrace

loop2:  cmp $d012 ; until it reaches 251th raster line ($fb)
        bne loop2 ; which is out of the inner screen area

        inc delay_counter 
        lda delay_counter
        cmp #$32    ; check if counter reached 50
        bne out

        lda #$00    ; reset if equal
        sta delay_counter

        inc $d021
        inc $d020
        jsr showtext
        jsr randomchars

out:
        lda $d012
loop3:  cmp $d012
        beq loop3 
        
        jsr sid_play

        jmp loop1  

showtext
        jsr init_text  
        jsr init_secondary_text

randomchars
        
        ; generate random number from sid
        lda #$FF  ; maximum frequency value
        sta $D40E ; voice 3 frequency low byte
        sta $D40F ; voice 3 frequency high byte
        lda #$80  ; noise waveform, gate bit off
        sta $D412 ; voice 3 control register
        lda $D41B ; get random value from 0-255

        tay
        ldx #$53
        sta $0400, y
        rts


        jmp $ea31      ; return to Kernel routine




