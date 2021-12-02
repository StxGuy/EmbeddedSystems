;-------------------------------------;
; INDIRECT ADDRESSING FOR ATMEL328    ;
; DISPLACEMENT                        ;
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
    ldi R28, low(A)
    ldi R29, high(A)
        
    std Y+4, R16
    std Y+6, R16
    ldd R17, Y+4
    
LOOP:
  jmp LOOP


          
