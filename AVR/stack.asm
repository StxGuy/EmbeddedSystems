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
    array_s: .byte 0x08
    array_d: .byte 0x08
    
.cseg    
.org 0x00   ; Program starts at 0x00

rjmp INICIO

;-------------------------------------;
;                CODE                 ;
;-------------------------------------;
INICIO:
    initstack
    ldi		geral1, 0x04
    ldi		geral2, 0x05
    push	geral1
    push	geral2
    clr		geral1
    clr		geral2
    pop		geral2
    pop		geral1
    
LOOP:
    jmp     LOOP
        
   

          
