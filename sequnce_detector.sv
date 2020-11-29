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
    output  logic   [7:0] disp0, // ones digit
    output  logic   [7:0] disp1, // tens digit

    /* output signals */
    output  logic   z, // T/F sequence detection
    output  logic   count_detect // counter of times sequence was detected
);

    /* variable assignments */
    logic   [2:0] d_ff; // d flip-flop inputs
    logic   [2:0] q_ff; // d flip-flop outputs

    /* states */
    // 000 -> start
    // 001 -> first
    // 010 -> success
    // 011 -> second
    // 100 -> null -> error, go to start
    // 101 -> null -> error, go to start
    // 110 -> success_d
    // 111 -> delay
    typedef enum logic [2:0]
	{start, first, success, second, start, start, success_d, delay} statetype;
	statetype state, next_state;

    /* state register */
    always_ff begin
        if (rst) begin
           state <= start;
           count_detect <= 0;
        end
        else begin
           state <= next_state; 
           if (z) begin
               count_detect <= count_detect + 1;
           end
        end
    end

    /* next state logic */
    always_comb begin
        /* temporary but functional */
        /* case (state)
            start:
                if (sig_to_test) begin
                    z <= 0;
                    next_state = start;
                end else begin
                    z <= 0;
                    next_state = first;
                end
            first:
                if (sig_to_test) begin
                    z <= 0;
                    next_state = second;
                end else begin
                    z <= 0;
                    next_state = first;
                end   
            second:
                if (sig_to_test) begin
                    z <= 1;
                    next_state = success;
                end else begin
                    z <= 0;
                    next_state = delay;
                end    
            delay:
                if (sig_to_test) begin
                    z <= 1;
                    next_state = success_d;
                end else begin
                    z <= 0;
                    next_state = delay;
                end
            success_d:
                if (sig_to_test) begin
                    z <= 1;
                    next_state = success;
                end else begin
                    z <= 0;
                    next_state = delay;
                end
            success:
                if (sig_to_test) begin
                    z <= 0;
                    next_state = start;
                end else begin
                    z <= 0;
                    next_state = first;
                end
            default: // error, go to start
                next_state = start;
        endcase */

        assign d_ff[2] = (state[2] & state[0]) | (state[2] & sig_to_test) | (state[1] & state[0] & ~sig_to_test);
        assign d_ff[1] = (state[1] & state[0]) | (state[0] & sig_to_test) | state[2];
        assign d_ff[0] = (~state[1] & state[0]) | (~state[0] & ~sig_to_test) | (state[0] & ~sig_to_test);
    end

    /* output logic */
    assign z = (state[1] & state[0] & sig_to_test) | (state[2] & sig_to_test);

    /* sequence counter */
    always @(posedge clk) begin
        if (z) begin
            count_detect = count_detect + 1;
        end
    end

    /* 7-segment display control logic */
    always @(posedge clk) begin 
        if (rst) begin // reset signal goes high, set 7-segs to "00"
            disp0 = 7'b1000000;
            disp1 = 7'b1000000;
        end

        else if (ena) begin // enable signal high
            /* 7-segment display control codes for ones unit */
            case (count_detect % 10) // mod10 for units
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

            /* 7-segment display control codes for tens unit */
			case (count_detect / 10) // divide round down for tens
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
