	.device ATmega328

	.org 0x00		; Program starts at 0x00
	rjmp	INICIO

; Check if even or odd


INICIO: nop
        ldi   R16,0x05
        ror   R16

        brcs  IMPAR
        rjmp  PAR
LOOP:   jmp   LOOP

IMPAR:  nop
        rjmp  LOOP

PAR:    nop
        rjmp  LOOP   
