   ;-------------------------------------;
; GPIO INTERRUPT FOR ATMEL328p        ;
;                                     ;
; Por: Prof. Carlo Requiao            ;
; 03/Nov/2021                         ;
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
  sbi  DDRB,1         ; PB1/Arduino 9 is output
.endmacro

.macro config_counter
  ldi R16,(1<<WGM12)|(1<<CS12)
  sts TCCR1B,R16

  ldi R16,(1<<COM1A0)         ; Toggle OC1A
  sts TCCR1A,R16

  clr R16
  sts TCCR1C,R16

  ldi R16,(1<<OCIE1A)
  sts TIMSK1,R16     ; Match A interrupt enable

  ldi R16,0x7A       ; OCR = 31249 -> 1s : 0x7A11
  sts OCR1AH,R16
  ldi R16,0x11
  sts OCR1AL,R16

  sei                 ; Enable interrupt
.endmacro

;-------------------------------------;
;          MEMORY SEGMENTS            ;
;-------------------------------------;
.dseg

.cseg
.org 0x0000   ; RESET
rjmp INICIO

.org 0x0016   ; Timer1 compare match A
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
    sbic PINB,1
    rjmp CLR_LED
    sbi  PORTB,5
    reti
CLR_LED:
    cbi PORTB,5
    reti


    reti

