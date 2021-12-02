;------------------------------;
; Digital Interrupts FOR PIC   ;
;                              ;
; Por: Prof. Carlo Requiao     ;
; 16/Sep/2020                  ;
;------------------------------;

list p = 16f877a		; Specify processor
include <p16f877a.inc>		; Include mapping

	__CONFIG _CP_OFF & _CPD_OFF & _DEBUG_OFF & _LVP_OFF & _WRT_OFF & _BODEN_OFF & _PWRTE_ON & _WDT_OFF & _XT_OSC


SAVE_W	equ	0x20
SAVE_S	equ	0x21

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
CFG_INT:	banksel	(OPTION_REG)		; Otion register not on bank 1
		bcf	OPTION_REG,INTEDG	; Falling edge
		banksel	0
		
		bsf	INTCON,RBIE		; RB0/INT
		bsf	INTCON,INTE		; Change in RB<7:4>
		bsf	INTCON,GIE		; Interrupts are active
		return
		
CFG_PINS:	movlw	0xFF		; PORTB is all input
		banksel	(TRISB)		; TRIS in on Bank #1
		movwf	TRISB
		banksel (PORTB)		; Go back to Bank #0
		
		banksel	(TRISD)		; PORTD is all output
		clrf	TRISD
		banksel	(PORTD)
		clrf	PORTD		; Clear PORTD
		return

;================================================================================.
;                             INTERRUPT ROUTINES	                         |
;================================================================================'
IVEC:		btfsc	INTCON,INTF
		goto	UNIV
		btfsc	INTCON,RBIF
		goto	CHNG
		retfie
;--------------------------------- UNIVERSAL ----------------------------------
UNIV:		banksel	0
		movwf	SAVE_W		; Save W
		swapf	STATUS,W	; swapf does not affect status!
		movwf	SAVE_S		; Save STATUS
		
		banksel	0
		btfss	PORTD,4		; Switch D[4]
		goto	UNIV_S
		goto	UNIV_C
UNIV_C:		
		banksel	0
		bcf	PORTD,4
		goto	UNIV_NEXT
UNIV_S:		
		banksel 0
		bsf	PORTD,4
		goto 	UNIV_NEXT
UNIV_NEXT:	
		banksel 0
		swapf	SAVE_S,W	; Recover STATUS
		movwf	STATUS
		swapf	SAVE_W,F	; Recover W permutting nibbles
		swapf	SAVE_W,W
		bcf	INTCON,INTF	; Interrupt serviced
		retfie

;--------------------------------- CHANGE ------------------------------------
CHNG:		banksel	0
		movf	PORTB,W
		
		movwf	SAVE_W		; Save W
		swapf	STATUS,W	; swapf does not affect status!
		movwf	SAVE_S		; Save STATUS
	
		btfss	PORTD,1		; Switch D[1]
		goto	CHNG_S
		goto	CHNG_C
		
CHNG_C:		bcf	PORTD,1		
		goto	CHNG_NEXT
CHNG_S:		bsf	PORTD,1
		goto 	CHNG_NEXT

CHNG_NEXT:	
		swapf	SAVE_S,W	; Recover STATUS
		movwf	STATUS	
		swapf	SAVE_W,F	; Recover W permutting nibbles
		swapf	SAVE_W,W
		bcf	INTCON,RBIF	; Interrupt serviced
		retfie

		
        END
