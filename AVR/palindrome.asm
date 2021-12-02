  .device ATmega328

  .org 0x00		; Program starts at 0x00
  rjmp	INICIO

; Check if palindrome

INICIO: nop
        ldi   R19,0x08
        ldi   R16,0xDB
        mov   R17,R16
        
LOOP:   ror   R17
        rol   R18
        dec   R19
        breq  NEXT
        rjmp  LOOP

NEXT:   cpse  R16,R18
        jmp   FIM
        rjmp  PAL

FIM:    jmp   FIM

PAL:    ldi   R20,0x01
        rjmp  FIM      
