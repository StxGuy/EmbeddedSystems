#include <avr/io.h>
#include <avr/interrupt.h>

// Interrupt Service Routine for Vector 45, address 0x5A, PORTB
ISR(PORTB_PORT_vect) {
    if (PORTB.INTFLAGS & PIN2_bm) {
        
        if (PORTB.IN & PIN3_bm){
            PORTB.OUTCLR = PIN3_bm;
        }
        else {
            PORTB.OUTSET = PIN3_bm;
        }
                
        PORTB.INTFLAGS &= PIN2_bm;
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

int main(void) {
    int a = 0;
    initPorts();
    sei();

    while(1) {
        a = 1;
    }

    return 0;
}
