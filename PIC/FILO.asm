;-----------------------------;
; STACK/FILO FOR PIC          ;
;                             ;
; Por: Prof. Carlo Requiao    ;
; 03/Sep/2020                 ;
;-----------------------------;

list p = 16f877a		; Specify processor
include <p16f877a.inc>		; Include mapping

tmp	equ	0x20		; byte to be tested
stack	equ	0x21		; counter


        org 0x00		; Program starts at 0x00
        goto INICIO

INICIO:	movlw	0x22		; Initialize the stack
	movwf	stack
	
	movlw	0x1A		; Push 0x1A and 0x1B
	call	PUSH
	movlw	0x1B
	call	PUSH
	
	nop
	call	POP
	movwf	tmp		; Store it in tmp for visualization

	call	POP
	movwf	tmp
	
	goto	FIM
	
PUSH:	movwf	tmp		; Store W
	movf	stack,0		; Pointer to the stack
	movwf	FSR
	movf	tmp,0		; Recover data to be stored
	movwf	INDF		; push data into stack
	incf	stack,1		; stack ++
	return

POP:	decf	stack,1		; stack --
	movf	stack,0		; Pointer to the stack
	movwf	FSR
	movf	INDF,0
	return

FIM:	nop
		
        END
