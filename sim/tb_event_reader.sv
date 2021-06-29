`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo Gonzalez
// 
// Create Date: 24.09.2020 18:39
// Design Name: tb_event_reader
// Module Name: tb_event_reader
// Project Name: muon-daq
// Target Devices: Trenz FPGA TE0720
// Description: Test event_reader
// 
//                  
//////////////////////////////////////////////////////////////////////////////////

module tb_event_reader();

    logic clk, aresetn, empty_i, rd_en_o;
    logic   [7:0] cmd;
    logic   [63:0] dout_i;
    logic   [31:0] event_half_o;

    genvar i;
    generate
        for (i = 0; i<16 ; i++) 
            assign dout_i[63:0] = 64'd18014398508433408 - i;
    endgenerate

    initial begin
        clk = 1'b0;
        aresetn = 1'b1;
        empty_i = 1'b0;
        cmd[7:0] = 8'h0;
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
        #2  cmd = 8'h73;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #4  cmd = 8'h61;
        #4  cmd = 8'h62;
        #2  empty_i = 1'd1;
        #10  cmd = 8'h73;
        #10  cmd = 8'h6b;
        #1000;
	end

    event_reader test_event_reader_inst (
            .clk(clk),
            .aresetn(aresetn),
            //.state_i(),
            .cmd(cmd),
            .dout_i(dout_i),
            .empty_i(empty_i),
            //.event_read(),
            .rd_en_o(rd_en_o),
            .event_half_o(event_half_o)
        );

endmodule

