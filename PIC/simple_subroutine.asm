list p = 16f877a		; Specify processor
include <p16f877a.inc>		; Include mapping

main:
        banksel 0x00
        movlw   0x01
        movwf   0x20
        movlw   0x02
        movwf   0x21
        call    soma
        goto    fim
        
soma:
        banksel 0x00
        movf    0x20,0
        addwf   0x21,0
        return
        
fim:
        nop
        
        END        
