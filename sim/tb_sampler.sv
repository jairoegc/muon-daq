`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo Gonzalez
// 
// Create Date: 24.09.2020 18:39
// Design Name: tb_sampler
// Module Name: tb_sampler
// Project Name: muon-daq
// Target Devices: Trenz FPGA TE0720
// Description: Test sampler
// 
//                  
//////////////////////////////////////////////////////////////////////////////////

    module tb_sampler();

    logic clk, aresetn, event_saved, trigger;
    logic [15:0] channel, Ch_A_P, Ch_A_N;
    logic [15:0][63:0]evento;

    genvar i;
    generate
        for (i = 0; i<16 ; i++) begin
            OBUFDS #(   
			.IOSTANDARD("LVCMOS33")   
			) OBUFDS_inst (   
			.O(Ch_A_P[i]), 
			.OB(Ch_A_N[i]), 
			.I(channel[i]) 
			);	
        end	
    endgenerate

    initial begin
        clk = 1'b0;
        aresetn = 1'b1;
        trigger = 1'b0;
        event_saved = 1'b0;
        channel[15:0] = 16'b0;
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
        #10 channel[0] = 1'b1;
        #48 channel[0]= 1'b0;
        #42 channel[0] = 1'b1;
        #48 channel[0] = 1'b0;
        #1000;
	end

    always begin
        #1
        #110 trigger = 1'b1;
        #2  trigger = 1'b0;
        #88  trigger = 1'b1;
        #1  trigger = 1'b0;
        #1000;
	end

    always begin
        #1
        #300 event_saved = 1'b1;
        #2  event_saved = 1'b0;
        #1000;
	end

    sampler test_sampler_inst(
            .clk(clk),
            .aresetn(aresetn),
            .event_saved(event_saved),
            .Ch_A_P(Ch_A_P[15:0]),
            .Ch_A_N(Ch_A_N[15:0]),
            .trig_tresh(trigger),
            .evento(evento)
        );

endmodule

