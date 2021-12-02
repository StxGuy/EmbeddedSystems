  .device ATmega328

  .org 0x00		; Program starts at 0x00
  rjmp	INICIO

; Valor absoluto

INICIO: nop
        ldi   R16,0xAE          ; ls nibble 1
        sbrc  R16,7
        rjmp  COMPL
FIM:    jmp   FIM

COMPL:  com   R16               ; or substitute both
        inc   R16               ; for neg R16
        rjmp  FIM



                 
