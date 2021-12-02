  .device ATmega328

  .org 0x00		; Program starts at 0x00
  rjmp	INICIO

; Multiply or divide by 2^n

INICIO: nop
        ldi   R16,0x08
        ldi   R17,0x02
LOOP:   lsr   R16       ; or lsl to multiply
        dec   R17
        breq  FIM
        rjmp  LOOP

FIM:    jmp   FIM
                      
