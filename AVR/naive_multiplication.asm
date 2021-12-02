  .device ATmega328

  .org 0x00		; Program starts at 0x00
  rjmp	INICIO

; Naive multiplication

INICIO: nop
        ldi           R16,0x1F ; Palavra a ser testada
        ldi           R17,0x05 ; 5d = 101b sequencia
        ldi           R20,0x05 ; contador

LOOP:   mov           R18,R16
        andi          R18,0x07 ; 7h = 111b
        cp            R18,R17
        breq          IGUAIS
        ror           R16
        dec           R20
        brne          LOOP
FIM:    jmp           FIM

IGUAIS: ldi           R21,0x01
        rjmp          FIM


