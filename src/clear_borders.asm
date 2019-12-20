clear_borders
  lda #$00       ; clear potential garbage in $3fff
  sta $3fff
  
  lda #$f9       ; wait until Raster Line 249
  cmp $d012
  bne *-3

  lda $d011      ; Trick the VIC and open the border
  and #$f7
  sta $d011

  lda #$ff       ; Wait until Raster Line 255
  cmp $d012
  bne *-3

  lda $d011      ; Reset bit 3 for the next frame
  ora #$08
  sta $d011

  rts