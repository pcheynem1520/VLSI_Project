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
//=========================================================

`timescale 1ns/1ns

module project_TB;
	reg		CLOCK_50;
	reg		RST_n; // key[0]; clear; key[1], toggle mode;
	reg		UPDOWN; 
	reg		ENA; // SW[0]; enable; SW[5:1], load;
	reg		COUNT_clk_chow; 
	reg		[5:0] PRELOAD; // LEDR[0]; enable LED; LEDR[5:1], load LED;
	reg		[5:0] COUNT_value_number_show;

	wire	[7:0] DISP0_PRELOAD; // ones of count number
	wire	[7:0] DISP1_PRELOAD; // tens of count number
	wire	[7:0] DISP0; // ones of loaded number
	wire	[7:0] DISP1; // tens of loaded number

	counter uut(
		.clk_50MHz (CLOCK_50), 
		.rst_n (RST_n), 
		.updown_toggle (UPDOWN), 
		.ena (ENA), 
		.count_clk_show (COUNT_clk_chow), 
		.preload (PRELOAD), 
		.count_value_number_show (COUNT_value_number_show), 

		.DISP0_preload (DISP0_PRELOAD), 
		.DISP1_preload (DISP1_PRELOAD), 
		.DISP0 (DISP0), 
		.DISP1 (DISP1)
	);

/*
	initial begin
		CLOCK_50 = 1'b0; // start clock at 0
		RST_n = 1'b1; // reset:0, set:1
		UPDOWN = 1'b0; // count up:0, count down:1
		ENA = 1'b1; // disable counter: 0, enable counter: 1

		PRELOAD = 6'b100011; // preloaded value: 100011 -> 35
		#1000; // wait 1000ns -> 1ms
	end

	always begin
		#20 CLOCK_50 = ~CLOCK_50; // set main clock speed to 50MHz
	end
*/

 	initial begin
    	CLOCK_50 = 1'b0; // start clock at 0
    end

    always begin
        #20 CLOCK_50 = ~CLOCK_50;
    end
 
	initial begin 
		RST_n = 1'b1; // reset:0, set:1
		UPDOWN = 1'b0; // count up:0, count down:1
		ENA = 1'b1; // disable counter: 0, enable counter: 1

		PRELOAD = 6'b100011; // preloaded value: 100011 -> 35
		#1000; // wait 1000ns -> 1ms

		//#10000  

		RST_n=1'b0;		//clear, no toggle: wrong output : as rest is very fast
		#50
		RST_n=1'b1; 
		#500
		RST_n = 1'b0;
		#140
		RST_n = 1'b1;
		#1000

		UPDOWN = 1'b1;
    end 

endmodule
