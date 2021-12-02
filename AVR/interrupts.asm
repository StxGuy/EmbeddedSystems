;-------------------------------------;
; GPIO INTERRUPT FOR ATMEL328p        ;
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

.macro config_pins
  in   R16,MCUCR
  ori  R16,(1<<PUD)
  out  MCUCR,R16      ; Disable pull-up
  sbi  DDRB,5         ; on-board LED is output
  cbi  DDRD,2         ; INT0/PD2/Arduino-2 is input
.endmacro

.macro config_int
  lds  R16,EICRA
  ori  R16,(1<<ISC00)
  ori  R16,(1<<ISC01)
  sts  EICRA,R16      ; Rising edge PD2
  in   R16,EIMSK
  ori  R16,(1<<INT0)
  out  EIMSK,R16      ; Enable INT0
  sei                 ; Enable all interrupts
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
.org 0x0000   ; RESET
rjmp INICIO

.org 0x0002   ; INT0
rjmp HANDLER0

.org 0x0034   ; Code located
              ; after interrupt table

;-------------------------------------;
;                MAIN                 ;
;-------------------------------------;
INICIO:
    initstack
    config_pins
    config_int

LOOP:
    nop
    rjmp     LOOP

;-------------------------------------;
;            INT0 HANDLER             ;
;-------------------------------------;
HANDLER0:
    sbic     PINB,5
    rjmp     CLR_LED
    sbi      PORTB,5
    reti
CLR_LED:
    cbi      PORTB,5
    reti

