`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo Gonzalez
// 
// Create Date: 24.09.2020 18:39
// Design Name: tb_event_saver
// Module Name: tb_event_saver
// Project Name: muon-daq
// Target Devices: Trenz FPGA TE0720
// Description: Test event_saver
// 
//                  
//////////////////////////////////////////////////////////////////////////////////

module tb_event_saver();

    logic clk, aresetn, event_saved, trigger, full_i, wr_en_o;
    logic [63:0] din_o;
    logic [15:0][63:0]evento;

    genvar i;
    generate
        for (i = 0; i<16 ; i++) 
            assign evento[i][63:0] = 64'd18014398508433408 - i;
    endgenerate

    initial begin
        clk = 1'b0;
        aresetn = 1'b1;
        trigger = 1'b0;
        full_i = 1'b0;
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
        #110 trigger = 1'b1;
        #2  trigger = 1'b0;
        #4  full_i = 1'b1;
        #84 trigger = 1'b1;
        #1  trigger = 1'b0;
        #1000;
	end

    event_saver test_event_saver_inst(
        .clk(clk),
        .aresetn(aresetn),
        .trigger(trigger),     //1 bit 
        //.state_i(),     //2bits
        .event_i(evento),     //64bits width 15bits depth
        .full_i(full_i),      //1 bit  
        .event_saved(event_saved), //1 bit
        .wr_en_o(wr_en_o),     //1 bit
        .din_o(din_o)        //64bits
    );

endmodule

