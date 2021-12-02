;-----------------------------;
; FIBONACCI GENERATOR FOR PIC ;
;                             ;
; Por: Prof. Carlo Requiao    ;
; 31/Jul/2020                 ;
;-----------------------------;

list p = 16f877a

        org 0x00
        goto INICIO

INICIO: movlw       0x05           ; cnt = 5
        movwf       0x23
        clrf	    0x20           ; x0 = 0
	clrf	    0x21           ; x1 = 0
	incf	    0x21           ; x1 = 1
LOOP:	movf        0x20,0         ; W = x0
        addwf       0x21,0         ; W = W + x1
        movwf       0x22           ; x2 = W
        movf        0x21,0
        movwf       0x20           ; x0 = x1
        movf        0x22,0         
        movwf       0x21           ; x1 = x2
        decfsz      0x23
        goto        LOOP
        
        END
