#include <avr/io.h>
#include <avr/interrupt.h>

ISR(RTC_PIT_vect)
{
    if (RTC.PITINTFLAGS) {
        
        if (PORTB.IN & PIN3_bm){
            PORTB.OUTCLR = PIN3_bm;
        }
        else {
            PORTB.OUTSET = PIN3_bm;
        }
                
        RTC.PITINTFLAGS = 0x01;
    }
}

// Configure ports
void initPorts(void) {
    // SWITCH: PORTB[2]
    PORTB.DIRCLR = PIN2_bm; // Switch is input
    PORTB.PIN2CTRL |= PORT_PULLUPEN_bm | PORT_ISC_RISING_gc; // Pull-up for switch;
        
    // SWITCH: PORTB[3]
    PORTB.DIRSET = PIN3_bm; // LET is output
    PORTB.OUTSET = PIN3_bm; // Turn LED on
}

void initPIT(void) {
    // Configure the desired oscillator: 32768Hz/32 = 1024Hz
    RTC.CTRLA = 1 << RTC_RUNSTDBY_bp
                | 0 << RTC_PRESCALER_3_bp
                | 1 << RTC_PRESCALER_2_bp
                | 1 << RTC_PRESCALER_1_bp
                | 1 << RTC_PRESCALER_0_bp
                | 0 << RTC_CORREN_bp
                | 0 << RTC_RTCEN_bp;
    // PRESCALER = DIV128 -> 8 Hz
    RTC.CLKSEL = 1 << RTC_CLKSEL_0_bp;
    
    // Enable the interrupt
    RTC.PITINTCTRL = 1 << RTC_PI_bp;
    
    // Select the period: 254 cycles = 0x07
    // Enable PIT
    RTC.PITCTRLA = 0 << RTC_PERIOD_3_bp
                    | 1 << RTC_PERIOD_2_bp
                    | 1 << RTC_PERIOD_1_bp
                    | 1 << RTC_PERIOD_0_bp
                    | 1 << RTC_PITEN_bp;
    
    RTC.CTRLA |= 1 << RTC_RTCEN_bp;  // RTCEN = 1
}

int main(void) {
    int a = 0;
    initPorts();
    initPIT();
    sei();

    while(1) {
     /*   if (!(PORTB.IN & (PIN2_bm))) {
            PORTB.OUTSET = PIN3_bm;
        }
        else {
            PORTB.OUTCLR = PIN3_bm;
        } */
        a = 1;
    }

    return 0;
}
