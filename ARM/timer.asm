@----- ARM GNU ASSEMBLY -----
.syntax unified     @ UAL - Unified Assembly Language
.cpu    cortex-m3   @ Cortex-M3 processor
.thumb              @ Thumb instruction set

.include "STM32.asm"

@===================================================================
@ Code
.text

@-----------------------------
@ RESET HANDLER
@-----------------------------
.global _start
_start:
        bal reset_handler


.type reset_handler, %function
.global reset_handler

reset_handler:
        bal main

@-----------------------------
@ MAIN 
@-----------------------------
main:   
	bl TURN_GPIOA_ON
	bl TURN_TIMER_ON
        bl CONFIGURE_PORT_A
        bl CONFIGURE_TIMER


        bl SET_PORT_A
        bl ENABLE_IRQ
                      
loop:
        bal loop

        
CONFIGURE_TIMER:
	mov	R0,#0xFFFF
	ldr	R1,=TIM1_PSC
	str	R0,[R1]		@ Prescaler pg. 356, f = f_clk/(PSC+1) 16 bits
	
	mov	R0,#0xFFFF
	ldr	R1,=TIM1_ARR
	str	R0,[R1]		@ Auto-reload pg. 356
	
        mov     R0,#0x05
        ldr     R1,=TIM1_CR1	@ CEN & URS pg. 404
        str     R0,[R1]
        
        mov     R0,#0x01
        ldr     R1,=TIM1_DIER   @ Update interrupt enabled (UIE), pg. 410
        str     R0,[R1]
        
        mov	R0,#0x00
        ldr	R1,=TIM1_SR
        bics	R1,R0		@ UIF = 0, ready! pg. 347
        
        bx      LR
        
TURN_TIMER_ON:
	ldr	R1,=RCC_APB2ENR
	ldr	R0,[R1]
	orrs	R0,#0x00000800
	str	R0,[R1]
	bx	LR
        
TURN_GPIOA_ON:
        ldr     R1,=RCC_APB2ENR
        ldr     R0,[R1]
        orrs    R0,#0x00000004
        str     R0,[R1]
        bx      LR

CONFIGURE_PORT_A:
        mov     R0,#0x4224      @ A[0] input, A[1]=A[2] output,
        ldr     R1,=GPIOA_CRL   @ input mode - floating
        str     R0,[R1]        
        bx      LR

SET_PORT_A:        
        mov     R0,#0x00000006  @ A[1,2] = 1
        ldr     R1,=GPIOA_ODR
        str     R0,[R1]
        bx      LR

CLEAR_PORT_A:
	mov	R0,#0x00000000	@ A = 0
	ldr	R1,=GPIOA_ODR
	str	R0,[R1]
	bx	LR        
        
ENABLE_IRQ:                      
        @- enable IRQ
        mov     R0,#0x02000000        @ NVIC_ISER0[25] = 1
        ldr     R1,=NVIC_ISER0  
        str     R0,[R1]
        
        @- clear pending
        ldr     R0,=EXTI_PR
        ldr     R1,[R0]
        orrs    R1,R1,0x00000001
        str     R1,[R0]        
        
        cpsie   I             @ Enable interrupts
        
        bx      LR        
        
@-----------------------------
@ EXTI0 Interrupt Handler
@-----------------------------
.type EXTI0_handler, %function
.global EXTI0_handler

EXTI0_handler:
        ldr     R0,=EXTI_PR
        ldr     R1,[R0]
        ands    R2,R1,0x00000001
       @ beq     EHEnd
        
        ldr     R3,=GPIOA_ODR       @ Read port
        ldr     R4,[R3]
        eors    R4,0x00000006
        str     R4,[R3]
        
EHNext:        
        orrs    R1,R1,0x00000001    @ Acknowledge by
        str     R1,[R0]             @ clearing EXTI_PR[0] bit
        
EHEnd:
        bx      LR
        
        
@-----------------------------
@ OTHER HANDLERS
@-----------------------------
.weak NMI_handler
.thumb_set NMI_handler, Default_Handler

.weak HardFault_handler
.thumb_set HardFault_handler, Default_Handler

.weak MemManage_handler
.thumb_set MemManage_handler, Default_Handler

.weak BusFault_handler
.thumb_set BusFault_handler, Default_Handler

.weak UsageFault_handler
.thumb_set UsageFault_handler, Default_Handler

.weak SVC_handler
.thumb_set SVC_handler, Default_Handler

.weak DebugMonitor_handler
.thumb_set DebugMonitor_handler, Default_Handler

.weak PendSV_handler
.thumb_set PendSV_handler, Default_Handler

.weak SysTick_handler
.thumb_set SysTick_handler, Default_Handler

.weak WWDG_handler
.thumb_set WWDG_handler, Default_Handler

.weak PVD_handler
.thumb_set PVD_handler, Default_Handler

.weak TAMPER_handler
.thumb_set TAMPER_handler, Default_Handler

.weak RTC_handler
.thumb_set RTC_handler, Default_Handler

.weak FLASH_handler
.thumb_set FLASH_handler, Default_Handler

.weak RCC_handler
.thumb_set RCC_handler, Default_Handler

.global Default_Handler
Default_Handler:
        bx      LR
        
.end
