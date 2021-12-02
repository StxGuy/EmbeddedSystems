	.device ATmega328

	.org 0x00		; Program starts at 0x00
	rjmp	INICIO

; Negative fixed point?

INICIO: nop
        ldi   R16,0xA5
        andi  R16,0x80
        breq  POS
        rjmp  NEG
LOOP:   rjmp  LOOP

POS:    nop
        rjmp  LOOP

NEG:    nop
        rjmp  LOOP       
