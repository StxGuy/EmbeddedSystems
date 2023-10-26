#include <avr/io.h>

// Configure ports
void initPorts(void) {
    // SWITCH: PORTB[2]
    PORTB.DIRCLR = PIN2_bm; // Switch is input
    PORTB.PIN2CTRL |= PORT_PULLUPEN_bm | PORT_ISC_RISING_gc; // Pull-up for switch;
        
    // SWITCH: PORTB[3]
    PORTB.DIRSET = PIN3_bm; // LET is output
    PORTB.OUTCLR = PIN3_bm; // Turn LED on
    
    // ADC Pin input
    PORTD.DIRCLR = PIN4_bm;
    PORTD.PIN4CTRL &= ~PORT_ISC_gm;
}

void configADC(void) {
    // Run in standby
    // Single-ended
    // Right adjusted
    // 10-bit resolution
    // no free-run
    // ADC enabled
    ADC0.CTRLA = 1 << ADC_RUNSTBY_bp
                    | 0 << ADC_CONVMODE_bp
                    | 0 << ADC_LEFTADJ_bp
                    | 0 << ADC_RESSEL1_bp
                    | 0 << ADC_RESSEL0_bp
                    | 0 << ADC_FREERUN_bp
                    | 1 << ADC_ENABLE_bp;
                    
    // No accumulation
    ADC0.CTRLB = 0x00;
    
    // PRESCALE by 2 (minimum)
    ADC0.CTRLC = 0x00;
    
    // Minimum initialization delay
    // Minimum sampling delay
    ADC0.CTRLD = 0 << ADC_INITDLY_2_bp
                    | 0 << ADC_INITDLY_2_bp
                    | 0 << ADC_INITDLY_1_bp
                    | 1 << ADC_INITDLY_0_bp
                    | 0 << ADC_SAMPDLY_3_bp
                    | 0 << ADC_SAMPDLY_2_bp
                    | 0 << ADC_SAMPDLY_1_bp
                    | 1 << ADC_SAMPDLY_0_bp;
    
    // AIN4
    ADC0.MUXPOS = ADC_MUXPOS_AIN4_gc;
    ADC0.MUXNEG = ADC_MUXNEG_AIN4_gc;
}

int main(void) {
    initPorts();
    configADC();


    while(1) {
        // Start a conversion
        ADC0.COMMAND = ADC_STCONV_bm;
        
        // Wait until it converts
        while(!(ADC0.INTFLAGS & ADC_RESRDY_bm));
        
        // If it is too high, turn LED on, otherwise, turn it off
        if (ADC0.RESL > 222) {
            PORTB.OUTSET = PIN3_bm;
        }
        else
        {
            PORTB.OUTCLR = PIN3_bm;
        }
    }

    return 0;
}
