  .device ATmega328

  .org 0x00		; Program starts at 0x00
  rjmp	INICIO

; Naive multiplication

INICIO: nop
        ldi R16,low(RAMEND)
        out spl,R16
        ldi R16,high(RAMEND)
        out sph,R16

        ldi	R16,0x08
        ldi	R17,0x02
        rcall MULT
LOOP:   jmp  LOOP

MULT:   mov  R18,R16
MLOOP:  add  R18,R16
        dec  R17
        brne MLOOP
        ret         
