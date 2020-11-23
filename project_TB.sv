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
	reg	CLOCK_50;
	reg	RST_n; // key[0]; clear; key[1], toggle mode;
	reg	UPDOWN; 
	reg	ENA; // SW[0]; enable; SW[5:1], load;
	reg	COUNT_clk_chow; 
	reg	[5:0] PRELOAD; // LEDR[0]; enable LED; LEDR[5:1], load LED;
	reg	[5:0] COUNT_value_number_show;

	wire	[7:0] DISP0_PRELOAD; // tens of count number
	wire	[7:0] DISP1_PRELOAD; // ones of count number
	wire	[7:0] DISP0; // tens of loaded number
	wire	[7:0] DISP1; // ones of loaded number

	counter uut(
		.clk_50MHz (CLK_50), 
		.rst_n (RST_n), 
		.updown_toggle (UPDOWN), 
		.ena (ENA), 
		.preload (PRELOAD), 

		.DISP0_preload (DISP0_PRELOAD), 
		.DISP1_preload (DISP1_PRELOAD), 
		.DISP0 (DISP0), 
		.DISP1 (DISP1), 
		.count_value_number_show (COUNT_value_number_show), 
		.count_clk_show (COUNT_clk_chow)
	);

	initial begin
		CLOCK_50 = 1'b0;
		RST_n = 1'b1;
		UPDOWN = 1'b0;
		ENA = 1'b1;

		PRELOAD = 6'b100011;
		#1000;
	end

	always begin
		#20 CLOCK_50 = ~CLOCK_50;
	end

endmodule
