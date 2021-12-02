;-------------------------------------;
; STACK FOR ATMEL328                  ;
;                                     ;
; Por: Prof. Carlo Requiao            ;
; 22/Sep/2020                         ;
;-------------------------------------;

.device ATmega328

;-------------------------------------;
;               MACROS                ;
;-------------------------------------;
.macro initstack
	ldi	R16,low(RAMEND)
	out	spl,R16
	ldi	R16,high(RAMEND)
	out	sph,R16
.endmacro

;-------------------------------------;
;             DEFINITIONS             ;
;-------------------------------------;
.def geral1=R18
.def geral2=R19	

;-------------------------------------;
;          MEMORY SEGMENTS            ;
;-------------------------------------;
.dseg
   dest: .byte 0x05
        
.cseg    
	
.org 0x00   ; Program starts at 0x00

rjmp INICIO

;-------------------------------------;
;                CODE                 ;
;-------------------------------------;
INICIO:
    initstack
    ldi		geral1,5
    ldi		ZL,low(array<<1)
    ldi		ZH,high(array<<1)
PUT:	
    lpm		R1,Z+
    push	R1
    dec		geral1
    brne	PUT

    ldi		geral1,5
    ldi		XL,low(dest)
    ldi		XH,high(dest)
TAKE:
    pop		R1
    st		X+,r1
    dec		geral1
    brne	TAKE
        
    
LOOP:
    jmp     LOOP

;-------------------------------------;
;               ARRAY                 ;
;-------------------------------------;        
array: .db 1,2,3,4,5   

          
