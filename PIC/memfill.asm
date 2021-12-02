;------------------------------;
; MEMORY FILLING FOR PIC       ;
;                              ;
; Por: Prof. Carlo Requiao     ;
; 27/Ago/2020                  ;
;------------------------------;

list p = 16f877a		; Specify processor
include <p16f877a.inc>		; Include mapping

        org 0x00		; Program starts at 0x00
        goto INICIO

counter	equ	0x20

INICIO: banksel	0x00		; Select Bank #0
	
	movlw	0x05		; W = 5
	movwf	counter		; counter = 5
	movlw	0x20		; W = 0x20
	movwf	FSR		; FSR = 0x20

LOOP:	incf	FSR		; FSR++
	movf	counter,0	; W = counter
	movwf	INDF		; INDF = counter
	decfsz	counter,1	; counter--
	goto	LOOP
		
        END
