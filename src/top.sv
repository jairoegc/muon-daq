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
            input   logic   clk_in1,
            // input   logic   reset,
            input   logic   trigger,
            input   logic   event_saved,
            input   logic   [1:0][15:0][1:0]Ch,
            output  logic   [31:0] test_salida
        );

    //////////// Main Clock /////////////////////////////////
    clk_wiz_0 clock_wiz_inst (
        // Clock out ports
        .clk_out1(clk_500),    // output clk_out1 500MHz
        // Status and control signals
        .reset(rst),          // input reset
        .locked(locked),        // output locked
        // Clock in ports
        .clk_in1(clk_in1))      // input clk_in1
    ; 

        
    logic   [15:0][63:0] evento;
    sampler sampler_1 (
        .clk_500(clk_500),
        .event_saved(event_saved),
        .Ch(Ch),
        .trig_tresh(trigger),
        .evento(evento)
    );

        assign test_salida[31:0] = evento[15][31:0];
endmodule