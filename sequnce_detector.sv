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
    logic   [2:0] d_ff; // d flip-flop inputs
    logic   [2:0] q_ff; // d flip-flop outputs
    integer count_detect = 0; // counter of times sequence was detected

    /* state register */
    typedef enum logic [2:0]
	{start, first, success, second, unused_0, unused_1, success_delay, delay} statetype;
	statetype state, next_state;
    /* states */
    // 000 -> start
    // 001 -> first
    // 011 -> second
    // 111 -> delay
    // 110 -> success_delay
    // 010 -> success
    // 100 -> null -> error, go to start
    // 101 -> null -> error, go to start

    /* state switch logic */
    always @(posedge clk) begin
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

    /* next_state logic */
    always_comb begin
        /* next-state swtich statement */
        case (state)
            start:
                if (sig_to_test) begin
                    next_state = start;
                end else begin
                    next_state = first;
                end
            first:
                if (sig_to_test) begin
                    next_state = second;
                end else begin
                    next_state = first;
                end
            second:
                if (sig_to_test) begin
                    next_state = success;
                end else begin
                    next_state = delay;
                end
            delay:
                if (sig_to_test) begin
                    next_state = success_delay;
                end else begin
                    next_state = delay;
                end
            success_delay:
                if (sig_to_test) begin
                    next_state = success;
                end else begin
                    next_state = delay;
                end
            success:
                if (sig_to_test) begin
                    next_state = start;
                end else begin
                    next_state = first;
                end
            default: next_state = start;
        endcase
        /* combinational next-state logic */
        /*
        next_state[2] <= (state[1] & state[0] & ~sig_to_test) | (state[2] & ~sig_to_test) | (state[2] & state[0]);
        next_state[1] <= (state[0] & sig_to_test) | (state[1] & state[0]) | (state[2]);
        next_state[0] <= (~state[1] & state[0] & sig_to_test) | (state[1] & state[0] & ~sig_to_test) | (state[2] & ~state[0]);
        */
    end

    /* flip-flop input logic */
    always_comb begin
        d_ff[2] <= (state[2] & state[0]) | (state[2] & sig_to_test) | (state[1] & state[0] & ~sig_to_test);
        d_ff[1] <= (state[1] & state[0]) | (state[0] & sig_to_test) | state[2];
        d_ff[0] <= ~sig_to_test | (~state[1] & state[0]);
    end

    /* D flip-flops */
    always @(posedge clk) begin
        q_ff[2] <= d_ff[2];
        q_ff[1] <= d_ff[1];
        q_ff[0] <= d_ff[0];
    end

    /* output logic */
    always_comb begin
        z <= (state[1] & state[0] & sig_to_test) | (state[2] & sig_to_test);
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
