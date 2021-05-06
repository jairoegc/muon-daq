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


module  sampler(
            input   logic   clk_500,
            // input   logic   reset,
            input   logic   event_saved,
            input   logic   [1:0][15:0][1:0]Ch,
            input   logic   trig_tresh,
            //output  logic   event_ready,
            output  logic   [15:0][63:0] evento
            //output  logic   B14_L13_P,   //Y18 J2-C23 ?
            //output  logic   B15_IO25,    //U7 LED 4
            //output  logic   B15_IO0    //R7 LED 3
        );

    logic rst = 'd0;
    logic clk_500;

    /////////// Input LVDS //////////////////////////////
    logic lvds_output_15;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_15 (
        .O(lvds_output_15), // Buffer output
        .I(Ch[0][15][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][15][0]) // Diff_n buffer input (connect directly to top-level port)
    );
    // End of IBUFDS_inst instantiation

    logic lvds_output_14;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_14 (
        .O(lvds_output_14), // Buffer output
        .I(Ch[0][14][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][14][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_13;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_13 (
        .O(lvds_output_13), // Buffer output
        .I(Ch[0][13][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][13][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_12;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_12 (
        .O(lvds_output_12), // Buffer output
        .I(Ch[0][12][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][12][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_11;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_11 (
        .O(lvds_output_11), // Buffer output
        .I(Ch[0][11][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][11][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_10;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_10 (
        .O(lvds_output_10), // Buffer output
        .I(Ch[0][10][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][10][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_9;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_9 (
        .O(lvds_output_9), // Buffer output
        .I(Ch[0][9][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][9][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_8;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_8 (
        .O(lvds_output_8), // Buffer output
        .I(Ch[0][8][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][8][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_7;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_7 (
        .O(lvds_output_7), // Buffer output
        .I(Ch[0][7][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][7][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_6;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_6 (
        .O(lvds_output_6), // Buffer output
        .I(Ch[0][6][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][6][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_5;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_5 (
        .O(lvds_output_5), // Buffer output
        .I(Ch[0][5][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][5][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_4;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_4 (
        .O(lvds_output_4), // Buffer output
        .I(Ch[0][4][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][4][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_3;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_3 (
        .O(lvds_output_3), // Buffer output
        .I(Ch[0][3][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][3][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_2;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_2 (
        .O(lvds_output_2), // Buffer output
        .I(Ch[0][2][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][2][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_1;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_1 (
        .O(lvds_output_1), // Buffer output
        .I(Ch[0][1][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][1][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    logic lvds_output_0;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25_0 (
        .O(lvds_output_0), // Buffer output
        .I(Ch[0][0][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][0][0]) // Diff_n buffer input (connect directly to top-level port)
    );

    ///////// Pulse Sync ////////////////////////////
    logic synchronized_pulse_15;
    posedge_detector sync_inst_15(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_15),
        .detection(synchronized_pulse_15)
    );

    logic synchronized_pulse_14;
    posedge_detector sync_inst_14(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_14),
        .detection(synchronized_pulse_14)
    );

    logic synchronized_pulse_13;
    posedge_detector sync_inst_13(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_13),
        .detection(synchronized_pulse_13)
    );

    logic synchronized_pulse_12;
    posedge_detector sync_inst_12(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_12),
        .detection(synchronized_pulse_12)
    );

    logic synchronized_pulse_11;
    posedge_detector sync_inst_11(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_11),
        .detection(synchronized_pulse_11)
    );

    logic synchronized_pulse_10;
    posedge_detector sync_inst_10(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_10),
        .detection(synchronized_pulse_10)
    );

    logic synchronized_pulse_9;
    posedge_detector sync_inst_9(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_9),
        .detection(synchronized_pulse_9)
    );

    logic synchronized_pulse_8;
    posedge_detector sync_inst_8(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_8),
        .detection(synchronized_pulse_8)
    );

    logic synchronized_pulse_7;
    posedge_detector sync_inst_7(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_7),
        .detection(synchronized_pulse_7)
    );

    logic synchronized_pulse_6;
    posedge_detector sync_inst_6(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_6),
        .detection(synchronized_pulse_6)
    );

    logic synchronized_pulse_5;
    posedge_detector sync_inst_5(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_5),
        .detection(synchronized_pulse_5)
    );

    logic synchronized_pulse_4;
    posedge_detector sync_inst_4(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_4),
        .detection(synchronized_pulse_4)
    );

    logic synchronized_pulse_3;
    posedge_detector sync_inst_3(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_3),
        .detection(synchronized_pulse_3)
    );

    logic synchronized_pulse_2;
    posedge_detector sync_inst_2(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_2),
        .detection(synchronized_pulse_2)
    );

    logic synchronized_pulse_1;
    posedge_detector sync_inst_1(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_1),
        .detection(synchronized_pulse_1)
    );

    logic synchronized_pulse_0;
    posedge_detector sync_inst_0(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output_0),
        .detection(synchronized_pulse_0)
    );


    //Shift register 60 bits (deserializer)
    logic [15:0][63:0] shift_reg = 'd0;
    logic [15:0][63:0] shift_reg_next;

    always_comb begin
        shift_reg_next[15][63:0] = {synchronized_pulse_15, shift_reg[15][63:1]};
        shift_reg_next[14][63:0] = {synchronized_pulse_14, shift_reg[14][63:1]};
        shift_reg_next[13][63:0] = {synchronized_pulse_13, shift_reg[13][63:1]};
        shift_reg_next[12][63:0] = {synchronized_pulse_12, shift_reg[12][63:1]};
        shift_reg_next[11][63:0] = {synchronized_pulse_11, shift_reg[11][63:1]};
        shift_reg_next[10][63:0] = {synchronized_pulse_10, shift_reg[10][63:1]};
        shift_reg_next[9][63:0] = {synchronized_pulse_9, shift_reg[9][63:1]};
        shift_reg_next[8][63:0] = {synchronized_pulse_8, shift_reg[8][63:1]};
        shift_reg_next[7][63:0] = {synchronized_pulse_7, shift_reg[7][63:1]};
        shift_reg_next[6][63:0] = {synchronized_pulse_6, shift_reg[6][63:1]};
        shift_reg_next[5][63:0] = {synchronized_pulse_5, shift_reg[5][63:1]};
        shift_reg_next[4][63:0] = {synchronized_pulse_4, shift_reg[4][63:1]};
        shift_reg_next[3][63:0] = {synchronized_pulse_3, shift_reg[3][63:1]};
        shift_reg_next[2][63:0] = {synchronized_pulse_2, shift_reg[2][63:1]};
        shift_reg_next[1][63:0] = {synchronized_pulse_1, shift_reg[1][63:1]};
        shift_reg_next[0][63:0] = {synchronized_pulse_0, shift_reg[0][63:1]};
    end

    always_ff @(posedge clk_500) begin
        if( rst )
            shift_reg <= 'd0;
        else
            shift_reg <= shift_reg_next;
    end

    //Evento completo - lectura
    enum logic [1:0] {STAND_BY, READING, WAITING} read_state, read_state_next;
    logic [15:0][63:0] evento_next;
    // logic [3:0]    sample_n;  //timer para retener la maquina de estados en un estado
    // logic          sample_n_reset;  // resetear el timer para retener estado

    always_comb begin
        read_state_next = STAND_BY;
        //event_ready = 0;
        // sample_n_reset = 1;
        evento_next = 'd0;
        case (read_state)
            STAND_BY:   begin
                            if(trig_tresh)
                                read_state_next = READING;                     
                        end 
            READING:    begin
                                evento_next = shift_reg;
                                read_state_next = WAITING;
                                //event_ready = 'd1;
                                // sample_n_reset = 'd1;
                        end         
            WAITING:    begin
                            if (~event_saved) begin
                                //event_ready = 'd1;
                                read_state_next = WAITING;
                            end
                        end
        endcase
    end

    always_ff @(posedge clk_500) begin
        if(rst) begin
            read_state <= STAND_BY;
            evento <= 'd0;
        end
        else begin
            read_state <= read_state_next;
            evento <= evento_next;
        end
    end

endmodule
