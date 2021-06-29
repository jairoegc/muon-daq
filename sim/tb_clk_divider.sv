`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo Gonzalez
// 
// Create Date: 24.09.2020 18:39
// Design Name: tb_clk_divider
// Module Name: tb_clk_divider
// Project Name: muon-daq
// Target Devices: Trenz FPGA TE0720
// Description: Test clk_divider
// 
//                  
//////////////////////////////////////////////////////////////////////////////////

    module tb_clk_divider();

    logic clk, aresetn, clk_out;

    initial begin
        clk = 1'b0;
        aresetn = 1'b1;
        #2;
        aresetn = 1'b0;
        #2;
        aresetn = 1'b1;
        #4;
    end
    
    always 
        #1 clk = ~clk;
    
    clk_divider #(.O_CLK_FREQ(100_000_000)) test_clk_divider(
        .clk_in(clk),
        .aresetn(aresetn),
        .clk_out(clk_out)
    );

endmodule

