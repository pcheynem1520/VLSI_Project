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
// CIRCUIT DEFINITION FILE
// 
//=========================================================

module sequence_detector(
    /* circuit control signals */
	input   logic   clk, // main clock signal
    input   logic   rst, // reset
    input   logic   ena, // enable

    /* input signals */
    input   logic   sig_to_test, // input signal to be tested for 01[0*]1

    /* 7-segment display signals */
    output  logic   [6:0] disp0, // ones digit
    output  logic   [6:0] disp1, // tens digit

    /* output signals */
    output  logic   z // T/F sequence detection
);

    /* variable assignments */
    integer count_detect = 0; // counter of times sequence was detected

    /* state register */
        /* states */
        // 000 -> start
        // 001 -> first
        // 011 -> second
        // 111 -> delay
        // 110 -> success_delay
        // 010 -> success
        // 100 -> null -> error, go to start
        // 101 -> null -> error, go to start
    typedef enum logic [2:0]
    {start, first, success, second, unused_0, unused_1, success_delay, delay} statetype;
    statetype state, next_state;

    /* next-state register */
    always_ff @(posedge clk) begin
        if (rst) begin
           state <= start;
           count_detect <= 0;
        end else if (ena) begin
            state <= next_state;
            if (z) begin // not posedge in case of 2 consecutive detections
               count_detect <= count_detect + 1;
            end
        end
    end

    /* next-state logic */
    always_comb begin
        next_state[2] <= (state[1] & state[0] & ~sig_to_test) | (state[2] & ~sig_to_test) | (state[2] & state[0]);
        next_state[1] <= (state[0] & sig_to_test) | (state[1] & state[0]) | (state[2]);
        next_state[1] <= (~sig_to_test) | (~state[1] & state[0]);
    end

    /* output logic */
    assign z = (state[2] & sig_to_test) | (state[1] & state[0] & sig_to_test);

    /* 7-segment display control logic */
    always @(posedge clk) begin 
        if (rst) begin // reset signal goes high, set 7-segs to "00"
            disp0 = 7'b1000000;
            disp1 = 7'b1000000;
        end
        else if (ena) begin // enable signal high
            /* 7-segment display control codes for ones unit */
            case (count_detect % 10) // mod10 for units
				0:		    disp0 <= 7'b1000000;
				1:		    disp0 <= 7'b1111001;
				2:		    disp0 <= 7'b0100100;
				3:		    disp0 <= 7'b0110000;
				4:		    disp0 <= 7'b0011001;
				5:		    disp0 <= 7'b0010010;
				6:		    disp0 <= 7'b0000010;
				7:		    disp0 <= 7'b1111000;
				8:		    disp0 <= 7'b0000000;
				9:		    disp0 <= 7'b0011000;
				default:	disp0 <= 7'b0000111;
			endcase
            /* 7-segment display control codes for tens unit */
			case (count_detect / 10) // divide round down for tens
				0:		    disp1 <= 7'b1000000;
				1:		    disp1 <= 7'b1111001;
				2:		    disp1 <= 7'b0100100;
				3:		    disp1 <= 7'b0110000;
				4:		    disp1 <= 7'b0011001;
				5:		    disp1 <= 7'b0010010;
				6:		    disp1 <= 7'b0000010;
				7:		    disp1 <= 7'b1111000;
				8:		    disp1 <= 7'b0000000;
				9:		    disp1 <= 7'b0011000;
				default:	disp1 <= 7'b0000111;
			endcase
        end
    end

endmodule
