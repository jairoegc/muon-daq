`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo Gonzalez
// 
// Create Date: 24.09.2020 18:39
// Design Name: synchronizer
// Module Name: synchronizer
// Project Name: sampler
// Target Devices: Trenz FPGA TE0720
// Description: Sync input signal with clk
// 
//                  
//////////////////////////////////////////////////////////////////////////////////


module synchronizer(clk,aresetn,i_signal,o_signal);

	input logic clk, aresetn, i_signal;
	output logic o_signal;
	
	logic [1:0] flip_flops = 2'd0;
	logic [1:0] flip_flops_next;
	
	always_comb begin
		flip_flops_next[1:0] = {flip_flops[0],i_signal};
	end

	always_ff@(posedge clk, negedge aresetn)
	begin
		if(aresetn == 'b0)
			flip_flops <= 2'd0;
		else 	
			flip_flops <= flip_flops_next;
	end
	
	assign o_signal = flip_flops[1];


endmodule
