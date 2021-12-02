;-------------------------------------;
; GPIO FOR ATMEL328p                  ;
;                                     ;
; Por: Prof. Carlo Requiao            ;
; 13/Octp/2021                        ;
;-------------------------------------;

.device ATmega328p

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

LOOP:
    sbi      PORTB,5            ; Turn LED on
    call     delay              ; Wait
    cbi      PORTB,5            ; Turn LED off
    call     delay
    jmp      LOOP

;-------------------------------------;
;              FUNCTIONS              ;
;-------------------------------------;
DELAY:
    ldi     R16,0x80
DELAY3:
    ldi     R17,0xFF
DELAY2:
    ldi     R18,0xFF
DELAY1:
    nop
    dec     R18
    brne    DELAY1
    nop
    dec     R17
    brne    DELAY2
    nop
    dec     R16
    brne    DELAY3

    ret
