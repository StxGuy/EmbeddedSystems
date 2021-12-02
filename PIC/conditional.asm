;-----------------------------;
; CONDITIONAL FOR PIC         ;
;                             ;
; Por: Prof. Carlo Requiao    ;
; 12/Ago/2020                 ;
;-----------------------------;

list p = 16f877a		; Specify processor
include <p16f877a.inc>		; Include mapping

        org 0x00		; Program starts at 0x00
        goto INICIO

INICIO: banksel	0x00		; Select Bank #0
	movlw	0x06		; W = number
	movwf	0x20		; [0x20] = W = number
	movlw	0x05		; W = 5
	subwf	0x20,0		; W = W - [0x20] = W - number
	btfss	STATUS,Z	; Zero?
	goto	CODE_2
CODE_1:	nop
	goto	NEXT
CODE_2:	nop
NEXT:	nop	
		
        END
