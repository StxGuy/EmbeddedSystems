;-------------------------------------;
; STACK FOR ATMEL328                  ;
;                                     ;
; Por: Prof. Carlo Requiao            ;
; 22/Sep/2020                         ;
;-------------------------------------;

.device ATmega328

;-------------------------------------;
;               MACROS                ;
;-------------------------------------;
.macro initstack
	ldi	R16,low(RAMEND)
	out	spl,R16
	ldi	R16,high(RAMEND)
	out	sph,R16
.endmacro

;-------------------------------------;
;             DEFINITIONS             ;
;-------------------------------------;
.def geral1=R18
.def geral2=R19	

;-------------------------------------;
;          MEMORY SEGMENTS            ;
;-------------------------------------;
.dseg
    array: .byte 10

.cseg    
.org 0x00   ; Program starts at 0x00

rjmp INICIO

;-------------------------------------;
;                CODE                 ;
;-------------------------------------;
INICIO:
    initstack

    ldi      XL,low(array)
    ldi      XH,high(array)
    ldi      ZL,low(vector<<1)
    ldi      ZH,high(vector<<1)
    ldi      R16,6

FILL:
    lpm      R1,Z+
    st       X+,R1
    dec      R16
    brne     fill

SWEEP:
    ldi      R17,1
    ldi      R16,5
    ldi      XL,low(array)
    ldi      XH,high(array)
S2:
    ld       R1,X+
    ld       R2,X
    cp       R1,R2
    brlo     S1
    call     PERMUTA
S1:
    dec      R16
    brne     S2

    dec      R17
    brne     SWEEP
    rjmp     FIM

PERMUTA:
    dec      XL
    st       X+,R2
    st       X,R1
    inc      R17
    ret

FIM:
    jmp      FIM



vector: .db 5,3,2,1,4,0


          
