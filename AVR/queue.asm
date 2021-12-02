;-------------------------------------;
; FIFO FOR ATMEL328                   ;
;                                     ;
; Por: Prof. Carlo Requiao            ;
; 22/Sep/2020                         ;
;-------------------------------------;

.device ATmega328

;-------------------------------------;
;          MEMORY SEGMENTS            ;
;-------------------------------------;

.dseg
    mem: .byte 0x02
    
.cseg    
.org 0x00   ; Program starts at 0x00

rjmp INICIO

;-------------------------------------;
;               MACROS                ;
;-------------------------------------;
.macro initstack
	ldi	R16,low(RAMEND)
	out	spl,R16
	ldi	R16,high(RAMEND)
	out	sph,R16
.endmacro

.macro initqueue
	ldi	R16,low(RAMEND)
	sts	mem,R16
	ldi	R16,high(RAMEND)
	sts	mem+1,R16
.endmacro

.macro enqueue
	push	@0
.endmacro

.macro dequeue
	lds	R1,mem
	mov	Xl,R1
	lds	R2,mem+1
	mov	Xh,R2
	ld	@0,X
	dec	R1
	sts	mem,R1
.endmacro	

;-------------------------------------;
;             DEFINITIONS             ;
;-------------------------------------;
.def geral1=R18
.def geral2=R19	

;-------------------------------------;
;                CODE                 ;
;-------------------------------------;
INICIO:
    initstack
    initqueue
    ldi		geral1, 0x04
    ldi		geral2, 0x05
    enqueue	geral1
    enqueue	geral2
    clr		geral1
    clr		geral2
    
    dequeue	geral1
    dequeue	geral2
    
LOOP:
    jmp     LOOP
        
   

          
