;------------------------------;
; Digital I/O FOR PIC          ;
;                              ;
; Por: Prof. Carlo Requiao     ;
; 09/Sep/2020                  ;
;------------------------------;

list p = 16f877a		; Specify processor
include <p16f877a.inc>		; Include mapping

	__CONFIG _CP_OFF & _CPD_OFF & _DEBUG_OFF & _LVP_OFF & _WRT_OFF & _BODEN_OFF & _PWRTE_ON & _WDT_OFF & _XT_OSC

        org 0x00		; Program starts at 0x00
        goto INICIO

CNT1	equ	0x20
CNT2	equ	0x21

				; Configure I/O
INICIO: banksel	(TRISD)		; TRIS in on Bank #1
	movlw	0xFF		; PORTA is all input
	movwf	TRISD
	
	banksel (TRISB)		; Go back to Bank #0
	movlw	0x00
	clrf	TRISB		; PORTB is all output
	
	banksel	(PORTB)
	clrf	PORTB		; Clear PORTB

ACK:	call 	CYCLE2		; Wait for data
	banksel	(PORTB)
	bsf	PORTB,4		; Acknowledge turning some LEDs on
	bsf	PORTB,2		
	bsf	PORTB,0
	call	CYCLE1		; Wait until it is over
	banksel	(PORTB)
	clrf 	PORTB		; Acknowledge turning LEDs off
	goto	ACK
	
CYCLE1:	banksel	(PORTD)
Loop1:	btfss	PORTD,1		; Polling on PORTA[3]
	goto	Loop1
	return

CYCLE2:	banksel	(PORTD)
Loop2:	btfsc	PORTD,1		; Polling on PORTA[3]
	goto	Loop2
	return
		
        END
