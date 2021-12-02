;-------------------------------------;
; GPIO POOLING FOR ATMEL328p          ;
;                                     ;
; Por: Prof. Carlo Requiao            ;
; 13/Oct/2021                         ;
;-------------------------------------;

.device ATmega328P

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

.cseg
.org 0x00   ; Program starts at 0x00

rjmp INICIO

;-------------------------------------;
;                CODE                 ;
;-------------------------------------;
INICIO:
    initstack

    in       R16,MCUCR
    ori      R16,(1<<PUD)
    out      MCUCR,R16          ; Disable pull-up
    sbi      DDRB,5             ; On-board LED is output
    cbi      DDRB,0             ; GPIO8 (PB0) is input

LOOP:
    sbi      PORTB,5            ; Turn LED on
L1:
    sbic     PINB,0             ; Skip if PB[0] == 0
    rjmp     L1

    cbi      PORTB,5            ; Turn LED off
L2:
    sbis     PINB,0             ; Skip if PB[0] == 1
    rjmp     L2
    rjmp     LOOP
