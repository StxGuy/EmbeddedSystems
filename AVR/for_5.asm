	.device ATmega328

	.org 0x00		; Program starts at 0x00
	rjmp	INICIO

; Generate Fibonacci sequence

INICIO: nop
        ldi   R19,0x05
        clr   R16
        ldi   R17,0x01
        
LOOP:   mov   R18,R17
        add   R18,R16
        mov   R16,R17
        mov   R17,R18
        dec   R19
        breq  FIM
        rjmp  LOOP

FIM:    jmp   FIM  
