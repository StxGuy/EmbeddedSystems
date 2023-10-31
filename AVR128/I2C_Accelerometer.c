#include <avr/io.h>
#include <util/delay.h>


// Configure ports
void initPorts(void) {
    // SWITCH: PORTB[2]
    PORTB.DIRCLR = PIN2_bm; // Switch is input
    PORTB.PIN2CTRL |= PORT_PULLUPEN_bm | PORT_ISC_RISING_gc; // Pull-up for switch;
        
    // LED: PORTB[3]
    PORTB.DIRSET = PIN3_bm; // LED is output
    PORTB.OUTSET = PIN3_bm; // Turn LED on
    
    // TWI, PORT_A 2 & 3
    PORTA.DIRCLR = PIN2_bm;
    PORTA.DIRCLR = PIN3_bm;
    PORTA.PIN2CTRL = PORT_PULLUPEN_bm;
    PORTA.PIN3CTRL = PORT_PULLUPEN_bm;    
}
void I2C_init() {
    // Master Baud Rate
    TWI0.MBAUD = 76;
            
    // Enable TWI
    TWI0.MCTRLA = TWI_ENABLE_bm;
    TWI0.MSTATUS = TWI_BUSSTATE_IDLE_gc;
}

// Address Packet Transmit: Write (bit 0)
void I2C_Add_W(uint8_t add) {
    uint8_t SAD = add << 1;
    
    TWI0.MADDR = SAD;
    while(!(TWI0.MSTATUS & (TWI_WIF_bm | TWI_RIF_bm)));
    
    // Address not acknowledged
    if (TWI0.MSTATUS & TWI_RXACK_bm) {
        TWI0.MCTRLB |= TWI_MCMD_STOP_gc; // stop
        while (!(TWI0.MSTATUS & TWI_BUSSTATE_IDLE_gc));
    }
}

// Address Packet Transmit
void I2C_Add_R(uint8_t add) {
    uint8_t SAD = add << 1 | 0x1;
        
    TWI0.MADDR = SAD;
    while(!(TWI0.MSTATUS & (TWI_WIF_bm | TWI_RIF_bm)));
    
    // Address not acknowledged
    if (TWI0.MSTATUS & TWI_RXACK_bm) {
        TWI0.MCTRLB |= TWI_MCMD_STOP_gc; // stop
        while (!(TWI0.MSTATUS & TWI_BUSSTATE_IDLE_gc));
    }    
}

void I2C_sendData(uint8_t data) {
    //TWI0.MCTRLB = TWI_MCMD_RECVTRANS_gc;
    TWI0.MDATA = data;
    // Wait for the data to be sent
    while(!(TWI0.MSTATUS & TWI_WIF_bm));
}

void I2C_stop() {
    // Send stop condition
    TWI0.MCTRLB |= TWI_MCMD_STOP_gc;
    while(!(TWI0.MSTATUS & TWI_BUSSTATE_IDLE_gc));
}

uint8_t I2C_read() {
    while(!(TWI0.MSTATUS & TWI_RIF_bm));
    uint8_t data = TWI0.MDATA;
    
    TWI0.MCTRLB = TWI_ACKACT_NACK_gc;
    
    return data;
}

void Accel_init() {
    I2C_Add_W(0x18);
    I2C_sendData(0x20);
    I2C_sendData(0x50);
    I2C_stop();
}

int main(void) {
    initPorts();

    // Initiate I2C
    I2C_init();
    Accel_init();
                
    while(1) {
        _delay_ms(100);
        
        I2C_Add_W(0x18);  // Write
        I2C_sendData(0x28);
        I2C_Add_R(0x18);  // Read
        uint8_t x = I2C_read();
        I2C_stop();
        
        
        if (x > 1) {
            PORTB.OUTCLR = PIN3_bm;
        }
        else {
            PORTB.OUTSET = PIN3_bm;
        }        
    }

    return 0;
}
