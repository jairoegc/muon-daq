`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo Gonzalez
// 
// Create Date: 24.09.2020 18:39
// Design Name: synchronizer
// Module Name: synchronizer
// Project Name: sapler
// Target Devices: Trenz FPGA TE0712
// Description: emits 1 clock cycle signal when rising edge detected 
// 
//                  
//////////////////////////////////////////////////////////////////////////////////


module synchronizer(clk,rst,i_signal,o_signal);

	input logic clk, rst, i_signal;
	output logic o_signal;
	
	logic [1:0] flip_flops = 2'd0;
	
	always_ff@(posedge clk)
	begin
		if(rst)
			flip_flops <= 2'd0;
		else 	
			flip_flops <= {flip_flops[0],i_signal};
	end
	
	assign o_signal = flip_flops[0];


endmodule
