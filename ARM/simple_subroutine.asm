main
        mov R0,#1
        mov R1,#2
        bl  soma
        bal fim
        
soma
        add R0,R1,R0
        mov PC,LR
        
fim        
        nop
