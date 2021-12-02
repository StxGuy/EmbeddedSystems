;------------------------------;
; Digital Interrupts FOR PIC   ;
;                              ;
; Por: Prof. Carlo Requiao     ;
; 16/Sep/2020                  ;
;------------------------------;

list p = 16f877a		; Specify processor
include <p16f877a.inc>		; Include mapping

	__CONFIG _CP_OFF & _CPD_OFF & _DEBUG_OFF & _LVP_OFF & _WRT_OFF & _BODEN_OFF & _PWRTE_ON & _WDT_OFF & _XT_OSC


TMP	equ	0x20


        org 	0x000		; Program starts at 0x00
        goto 	RESET
        org 	0x004
        goto 	IVEC

;================================================================================.
;                                   MAIN BODY                                    |
;================================================================================'
RESET:		banksel	0
		call 	CFG_PINS
		call	CFG_INT

ETERNAL_LOOP:	nop
		goto	ETERNAL_LOOP


;================================================================================.
;                             CONFIGURATION ROUTINES	                         |
;================================================================================'	
CFG_INT:	banksel	(OPTION_REG)
		bcf	OPTION_REG,T0CS		; Internal clock
		bcf	OPTION_REG,T0SE		; Rising edge
		bsf	OPTION_REG,PSA		; Prescaler
		
		bsf	OPTION_REG,PS2		; Prescaler k=8
		bsf	OPTION_REG,PS1
		bsf	OPTION_REG,PS0
		
		bsf	INTCON,TMR0IE		; Enables overflow interrupt
		
		banksel	(TMR0)
		clrf	TMR0			; Count from 0 up
		
		bsf	INTCON,GIE		; Enables all interrupts
		
		return
		
CFG_PINS:	banksel	(TRISD)		; PORTD is all output
		clrf	TRISD
		banksel	(PORTD)
		clrf	PORTD		; Clear PORTD
		return

;================================================================================.
;                             INTERRUPT ROUTINES	                         |
;================================================================================'
IVEC:		banksel	(TMR0)
		clrf	TMR0		; Count from 0 up
		bcf	INTCON,TMR0IF	; Clear signaling flag
		comf	TMP,W
		movwf	TMP
		movwf	PORTD		; Toggle LEDs
		retfie

		
        END
