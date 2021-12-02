  .device ATmega328

  .org 0x00		; Program starts at 0x00
  rjmp	INICIO

; Detect if a specific sequence is present in a byte

INICIO: nop
        ldi        R16,0xDB  ; Byte to be checked
        ldi        R17,0x05  ; Sequence
        ldi        R19,0x05

LOOP:   mov        R18,R16
        andi       R18,0x07
        cpse       R18,R17
        rjmp       NEXT
        rjmp       SIM

NEXT:   lsr        R16
        dec        R19
        breq       FIM
        rjmp       LOOP

SIM:    ldi        R20,0x01
        rjmp       FIM

FIM:    jmp        FIM

                            
