`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo González

// Create Date: 16.09.2020 16:34
// Design Name: sampler
// Module Name: sampler
// Project Name: muon-daq
// Target Devices: Trenz FPGA
// Tool Versions: Vivado 2019.1
// Description: Capture LVDS pulses at B16_L22 P & N, and emits them at 
//      B14_L13_P as TTL pulses after an arbitrary delay.
//     clk_in1: sys diff clk at 100MHz
//     B16_L22: diff input port
//     B13_L9: single ended output port
//     B15_IO0: empty buffer status led
//     B15_IO25: full buffer status led
//  Behavior: Captures a pulse saving it continuously in a FIFO buffer. At 
//      firt, during BUFFER clock cycles, the pulse is buffered. After that 
//      delay, it starts reading, emitting the FIFO content at the single 
//      endend output port.
// 
//////////////////////////////////////////////////////////////////////////////

module  top_wrapper(
            input   clk_500,
            input   clk_125,
            input   rst,
            input   trigger,
            input   [15:0] Ch_A_P,
            input   [15:0] Ch_A_N,
            input   [7:0] cmd,
            input   [63:0] dout_i,
            input   empty_i,
            input   full_i,
            output  rd_en_o,            
            output  wr_en_o,
            output  [63:0] din_o,
            output  [31:0] event_half_o
        );

    top top_inst(
            .clk_500(clk_500),
            .clk_125(clk_125),
            .rst(rst),
            .trigger(trigger),
            .Ch_A_P(Ch_A_P[15:0]),
            .Ch_A_N(Ch_A_N[15:0]),
            .cmd(cmd[7:0]),
            .dout_i(dout_i[63:0]),
            .empty_i(empty_i),
            .full_i(full_i),
            .rd_en_o(rd_en_o),            
            .wr_en_o(wr_en_o),
            .din_o(din_o[63:0]),
            .event_half_o(event_half_o[31:0])
        );
    

endmodule