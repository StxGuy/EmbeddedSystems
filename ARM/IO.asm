@ Peripheral base: 0x4000 0000
@ -- RCC base: 0x4002 1000
@ -- Port A base: 0x4001 0800
@ -- Port B base: 0x4001 0C00
@ -- Port C base: 0x4001 1000
@ -- Port D base: 0x4001 1400
@ -- Port E base: 0x4001 1800
@ -- Port F base: 0x4001 1C00
@ -- Port G base: 0x4001 2000
@ Peripheral clock enable register (RCC_APB2ENR): + 0x18
@ General purpose input/output configuration register (GPIOx_CRL/H): + 0x00/0x04
@ Output data register (GPIOx_ODR): + 0x0C
@ Input data register (GPIOx_IDR): + 0x08

.syntax unified
.cpu    cortex-m3
.thumb

.equ RCC_APB2ENR,   0x40021018
.equ GPIOA_CRL,     0x40010800
.equ GPIOA_CRH,     0x40010804
.equ GPIOA_ODR,     0x4001080C
.equ GPIOA_IDR,     0x40010808


.text                       @ This is code
.global _start              @ Declare _start as globally visible
                        
_start:                
                
@---------------------------------------
@ MAIN LOOP
@---------------------------------------
main:
                bl      cfg
main_loop:                
                bl      turn_LED_on
                bl      delay
                bl      turn_LED_off
                bl      delay
                bal     main_loop

@---------------------------------------
@ CONFIGURE PORT A
@---------------------------------------
cfg:
                @ Configure port A
                mov     R0,#0x01
                ldr     R1,=GPIOA_CRL
                str     R0,[R1]

                @ Enable port A
                mov     R0,#0x04
                ldr     R1,=RCC_APB2ENR
                str     R0,[R1]
                
                mov     PC,LR

@---------------------------------------
@ TURN LED ON/OFF
@---------------------------------------                
turn_LED_on:
                mov     R0,#0x01
                ldr     R1,=GPIOA_ODR
                str     R0,[R1]
                mov     PC,LR

turn_LED_off:
                mov     R0,#0x00
                ldr     R1,=GPIOA_ODR
                str     R0,[R1]
                mov     PC,LR

@---------------------------------------
@ DELAY
@---------------------------------------
delay:
                mov     R0,#0x800000
delay_loop:
                subs    R0,R0,#1
                bne     delay_loop
                mov     PC,LR

@---------------------------------------
@ END
@---------------------------------------
end:
                b       end
                
                .end
            
