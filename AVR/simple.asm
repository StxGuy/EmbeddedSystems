  .device ATmega328

  .org 0x00		; Program starts at 0x00
  rjmp	INICIO


INICIO: nop
        ldi   R17,d'23'
        ldi   R18,0x03
        clr   R19
LOOP:   add   R19,R18
        dec   R17
        brne  LOOP
FIM:    jmp   FIM
