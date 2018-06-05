// led-blink.s

// blink the led connected to BCM gpio pin 17

// led(+) to 3v -- 220Ohm; led(-) to bcm gpio 17
// code sets the gpio 17 to output 
// when gpio17-0 led goes on when gpio17-1 led  goes off
//
// author: iszilagyi

// see also: BCM2835-ARM-Peripherals.pdf (gpios from page 89)
// see also: BCM2836 - RPI2 - http://lec.inf.ethz.ch/syscon/2015/slides/LSC15Slides0915.pdf
// see also: http://calc.penjee.com/ for programmers calc.
// see also: for other delay 
//     http://embedded-xinu.readthedocs.io/en/latest/arm/rpi/BCM2835-System-Timer.html


// TODOs -> IO_BASE on cpu type

.section .init

.global _start

_start:
	adr r0, IO_BASE 
	ldr r0,[r0]

    // needs to set bit 21 to 1 in  IO_BASE + 4   (GPFSEL1)
    // for gpio17 to have it for 23-21 as 001 for output mode
    mov r1,#1
    lsl r1,#21
    str r1, [r0, #4]
   	
     // set r3 17bit on (all other bits are 0!)
     mov r3,#1
     lsl r3,#17

    // here the led is already on, next goes off!
	mov r4, #0x1C
osloop: 
    //delay some time:
    mov r2,#0x3F0000 // check load immediate big number! 
   	wait1:
	sub r2,#1
	cmp r2,#0
	bne wait1

    //  #0x1C set gpio 17 to  1 GPSET0 -> led goes off
    //  #0x28 set gpio 17 to  0  GPSCLR0 -> led goes on
    str r3,[r0, r4]
    
    cmp r4, #0x1C
    moveq r4, #0x28
    movne r4, #0x1C
    b osloop

/* version with branches!
    beq on$	
	mov r4, #0x1C
    b osloop
on$: 
	mov r4, #0x28
    b osloop
*/


// from https://www.raspberrypi.org/documentation/hardware/raspberyypi/peripheral_address.html
// for PI2 (bcm2836) anf PI3 B+ -  0x3Fxxxxxx
// IO_BASE: .word 0x3F200000

// for PI0 and PI1 (bcm2835) - 0x20xxxxxx    
IO_BASE: .word 0x20200000  

