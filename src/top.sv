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

module  top(
            input   logic   f500_clk,
            input   logic   f125_clk,
            input   logic   aresetn,
            input   logic   trigger,
            input   logic   [15:0] Ch_A_P,
            input   logic   [15:0] Ch_A_N,
            input   logic   [7:0] cmd,
            input   logic   [63:0] dout_i,
            input   logic   empty_i,
            input   logic   full_i,
            output  logic   rd_en_o,            
            output  logic   wr_en_o,
            output  logic   [63:0] din_o,
            output  logic   [31:0] event_half_o
        );

    // // // FFs stage for reset signal, just for better timing performance
    // logic [15:0] ff_aresetn, ff_aresetn_next;
    // always_comb begin
    //     ff_aresetn_next = {aresetn,ff_aresetn[15:1]};
    // end

    // always_ff@(posedge f500_clk) begin
    //     ff_aresetn <= ff_aresetn_next;
    // end


    //// Modules instantation
    logic [63:0] evento[15:0];
    sampler sampler_inst(
        .clk(f500_clk),
        .aresetn(aresetn),
        .event_saved(event_saved),
        .Ch_A_P(Ch_A_P[15:0]),
        .Ch_A_N(Ch_A_N[15:0]),
        .trig_tresh(trigger),
        .event_ready(event_ready),
        .evento(evento) // Unpacked array of 15 64bits packed vectors
    );

    event_saver event_saver_inst(
        .clk(f125_clk),
        .aresetn(aresetn),
        .event_i(evento),     // Unpacked array of 15 64bits packed vectors
        .full_i(full_i),      //1 bit
        .event_ready_i(event_ready),  //1 bit
        .event_saved(event_saved), //1 bit
        .wr_en_o(wr_en_o),     //1 bit
        .din_o(din_o[63:0])        //64bits
    );

    event_reader event_reader_inst(
        .clk(f125_clk),
        .aresetn(aresetn),
        .cmd(cmd[7:0]),
        .dout_i(dout_i[63:0]),
        .empty_i(empty_i),
        .rd_en_o(rd_en_o),
        .event_half_o(event_half_o[31:0])
    );

endmodule