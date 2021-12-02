;------------------------------;
; NAIVE MULTIPLICATION FOR PIC ;
;                              ;
; Por: Prof. Carlo Requiao     ;
; 12/Ago/2020                  ;
;------------------------------;

list p = 16f877a		; Specify processor
include <p16f877a.inc>		; Include mapping

        org 0x00		; Program starts at 0x00
        goto INICIO

cnt	equ	0x20
base	equ	0x21
dest	equ	0x22

INICIO: banksel	0x00		; Select Bank #0
	movlw	0x05		; cnt = 5
	movwf	cnt
	movlw	0x03		; base = 3
	movwf	base
	clrf	dest		; dest = 0
	
LOOP:	movf	base,0		; dest += base
	addwf	dest,1
	decfsz	cnt
	goto	LOOP
		
        END
