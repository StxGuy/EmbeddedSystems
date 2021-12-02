;-------------------------------------;
; INDIRECT ADDRESSING FOR ATMEL328    ;
; PRE-DECREMENT                       ;
;                                     ;
; Por: Prof. Carlo Requiao            ;
; 16/Sep/2020                         ;
;-------------------------------------;

.device ATmega328

.dseg
    A: .byte 0x01
    
.cseg    
.org 0x00   ; Program starts at 0x00

rjmp INICIO


INICIO:
    ldi R16, 0x04
    ldi R26, low(A)
    ldi R27, high(A)
        
    st  X, R16
    inc R26
    ld  R17, -X

LOOP:
  jmp LOOP


          
