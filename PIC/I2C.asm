;------------------------------;
; I2C in PIC                   ;
;                              ;
; Output: SCL/SDA (PC3/4)      ;
;                              ;
; Por: Prof. Carlo Requiao     ;
; 14/Oct/2020                  ;
;------------------------------;

list p = 16f877a		; Specify processor
include <p16f877a.inc>		; Include mapping

	__CONFIG _CP_OFF & _CPD_OFF & _DEBUG_OFF & _LVP_OFF & _WRT_OFF & _BODEN_OFF & _PWRTE_ON & _WDT_OFF & _XT_OSC


        org 	0x00		; Program starts at 0x00
        goto 	RESET
        org	0x04

;================================================================================.
;                                   MAIN BODY                                    |
;================================================================================'
RESET:		call	CFG_I2C
		call	START

		banksel 0
		movlw	0x40		; Address
		movwf	0x20
		call	SEND
		call	CHECK
		
		banksel	0
		movlw	B'10101010'	; Data
		movwf	0x20
		call	SEND
		call	CHECK
		
		call	STOP

LOOP:		goto	LOOP
		
		
;================================================================================.
;                             CONFIGURATION ROUTINES	                         |
;================================================================================'

;---------- CONFIGURE I2C ----------
CFG_I2C:	banksel	(SSPCON)
		bsf	SSPCON,SSPEN	; Enable
		bsf	SSPCON,SSPM3	; Master mode
		bcf	SSPCON,SSPM2
		bcf	SSPCON,SSPM1
		bcf	SSPCON,SSPM0
		
		banksel	(SSPCON2)
		clrf	SSPCON2

		banksel	(SSPSTAT)
		clrf	SSPSTAT
		
		banksel (SSPADD)
		movlw	0x09		; BitRate = 100 kHz
		movwf	SSPADD

		banksel	(TRISC)
		bsf	TRISC,3		; PC<4,3> input as per datasheet
		bsf	TRISC,4
		
		return

;--------- START CONDITION ---------
START:		banksel	(SSPCON2)
		bsf	SSPCON2,SEN
		
		banksel	(SSPSTAT)
st_wait:	btfsc	SSPSTAT,R_W
		goto	st_wait

		return
		
;----------- SEND DATA -------------
SEND:		banksel	0
		movf	0x20,W
		banksel	(SSPBUF)
		movwf	SSPBUF

		banksel	(SSPSTAT)
sd_wait:	btfsc	SSPSTAT,R_W
		goto	sd_wait		
		
		return
		
;-------- CHECK ACKNOWLEDGE -------
CHECK:		banksel	(SSPCON2)
c_wait:		btfsc	SSPCON2,ACKSTAT
		goto	c_wait
		
		return
		
;--------- STOP CONDITION ---------
STOP:		banksel	(SSPCON2)
		bsf	SSPCON2,PEN
		
		banksel	(SSPSTAT)
to_wait:	btfsc	SSPSTAT,R_W
		goto	to_wait
		
		return		
		
        END
        
        
        
