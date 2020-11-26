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

module counter(
	input		clk_50MHz, 
	input		rst_n, 
	input		updown_toggle, 
	input		ena,
	input		[5:0] preload, 

	output	reg	[7:0] DISP0, 
	output 	reg	[7:0] DISP1, 
	output	reg	[7:0] DISP0_preload, 
	output 	reg	[7:0] DISP1_preload, 
	output	reg	[5:0] count_value_number_show, 
	output	reg	count_clk_show
);

	integer preload_dec = 0;
	integer count_value_number = 0;
	reg count_up = 1'b1;

	// for dividing the clock
	integer count_value_frequency = 0;

	// 50MHz to 2Hz: (50M/2*2)-1 = 12500000-1 = 12499999
	// change to 12499999 for FPGA, 2 for ModelSim testing
	integer div_value = 2;

	reg count_clk = 1'b1;
	integer digit_unit = 0;
	integer digit_tens = 0;

	always @(posedge clk_50MHz) begin // preloaded value
		if (!rst_n) begin // set 7-segs to "00"
			DISP1 <= 7'b01111111;
			DISP0 <= 7'b01111111;
		end
		else if (ena) begin // load values of 7-segs based of preloaded value
			preload_dec <= preload[5] * 2^5 + preload[4] * 2^4 + preload[3] * 2^3 + preload[2] * 2^2 + preload[1] * 2^1 + preload[0] * 2^0; // convert preload[] to decimal

			case (preload_dec%10) // 7-segment display control codes
				0:		DISP0_preload <= 7'b1000000;
				1:		DISP0_preload <= 7'b1111001;
				2:		DISP0_preload <= 7'b0100100;
				3:		DISP0_preload <= 7'b0110000;
				4:		DISP0_preload <= 7'b0011001;
				5:		DISP0_preload <= 7'b0010010;
				6:		DISP0_preload <= 7'b0000010;
				7:		DISP0_preload <= 7'b1111000;
				8:		DISP0_preload <= 7'b0000000;
				9:		DISP0_preload <= 7'b0011000;
				default:	DISP0_preload <= 7'b0000111;
			endcase
	
			case (preload_dec/10) // 7-segment display control codes
				0:		DISP0_preload <= 7'b1000000;
				1:		DISP0_preload <= 7'b1111001;
				2:		DISP0_preload <= 7'b0100100;
				3:		DISP0_preload <= 7'b0110000;
				4:		DISP0_preload <= 7'b0011001;
				5:		DISP0_preload <= 7'b0010010;
				6:		DISP0_preload <= 7'b0000010;
				7:		DISP0_preload <= 7'b1111000;
				8:		DISP0_preload <= 7'b0000000;
				9:		DISP0_preload <= 7'b0011000;
				default:	DISP0_preload <= 7'b0000111;
			endcase
		end
	end

	always @(posedge clk_50MHz) begin // counting
		if (updown_toggle) begin
			count_up <= ~count_up;
		end

		// if/else-block below can replace if-block above
		// counts up to preloaded value then back down to 0, then cycle repeats

		/*if (updown_toggle) begin
			if (count_value_number < preload_dec) begin
				if (!count_up) begin
					count_up <= ~count_up;
				end
			end
		end

		else if (count_value_number > preload_dec) begin
			if (count_up) begin
				count_up <= ~count_up;
			end
		end

		else begin
			count_up <= count_up;
		end*/
	end

	always @(posedge clk_50MHz) begin // count_value_frequency counts from 0 -> div_value, loop back to 0
		if (count_value_frequency == div_value) begin
			count_value_frequency <= 0;
		end
		else begin
			count_value_frequency <= count_value_frequency + 1;
		end
	end

	always @(posedge clk_50MHz) begin // count_clk will toggle each time count_value_frequency reaches div_value, creating slower clock
		if (count_value_frequency == div_value) begin
			count_clk <= ~count_clk;
		end
		else begin
			count_clk <= ~count_clk;
		end
	end

	assign count_clk_show = count_clk; // preparing count_clock_show to be displayed for debugging purposes

	always @(posedge count_clk) begin // count to preloaded number using slower clock
		if (!rst_n) begin // set count_value_number to 0 when reset pin is triggered
			count_value_number <= 0;
		end
		else begin // when reset is high
			if (ena) begin // counter enabled
				if (count_up) begin // counting up
					if (count_value_number == preload_dec) begin // set count_value_number to 0 when preloaded value reached
						count_value_number <= 0;
					end
					else begin // count up to preloaded value
						count_value_number <= count_value_number + 1;
					end
				end
				else begin // counting down
					if (count_value_number == 0) begin// set count_value_number to preloaded value when 0 reached
						count_value_number <= preload_dec;
					end
					else begin // count down to 0
						count_value_number <= count_value_number - 1;
					end
				end
			end
			else begin // counter disabled
				count_value_number <= count_value_number;
			end
		end
	end

	assign count_value_number_show = count_value_number; // preparing count_value_number_show to be displayed for debugging purposes

	always @(posedge clk_50MHz) begin
		if (!rst_n) begin // display "00" on 7-segs when counter is reset
			DISP0 <= 7'b01111111;
			DISP1 <= 7'b01111111;

		end
		else if (ena) begin // counter enabled
			digit_unit <= count_value_number % 10; // get ones digit of count_value_number
			case (digit_unit) // 7-segment display control codes
				0:		DISP0 <= 7'b1000000;
				1:		DISP0 <= 7'b1111001;
				2:		DISP0 <= 7'b0100100;
				3:		DISP0 <= 7'b0110000;
				4:		DISP0 <= 7'b0011001;
				5:		DISP0 <= 7'b0010010;
				6:		DISP0 <= 7'b0000010;
				7:		DISP0 <= 7'b1111000;
				8:		DISP0 <= 7'b0000000;
				9:		DISP0 <= 7'b0011000;
				default:	DISP0 <= 7'b0000111;
			endcase

			digit_tens <= count_value_number / 10; // get tens digit of count_value_number
			case (digit_tens) // 7-segment display control codes
				0:		DISP1 <= 7'b1000000;
				1:		DISP1 <= 7'b1111001;
				2:		DISP1 <= 7'b0100100;
				3:		DISP1 <= 7'b0110000;
				4:		DISP1 <= 7'b0011001;
				5:		DISP1 <= 7'b0010010;
				6:		DISP1 <= 7'b0000010;
				7:		DISP1 <= 7'b1111000;
				8:		DISP1 <= 7'b0000000;
				9:		DISP1 <= 7'b0011000;
				default:	DISP1 <= 7'b0000111;
			endcase
		end
	end

endmodule
