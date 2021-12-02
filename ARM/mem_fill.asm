		;		Immediate addressing
		mov		R4,#0x20000000	; Base memory
		mov		R0,#12		; Number of positions
		mov		R1,#1		; What to be written
		
loop
		str		R1,[R4],#4	; [R4] = R1, R4 += 4
		subs		R0,R0,#4		; R0 -= 4
		bne		loop			; Loop if not zero
		
		
