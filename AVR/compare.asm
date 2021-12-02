;-----------------------------;
; CONDITIONAL FOR ATMEL328    ;
;                             ;
; Por: Prof. Carlo Requiao    ;
; 20/Ago/2020                 ;
;-----------------------------;

.device ATmega328

.dseg

.cseg


.org 0x00   ; Program starts at 0x00

rjmp INICIO


INICIO:
    ldi     R18, 0x05           ; Size of array
    clr     R19                 ; biggest element
    ldi     ZL, low(array<<1)
    ldi     ZH, high(array<<1)

TRY:
    lpm     R1, Z+
    cp      R1,R19
    brlo    SKIP
    mov     R19,R1
SKIP:
    dec     R18
    brne    TRY


LOOP:
    jmp     LOOP


array: .db 0,3,2,4,1,0
