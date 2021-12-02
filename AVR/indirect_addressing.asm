;-------------------------------------;
; INDIRECT ADDRESSING FOR ATMEL328    ;
; ACCESS VECTOR                       ;
;                                     ;
; Por: Prof. Carlo Requiao            ;
; 16/Sep/2020                         ;
;-------------------------------------;

.device ATmega328

.dseg
    array: .byte 0x08
    
.cseg    
.org 0x00   ; Program starts at 0x00

rjmp INICIO


INICIO:
    ldi     R18, 0x04
    ldi     R26, low(array)
    ldi     R27, high(array)
    clr     R19
    
FILL:    
    st      X+,R19
    inc     R19
    dec     R18
    brne    FILL
    
; Access an element:
; array pointed by X, index given by R18, result in R1
    ldi     R26, low(array)
    ldi     R27, high(array)
    ldi     R18, 0x02
    add     R26, R18
    ld      R1, X
    
LOOP:
    jmp     LOOP
        
   

          
