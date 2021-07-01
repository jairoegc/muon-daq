`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo Gonzalez
// 
// Create Date: 24.09.2020 18:39
// Design Name: tb_synchronizer
// Module Name: tb_synchronizer
// Project Name: muon-daq
// Target Devices: Trenz FPGA TE0720
// Description: Test Synchronizer
// 
//                  
//////////////////////////////////////////////////////////////////////////////////

    module tb_sync_and_posedge();

    logic clk, aresetn, i_signal, aux_signal, o_signal;

    initial begin
        clk = 1'b0;
        aresetn = 1'b1;
        i_signal = 1'b0;
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
        #10 i_signal = 1'b1;
        
        #2 i_signal= 1'b0;		
        
        #2 i_signal = 1'b1;	
        
        #4 i_signal= 1'b0;				
        
        #2 i_signal = 1'b1;

        #10 i_signal = 1'b1;

	end
    
    synchronizer test_sync_inst(
        .clk(clk),
        .aresetn(aresetn),
        .i_signal(i_signal),
        .o_signal(aux_signal)
    );

    posedge_detector posedge_detector_inst(
        .clk(clk), 
        .aresetn(aresetn),
        .signal(aux_signal),
        .detection(o_signal)
    );

endmodule

