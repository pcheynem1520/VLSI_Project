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

	logic	SIGNAL_IN; // input signal
	
	logic	[7:0] DISP0; // ones of loaded number
	logic	[7:0] DISP1; // tens of loaded number

	logic	SEQUENCE_FLAG; // flag triggered when sequence is detected
	logic	SEQUENCE_COUNTER; // number of times sequence is found between resets

sequence_detector uut(
	.clk (CLOCK), 
	.rst (RESET), 
	.ena (ENABLE), 

	.sig_to_test (SIGNAL_IN), 

	.disp0 (DISP0), 
	.disp1 (DISP1), 

	.z (SEQUENCE_FLAG), 
	.count_detect (SEQUENCE_COUNTER)
);

	/* state names and numbers*/
    typedef enum logic [2:0]
	{start, first, success, second, unused_0, unused_1, success_delay, delay} statetype;
	statetype state, next_state;

	/* test signal */
	logic	[0:23] TEST_SIG = 24'b000100110001011101010011; // LSB -> MSB for readability of passing signal

	/* initialize clock signal */
	initial begin
   		CLOCK = 1'b0; // start clock signal low
	end

	/* start clock signal */
	always begin
        	#5 CLOCK = ~CLOCK; // 100MHz, posedge -> posedge
	end
 
	/* runtime signals */
	initial begin
		/* initialisation */
		RESET <= 1'b1; // set:0, reset:1
		ENABLE <= 1'b1; // disable counter: 0, enable counter: 1
		SEQUENCE_FLAG <= 1'b0; // initialise detection flag at 0
		SEQUENCE_COUNTER <= 0; // initialise counter at 0

		#10 // wait 10ns/1 clock cycles

		/* send test signal */
		SIGNAL_IN <= TEST_SIG[0];
		#10
		SIGNAL_IN <= TEST_SIG[1];
		#10
		SIGNAL_IN <= TEST_SIG[2];
		#10
		SIGNAL_IN <= TEST_SIG[3];
		#10
		SIGNAL_IN <= TEST_SIG[4];
		#10
		SIGNAL_IN <= TEST_SIG[5];
		#10
		SIGNAL_IN <= TEST_SIG[6];
		#10
		SIGNAL_IN <= TEST_SIG[7];
		#10
		SIGNAL_IN <= TEST_SIG[8];
		#10
		SIGNAL_IN <= TEST_SIG[9];
		#10
		SIGNAL_IN <= TEST_SIG[10];
		#10
		SIGNAL_IN <= TEST_SIG[11];
		#10
		SIGNAL_IN <= TEST_SIG[12];
		#10
		SIGNAL_IN <= TEST_SIG[13];
		#10
		SIGNAL_IN <= TEST_SIG[14];
		#10
		SIGNAL_IN <= TEST_SIG[15];
		#10
		SIGNAL_IN <= TEST_SIG[16];
		#10
		SIGNAL_IN <= TEST_SIG[17];
		#10
		SIGNAL_IN <= TEST_SIG[18];
		#10
		SIGNAL_IN <= TEST_SIG[19];
		#10
		SIGNAL_IN <= TEST_SIG[20];
		#10
		SIGNAL_IN <= TEST_SIG[21];
		#10
		SIGNAL_IN <= TEST_SIG[22];
		#10
		SIGNAL_IN <= TEST_SIG[23];

		/* halt */
		RESET <= 1'b1;
		ENABLE <= 1'b0;
		#10
		RESET <= 1'b0;
	end 

endmodule
