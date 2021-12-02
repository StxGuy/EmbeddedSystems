;-----------------------------------;
; DIRECT ADDRESSING FOR ATMEL328    ;
;                                   ;
; Por: Prof. Carlo Requiao          ;
; 16/Sepo/2020                      ;
;-----------------------------------;

.device ATmega328

.dseg
    B: .byte 0x04
    A: .byte 0x02

.cseg    
.org 0x00   ; Program starts at 0x00

rjmp INICIO


INICIO:
    ldi R16, 0x04
    sts A, R16
    lds R17, A

LOOP:
  jmp LOOP


          
