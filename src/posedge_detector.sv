`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo Gonzalez
// 
// Create Date: 09.01.2020 16:27:00
// Design Name: posedge detector
// Module Name: posedge_detector
// Project Name: digital_clock
// Target Devices: Nexys4 DDR
// Description: emits 1 clock cycle signal when rising edge detected 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: signal must be debounced first.
//                  
//////////////////////////////////////////////////////////////////////////////////


module posedge_detector(clk,rst,signal,detection);

	input logic clk, rst, signal;
	output logic detection;
	
	logic [1:0] flip_flops = 2'd0;
	
	always_ff@(posedge clk)
	begin
		if(rst)
			flip_flops <= 2'd0;
		else 	
			flip_flops <= {flip_flops[0],signal};
	end
	
	assign detection = (flip_flops[0]&&(~flip_flops[1]));


endmodule
