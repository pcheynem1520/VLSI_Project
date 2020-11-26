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

module sequence_detector(
    /* control signals */
	input   logic   clk, // main clock signal
    input   logic   rst, // reset
    input   logic   ena, // enable

    /* 7-segment display signals */
    output  logic   [6:0] disp0, // ones digit
    output  logic   [6:0] disp1, // tens digit

    /* outputs */
    output  logic   z, // T/F sequence detection
    output  logic   count_detect // counter of times sequence was detected
);

    /* states */
    typedef enum logic [2:0]
	{start, first, second, delay, success_d, success} statetype;
	statetype state, next_state;

    /* state register */
    always_ff begin
        if (rst) begin
           state <= start;
           count_detect <= 0;
        end
        else begin
           state <= next_state; 
        end
    end

    /* next state logic */
    

    /* output logic */
    

    /* 7-segment display control logic */
    always @(posedge clk) begin 
        if (rst) begin // reset signal goes high, set 7-segs to "00"
            disp0 = 7'b1000000;
            disp1 = 7'b1000000;
        end

        else if (ena) begin // enable signal high, logic enabled
            case (digit_unit % 10) // 7-segment display control codes for ones unit
				0:		    DISP0 <= 7'b1000000;
				1:		    DISP0 <= 7'b1111001;
				2:		    DISP0 <= 7'b0100100;
				3:		    DISP0 <= 7'b0110000;
				4:		    DISP0 <= 7'b0011001;
				5:		    DISP0 <= 7'b0010010;
				6:		    DISP0 <= 7'b0000010;
				7:		    DISP0 <= 7'b1111000;
				8:		    DISP0 <= 7'b0000000;
				9:		    DISP0 <= 7'b0011000;
				default:	DISP0 <= 7'b0000111;
			endcase

			case (digit_tens / 10) // 7-segment display control codes for tens unit
				0:		    DISP1 <= 7'b1000000;
				1:		    DISP1 <= 7'b1111001;
				2:		    DISP1 <= 7'b0100100;
				3:		    DISP1 <= 7'b0110000;
				4:		    DISP1 <= 7'b0011001;
				5:		    DISP1 <= 7'b0010010;
				6:		    DISP1 <= 7'b0000010;
				7:		    DISP1 <= 7'b1111000;
				8:		    DISP1 <= 7'b0000000;
				9:		    DISP1 <= 7'b0011000;
				default:	DISP1 <= 7'b0000111;
			endcase
        end
    end

endmodule
