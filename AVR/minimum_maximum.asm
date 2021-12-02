	.device ATmega328

 	.org 0x00		; Program starts at 0x00
 	rjmp	INICIO

; Find the bigger and smaller

INICIO: nop
        ldi   R16,0xA5
        ldi   R17,0x3E
        cp    R16,R17
        brlt  B16
        rjmp  B17
LOOP:   jmp   LOOP

B16:    ldi   R16,0x01  ; R16 < R17
        rjmp  LOOP

B17:    ldi   R17,0x01  ; R16 >= R17
        rjmp  LOOP 
