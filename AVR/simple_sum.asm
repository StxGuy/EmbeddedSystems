    .device ATmega328

    .org 0x00		; Program starts at 0x00
    rjmp    main
    
main:
        ldi     R16,0x01
        ldi     R17,0x02
        call    soma
        rjmp    fim
        
soma:
        add     R16,R17
        ret
        
fim:
        nop
