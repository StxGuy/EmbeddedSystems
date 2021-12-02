;-----------------------------;
; PARITY CHECKER FOR PIC      ;
;                             ;
; Por: Prof. Carlo Requiao    ;
; 26/Ago/2020                 ;
;-----------------------------;

list p = 16f877a		; Specify processor
include <p16f877a.inc>		; Include mapping

mem	equ	0x20		; byte to be tested
counter	equ	0x21		; counter
loopc	equ	0x22		; loop counter

        org 0x00		; Program starts at 0x00
        goto INICIO

INICIO: banksel	0x00		; Select Bank #0
	movlw	0x06		; W = number
	movwf	mem		; [0x20] = number
	clrf	counter		; counter = 0
	movlw	0x08		; loopc = 8
	movwf	loopc	

LOOP:	rrf	mem,1		; number >> 1 through carry
	btfsc	STATUS,C
	incf	counter,1
	decfsz	loopc,1		; loopc --;
	goto	LOOP
		
        END
