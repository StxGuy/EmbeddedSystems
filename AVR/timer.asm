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
  sbi  DDRD,6         ; PD6/Arduino 6 is output
.endmacro

.macro config_counter
  ldi R16,0b00000101 ; Prescale = 1024x
  out TCCR0B,R16

  ldi R16,0b01000000 ; Normal mode, toggle OC0A
  out TCCR0A,R16

  lds R16,TIMSK0
  ori R16,0x01
  sts TIMSK0,R16     ; Interrupt on overflow

  clr R16
  sts OCR0A,R16

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

.org 0x0020   ; Timer0 overflow
rjmp HANDLER0

.org 0x0034   ; Code located
              ; after interrupt table

;-------------------------------------;
;                MAIN                 ;
;-------------------------------------;
INICIO:
    initstack
    config_pins
    config_counter


LOOP:
    nop
    rjmp     LOOP

;-------------------------------------;
;            TIMER HANDLER            ;
;-------------------------------------;
HANDLER0:
    sbic PIND,6
    rjmp CLR_LED
    sbi  PORTB,5
    reti
CLR_LED:
    cbi PORTB,5
    reti


    reti

