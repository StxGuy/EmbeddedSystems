#include <avr/io.h>
#include <stdbool.h>
#include <avr/interrupt.h>


void initPorts(void) {
    PORTB.DIRCLR = PIN2_bm; // Switch is input
    PORTB.DIRSET = PIN3_bm; // LET is output
    
    PORTB.PIN2CTRL |= PORT_PULLUPEN_bm; // Pull-up for switch;
    
    PORTB.OUTSET = PIN3_bm; // Turn LED on
}

int main(void) {
    initPorts();

    while(1) {
        if (!(PORTB.IN & (PIN2_bm))) {
            PORTB.OUTSET = PIN3_bm;
        }
        else {
            PORTB.OUTCLR = PIN3_bm;
        }
    }

    return 0;
}

 

 

 

 
