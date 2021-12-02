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
  cbi  DDRC,0         ; PC0/Arduino-A0 is input
.endmacro

.macro config_ADC
  lds  R16,PRR        ; Power ADC
  andi R16,0b11111110
  sts  PRR,R16

  lds  R16,ADCSRA
  ori  R16,0b10101011 ; Enable, auto-trigger, CK/8
  sts  ADCSRA,R16

  lds  R16,ADCSRB
  andi R16,0b01000000 ; Free-running
  sts  ADCSRB,R16

  ldi  R16,0b01000000 ; AVcc, right adjusted, ADC0/PC0/A0
  sts  ADMUX,R16

  sei                 ; Enable interrupt
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

.org 0x002A   ; ADC
rjmp HANDLER0

.org 0x0034   ; Code located
              ; after interrupt table

;-------------------------------------;
;                MAIN                 ;
;-------------------------------------;
INICIO:
    initstack
    config_pins
    config_ADC

    ; Begin conversion
    lds       R16,ADCSRA
    ori       R16,0b01000000
    sts       ADCSRA,R16

LOOP:
    nop
    rjmp     LOOP

;-------------------------------------;
;            INT0 HANDLER             ;
;-------------------------------------;
HANDLER0:
    reti

