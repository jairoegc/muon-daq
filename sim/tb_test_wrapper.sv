`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo Gonzalez
// 
// Create Date: 24.09.2020 18:39
// Design Name: tb_test_wrapper
// Module Name: tb_test_wrapper
// Project Name: muon-daq
// Target Devices: Trenz FPGA TE0720
// Description: Test the test_wrapper
// 
//                  
//////////////////////////////////////////////////////////////////////////////////

module tb_test_wrapper();

    
    logic clk, aresetn, start, trigger_o;
    logic [15:0] signals_o;

    initial begin
        clk = 1'b0;
        aresetn = 1'b1;
        start = 1'b0;
        #2;
        aresetn = 1'b0;
        #2;
        aresetn = 1'b1;
        #4;
    end
    
    always 
        #1 clk = ~clk;

    always begin
        #1 
        #20 start = 1'd1;
        #2  start = 1'd0;
        #220 start = 1'd1;
        #2  start = 1'd0;
        #25000;
    end
    
    test_wrapper test_wrapper_inst(
            .clk(clk), //1 bit
            .aresetn(aresetn), //1 bit
            .start_i(start), //1 bit
            .trigger_o(trigger_o), //1 bit
            .signals_o(signals_o) //15 bit array
    );
endmodule

