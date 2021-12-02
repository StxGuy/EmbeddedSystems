;-----------------------------------;
; DIRECT ADDRESSING FOR ATMEL328    ;
;                                   ;
; Por: Prof. Carlo Requiao          ;
; 16/Sepo/2020                      ;
;-----------------------------------;

.device ATmega328

    .org 0x00   ; Program starts at 0x00
    rjmp INICIO


INICIO:
    ldi R16, 0x04
    sts 0x0100, R16
    lds R17, 0x0100

LOOP:
  jmp LOOP


          
