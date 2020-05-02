// dac.c
// This software configures DAC output
// Lab 6 requires a minimum of 4 bits for the DAC, but you could have 5 or 6 bits
// Runs on LM4F120 or TM4C123
// Program written by: put your names here
// Date Created: 3/6/17 
// Last Modified: 1/17/2020 
// Lab number: 6
// Hardware connections
// TO STUDENTS "REMOVE THIS LINE AND SPECIFY YOUR HARDWARE********

#include <stdint.h>
#include "../inc/tm4c123gh6pm.h"
// Code files contain the actual implemenation for public functions
// this file also contains an private functions and private data

// **************DAC_Init*********************
// Initialize 4-bit DAC, called once 
// Input: none
// Output: none
void DAC_Init(void){
	uint32_t volatile delay;
	SYSCTL_RCGCGPIO_R |= 0x02; // activate port B
  delay = SYSCTL_RCGCGPIO_R;    // allow time to finish PortB clock activating
	delay++;
	delay++;
	delay++;
	delay++;
  GPIO_PORTB_DIR_R |= 0x07;      // make PB2-0 out
  GPIO_PORTB_DEN_R |= 0x07;      // enable digital I/O on PB2-0
}

// **************DAC_Out*********************
// output to DAC
// Input: 4-bit data, 0 to 15 
// Input=n is converted to n*3.3V/15
// Output: none
void DAC_Out(uint32_t data){
	GPIO_PORTB_DATA_R = data;
}