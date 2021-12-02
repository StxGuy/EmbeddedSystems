;------------------------------;
; ADC in PIC                   ;
;                              ;
; Control: RA0 (AN0)           ;
; Output: RC                   ;
;                              ;
; Por: Prof. Carlo Requiao     ;
; 07/Oct/2020                  ;
;------------------------------;

list p = 16f877a		; Specify processor
include <p16f877a.inc>		; Include mapping

	__CONFIG _CP_OFF & _CPD_OFF & _DEBUG_OFF & _LVP_OFF & _WRT_OFF & _BODEN_OFF & _PWRTE_ON & _WDT_OFF & _XT_OSC


TMP	equ	0x20

        org 	0x00		; Program starts at 0x00
        goto 	RESET

;================================================================================.
;                                   MAIN BODY                                    |
;================================================================================'
RESET:		call	CFG_Pins
		call	CFG_ADC

		
WAIT:		banksel	(ADCON0)
		btfsc	ADCON0,GO
		goto	WAIT
		
		banksel	(ADRESL)
		movf	ADRESL,W
		banksel	(PORTC)
		movwf	PORTC
		banksel	(ADRESH)
		movf	ADRESH,W
		
		banksel	(ADCON0)
		bsf	ADCON0,GO
		goto	WAIT
		
;====================================================.
;                Configuration         		     |
;===================================================='
CFG_ADC:	banksel	(ADCON0)
		movlw	B'10000101'	; Prescale 1:32, channel 0, AD ON
		movwf	ADCON0
		banksel	(ADCON1)
		movlw	B'10000000'	; Right justified, all analog
		movwf	ADCON1
		return

CFG_Pins:	banksel	(TRISA)
		movlw	0xFF
		movwf	TRISA
		clrf	TRISC
		banksel	(PORTC)
		clrf	PORTC
		return				
		
        END
