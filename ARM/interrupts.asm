@----- ARM GNU ASSEMBLY -----
.syntax unified     @ UAL - Unified Assembly Language
.cpu    cortex-m3   @ Cortex-M3 processor
.thumb              @ Thumb instruction set

@----- STM32 Memory Map -----
.equ RCC_APB2ENR,   0x40021018  @ Base = 0x4002 1000, offset = 0x18
.equ GPIOA_CRL,     0x40010800  @ Base = 0x4001 0800, offset = 0x00
.equ GPIOA_CRH,     0x40010804  @ Base = 0x4001 0800, offset = 0x04
.equ GPIOA_ODR,     0x4001080C  @ Base = 0x4001 0800, offset = 0x0C
.equ GPIOA_IDR,     0x40010808  @ Base = 0x4001 0800, offset = 0x08
.equ AFIO_EXTICR1,  0x40010008  @ Base = 0x4001 0000, offset = 0x08
.equ EXTI_RTSR,     0x40010408  @ Base = 0x4001 0400, offset = 0x08
.equ EXTI_FTSR,     0x4001040C  @ Base = 0x4001 0400, offset = 0x0C
.equ EXTI_IMR,      0x40010400  @ Base = 0x4001 0400, offset = 0x00
.equ EXTI_EMR,      0x40010404  @ Base = 0x4001 0400, offset = 0x04
.equ EXTI_PR,       0x40010414  @ Base = 0x4001 0400, offset = 0x14
.equ NVIC_ISER0,    0xE000E100  @ Base = 0xE000 E100, offset = 0x00

@===================================================================
@ Vector Interrupt Table
.section .VectorTable, "a", %progbits
.global Vectors
.type   Vectors, %object
Vectors:
        .word _StackEnd
        .word reset_handler
        .word NMI_handler
        .word HardFault_handler
        .word MemManage_handler
        .word BusFault_handler
        .word UsageFault_handler
        .word 0,0,0,0
        .word SVC_handler
        .word DebugMonitor_handler
        .word 0
        .word PendSV_handler
        .word SysTick_handler
        .word WWDG_handler
        .word PVD_handler
        .word TAMPER_handler
        .word RTC_handler
        .word FLASH_handler
        .word RCC_handler
        .word EXTI0_handler
        .space 0xE4

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
        bl GPIOA_CLK_ENABLE
        bl CONFIGURE_PORT_A
        bl SET_PORT_A
        bl CONFIGURE_EXT
        bl ENABLE_IRQ
                      
loop:
        bal loop

GPIOA_CLK_ENABLE:
        mov     R0,#0x00000000
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
        mov     R0,#0x00000002  @ A[1] = 1
        ldr     R1,=GPIOA_ODR
        str     R0,[R1]
        bx      LR
        
CONFIGURE_EXT:        
        mov     R0,#0x00000001  @ EXTI_IMR = 1 unmask MR0
        ldr     R1,=EXTI_IMR
        str     R0,[R1]        
        
        mov     R0,#0x00000001  @ EXTI_RTSR = 1, rising edge
        ldr     R1,=EXTI_RTSR
        str     R0,[R1]
        
        mov     R0,#0x00000001  @ EXTI_FTSR = 1, falling edge
        ldr     R1,=EXTI_FTSR
        str     R0,[R1]
        
        mov     R0,#0x00000000  @ AFIO_EXTICR1 = 0: PA[0] pin
        ldr     R1,=AFIO_EXTICR1
        str     R0,[R1]
        
        bx      LR

ENABLE_IRQ:                      
        @- enable IRQ
        mov     R0,#0x40        @ NVIC_ISER0[6] = 1
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
