;-------------------------------------;
; INDIRECT ADDRESSING FOR ATMEL328    ;
; FIND MAXIMUM OF ARRAY               ;
;                                     ;
; Por: Prof. Carlo Requiao            ;
; 16/Sep/2020                         ;
;-------------------------------------;

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
        
   
array: .db 1,3,2,5,4,0
          
