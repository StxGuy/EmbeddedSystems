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
.equ TIM1_CR1,      0x40012C00  @ Base = 0x4001 2C00, offset = 0x00
.equ TIM1_DIER,     0x40012C0C  @ Base = 0x4001 2C00, offset = 0x0C
.equ TIM1_ARR,      0x40012C2C  @ Base = 0x4001 2C00, offset = 0x2C
.equ TIM1_SR,       0x40012C10	@ Base = 0x4001 2C00, offset = 0x10
.equ TIM1_PSC,      0x40012C28	@ Base = 0x4001 2C00, offset = 0x28

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
        .word WWDG_handler			@ 0
        .word PVD_handler			@ 1
        .word TAMPER_handler			@ 2
        .word RTC_handler			@ 3
        .word FLASH_handler			@ 4
        .word RCC_handler			@ 5
        .word EXTI0_handler			@ 6
        .word EXTI1_handler			@ 7
        .word EXTI2_handler			@ 8
        .word EXTI3_handler			@ 9
        .word EXTI4_handler			@ 10
        .word DMA1_Channel1_handler		@ 11
        .word DMA1_Channel2_handler		@ 12
        .word DMA1_Channel3_handler		@ 13
        .word DMA1_Channel4_handler		@ 14
        .word DMA1_Channel5_handler		@ 15
        .word DMA1_Channel6_handler		@ 16
        .word DMA1_Channel7_handler		@ 17
        .word ADC1_2_handler			@ 18
        .word CAN1_TX_handler			@ 19
        .word CAN1_RX0_handler			@ 20
        .word CAN1_RX1_handler			@ 21
        .word CAN1_SCE_handler			@ 22
        .word EXTI9_5_handler			@ 23
        .word TIM1_BRK_handler			@ 24
        .word TIM1_UP_handler			@ 25
        .word TIM1_TRG_COM_handler		@ 26
        .word TIM1_CC_handler			@ 27
        .word TIM2_handler			@ 28
        .word TIM3_handler			@ 29
        .word TIM4_handler			@ 30
        .word I2C1_EV_handler			@ 31
        .word I2C1_ER_handler			@ 32
        .word I2C2_EV_handler			@ 33
        .word I2C2_ER_handler			@ 34
        .word SPI1_handler			@ 35
        .word SPI2_handler			@ 36
        .word USART1_handler			@ 37
        .word USART2_handler			@ 38
        .word USART3_handler			@ 39
        .word EXTI15_10_handler			@ 40
        .word RTCAlarm_handler			@ 41
        .word OTG_FS_WKUP_handler		@ 42
        .space 0xE4
