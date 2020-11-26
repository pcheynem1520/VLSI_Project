//=========================================================
// EELE 4054: Digital VLSI Design
// Authors: Temiloluwa Awe, PJ Cheyne-Miller
// Date: Nov. 11, 2020
// Description: A Mealy Finite State Machine state detector
// 
// Searches for a series of binary inputs that satisfies
// 01[0*]1, where 0* is any number of zeros. A 7-segment
// display will count up the number of times 01[0*]1 is
// found in a sequence.
// 
// TESTBENCH FILE
// 
//=========================================================

`timescale 1ns/1ns

/* testbench sinals */
module project_TB;
	logic	CLOCK; // clock signal
	logic	RESET; // reset signal
	logic	ENABLE; // enable signal
	
	logic	[7:0] DISP0; // ones of loaded number
	logic	[7:0] DISP1; // tens of loaded number

	sequence_detector uut(
		.clk (CLOCK), 
		.rst (RESET), 
		.ena (ENABLE), 

		.DISP0 (DISP0), 
		.DISP1 (DISP1)
	);

	/* initialize clock signal */
 	initial begin
    	CLOCK = 1'b0; // start clock signal low
    end

	/* define clock signal */
    always begin
        #5 CLOCK = ~CLOCK; // 100MHz, posedge -> posedge
    end
 
	/* runtime signals */
	initial begin
		RESET = 1'b0; // set:0, reset:1
		ENABLE = 1'b1; // disable counter: 0, enable counter: 1

    end 

endmodule
