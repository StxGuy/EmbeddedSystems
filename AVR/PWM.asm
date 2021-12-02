;-------------------------------------;
; PWM FOR ATMEGAL328p                 ;
;                                     ;
; Por: Prof. Carlo Requiao            ;
; 10/Nov/2021                         ;
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
  ldi R16,(1<<WGM13)|(1<<WGM12)|(1<<CS12)
  sts TCCR1B,R16

  ldi R16,(1<<COM1A1)|(1<<WGM11)|(1<<COM1A0)
  sts TCCR1A,R16

  ldi R16,0x04
  sts ICR1H,R16
  ldi R16,0xE2
  sts ICR1L,R16

  ldi R16,0x7D
  sts OCR1AL,R16
.endmacro

;-------------------------------------;
;          MEMORY SEGMENTS            ;
;-------------------------------------;
.dseg

.cseg
.org 0x0000   ; RESET
rjmp INICIO

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




