;------------------------------;
; PWM in PIC                   ;
;                              ;
; Control: RB0                 ;
; Output: RC1(CCP2) PWM        ;
;         RC3 - Flag           ;
;                              ;
; Por: Prof. Carlo Requiao     ;
; 30/Sep/2020                  ;
;------------------------------;

list p = 16f877a		; Specify processor
include <p16f877a.inc>		; Include mapping

	__CONFIG _CP_OFF & _CPD_OFF & _DEBUG_OFF & _LVP_OFF & _WRT_OFF & _BODEN_OFF & _PWRTE_ON & _WDT_OFF & _XT_OSC


TMP	equ	0x20

        org 	0x00		; Program starts at 0x00
        goto 	RESET
        
        org	0x04
        goto	Button


;================================================================================.
;                                   MAIN BODY                                    |
;================================================================================'
RESET:		call	CFG_PWM
		call	CFG_Input
		call	CFG_Int
		
Eternal_Loop:	nop
		goto	Eternal_Loop
		
;====================================================.
;              Interrupt Vector			     |
;===================================================='
Button:		btfss	INTCON,INTF
		goto	Next
		banksel	(CCPR2L)
		decf	CCPR2L,F
		bcf	INTCON,INTF
		banksel	(PORTC)
		btfss	PORTC,3
		goto	Liga
		bcf	PORTC,3
		goto 	Next

Liga:		banksel	(PORTC)
		bsf	PORTC,3
		
Next:		retfie		
		
;====================================================.
;              Configure Interrupt		     |
;===================================================='
CFG_Int:	banksel	(OPTION_REG)
		bcf	OPTION_REG,INTEDG
		banksel	(INTCON)
		bsf	INTCON,RBIE
		bsf	INTCON,GIE
		return		

;====================================================.
;              Configure Input Pins		     |
;===================================================='
CFG_Input:	banksel	(TRISB)		; PORTB is all input
		movlw	0xFF
		movwf	TRISB
		return		

;====================================================.
;                  Configure PWM		     |
;===================================================='	
CFG_PWM:	;------------------------------------------------------.
		; Set Period T = (PR2+1).4.Tosc.(TMR2 Prescale Value)  |
		;------------------------------------------------------'
		banksel	(PR2)
		movlw	0x3F
		movwf	PR2
		banksel	(T2CON)
		bcf	T2CON,T2CKPS1
		bcf	T2CON,T2CKPS0
		
		;------------------------------------------------------------------.
		; Set Duty Cycle D = CCPRxL:CPxCON<5:4>.Tosc.(TMR2 Prescale Value) |
		;------------------------------------------------------------------'
		banksel	(CCPR2L)
		movlw	0x2F
		movwf	CCPR2L
		banksel	(CCP2CON)
		bcf	CCP2CON,5
		bcf	CCP2CON,4
		
		;--------------------.
		; Set CCP2 as output |
		;--------------------'
		banksel	(TRISC)
		clrf	TRISC
		banksel	(PORTC)
		clrf	PORTC
		
		;-------------.
		; Enable TMR2 |
		;-------------'
		banksel	(T2CON)
		bsf	T2CON,TMR2ON
		
		;-------------------------.
		; Configure PWM operation |
		;-------------------------'
		banksel	(CCP2CON)
		bsf	CCP2CON,CCP2M3
		bsf	CCP2CON,CCP2M2
		
		return
				
		
        END
