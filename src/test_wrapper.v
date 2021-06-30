`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo González
// Create Date: 16.09.2020 16:34
// Design Name: muon-daq
// Module Name: test_signals_emitter
// Project Name: muon-daq
// Target Devices: Trenz FPGA TE0720
// Tool Versions: Vivado 2019.1
// Description: Wrapper for test trigger and signals modules
//
//////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////
    // test_wrapper test_wrapper_inst(
    //         .clk(), //1 bit
    //         .aresetn(), //1 bit
    //         .start_i(), //1 bit
    //         .trigger_o(), //1 bit
    //         .signals_o() //15 bit array
    //     );
/////////////////////////////////////////

module  test_wrapper(
            input   clk,
            input   aresetn,
            input   start_i,
            output  trigger_o,
            output  [15:0] signals_o
        );

    // Sync start pulse
    wire synchronized_start;
    synchronizer sync_inst(
        .clk(clk),
        .aresetn(aresetn),
        .i_signal(start_i),
        .o_signal(synchronized_start)
    );

    wire sync_start_posedge;
    posedge_detector posedge_detector_inst(
        .clk(clk), 
        .aresetn(aresetn),
        .signal(synchronized_start),
        .detection(sync_start_posedge)
    );

    test_signals_emitter test_signals_emitter_inst(
            .clk(clk), //1 bit
            .aresetn(aresetn), //1 bit
            .start_i(sync_start_posedge), //1 bit
            .trigger_o(trigger_o), //1 bit
            .signals_o(signals_o) //15 bit array
        );

endmodule