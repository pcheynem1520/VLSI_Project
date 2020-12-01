//=========================================================
// EELE 4054: Digital VLSI Design
// Authors: Temiloluwa Awe, PJ Cheyne-Miller
// Date: Nov. 11, 2020
// Description: A Mealy Finite State Machine state detector
// 
// Searches for a series of binary inputs that satisfies
// 01[0*]1, where 0* is any number of zeros. A 7-segment
// display will count the number of times 01[0*]1 is
// found in a sequence.
// 
// TESTBENCH FILE
// 
//=========================================================

`timescale 1ns/1ns

/* testbench signals */
module project_TB;
    /* circuit control signals */
    logic   CLOCK; // clock signal
    logic   RESET; // reset 
    logic   ENABLE; // enable 

    /* input signals */
    logic   SIGNAL_IN; // input signal to be tested for 01[0*]1

    /* 7-segment display signals */
    logic   [6:0] DISP0; // ones digit of loaded number
    logic   [6:0] DISP1; // tens digit of loaded number

    /* ouput signals */
    logic   SEQUENCE_FLAG; // flag triggered when sequence is detected

    /* variables */
    logic   SEQUENCE_COUNTER; // number of times sequence is found between resets

    /* instantiation of uut */
    sequence_detector uut(
        .clk (CLOCK), 
        .rst (RESET), 
        .ena (ENABLE), 

        .sig_to_test (SIGNAL_IN), 

        .disp0 (DISP0), 
        .disp1 (DISP1), 

        .z (SEQUENCE_FLAG)
    );

    /* test signal */
    logic   [0:23] TEST_SIG = 24'b000100110001011101010011; // LSB -> MSB for readability of passing signal

    /* initialize clock signal */
    initial begin
        CLOCK = 1'b1; // start clock signal high
    end

    /* start clock signal */
    always begin
            #5 CLOCK = ~CLOCK; // 100MHz,  10ns for posedge -> posedge
    end
 
    /* runtime signals */
    initial begin
        /* initialisation */
        RESET <= 1'b1; // set:0, reset:1
        ENABLE <= 1'b1; // disable counter: 0, enable counter: 1
        #10 // wait 10ns/1 clock cycles
        RESET <= 1'b0; // set:0, reset:1

        /* send test signal */
        SIGNAL_IN <= TEST_SIG[0];   #10
        SIGNAL_IN <= TEST_SIG[1];   #10
        SIGNAL_IN <= TEST_SIG[2];   #10
        SIGNAL_IN <= TEST_SIG[3];   #10
        SIGNAL_IN <= TEST_SIG[4];   #10
        SIGNAL_IN <= TEST_SIG[5];   #10
        SIGNAL_IN <= TEST_SIG[6];   #10
        SIGNAL_IN <= TEST_SIG[7];   #10
        SIGNAL_IN <= TEST_SIG[8];   #10
        SIGNAL_IN <= TEST_SIG[9];   #10
        SIGNAL_IN <= TEST_SIG[10];  #10
        SIGNAL_IN <= TEST_SIG[11];  #10
        SIGNAL_IN <= TEST_SIG[12];  #10
        SIGNAL_IN <= TEST_SIG[13];  #10
        SIGNAL_IN <= TEST_SIG[14];  #10
        SIGNAL_IN <= TEST_SIG[15];  #10
        SIGNAL_IN <= TEST_SIG[16];  #10
        SIGNAL_IN <= TEST_SIG[17];  #10
        SIGNAL_IN <= TEST_SIG[18];  #10
        SIGNAL_IN <= TEST_SIG[19];  #10
        SIGNAL_IN <= TEST_SIG[20];  #10
        SIGNAL_IN <= TEST_SIG[21];  #10
        SIGNAL_IN <= TEST_SIG[22];  #10
        SIGNAL_IN <= TEST_SIG[23];  #10

        /* halt */
        #20 // ensure that all singals are in final position
        RESET <= 1'b1; // set:0, reset:1
        ENABLE <= 1'b0; // disable counter: 0, enable counter: 1
    end 

endmodule 
