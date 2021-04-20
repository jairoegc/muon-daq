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


module  sampler#(
 parameter BUFFER=80,
 parameter BUFFER_WIDTH = $clog2(BUFFER)
 )(
            input   logic   clk_in1,
            // input   logic   reset,
            input   logic   event_saved,
            input   logic   [1:0][15:0][1:0]Ch,
            input   logic   trig_tresh,
            output  logic   event_ready,
            output  logic   [79:0] evento,
            //output  logic   B14_L13_P,   //Y18 J2-C23 ?
            output  logic   B15_IO25,    //U7 LED 4
            output  logic   B15_IO0    //R7 LED 3
        );

    logic rst = 'd0;
    //logic clk_125;
    logic clk_500;

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

    ////////// Secondary Clock /////////////////////////////////
    clk_divider #(
        .O_CLK_FREQ('d125_000_000)
        ) clk_divider_inst (
            .clk_in(clk_500),
	        .reset(rst),
	        .clk_out(clk_125)
    );

    /////////// Input LVDS //////////////////////////////
    logic lvds_output;
    // IBUFDS: Differential Input Buffer
    // 7 Series
    // Xilinx HDL Libraries Guide, version 13.4
    IBUFDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("LVDS_25") // Specify the input I/O standard
        ) IBUFDS_LVDS_25 (
        .O(lvds_output), // Buffer output
        .I(Ch[0][15][1]), // Diff_p buffer input (connect directly to top-level port)
        .IB(Ch[0][15][0]) // Diff_n buffer input (connect directly to top-level port)
    );
    // End of IBUFDS_inst instantiation


    ///////// Pulse Sync ////////////////////////////
    logic synchronized_pulse;
    posedge_detector sync_inst(
        .clk(clk_500),
        .rst(rst),
        .signal(~lvds_output),
        .detection(synchronized_pulse)
    );
    // synchronizer sync_inst(
    //     .clk(clk),
    //     .rst(rst),
    //     .i_signal(~lvds_output),
    //     .o_signal(synchronized_pulse)
    // );


    //Shift register 60 bits (deserializer)
    logic [69:0] shift_reg = 'd0;
    logic [69:0] shift_reg_next;

    always_comb begin
        shift_reg_next = {synchronized_pulse, shift_reg[69:1]};
    end

    always_ff @(posedge clk_500) begin
        if( rst )
            shift_reg <= 'd0;
        else
            shift_reg <= shift_reg_next;
    end

    // logic [4:0] shift_reg_125 = 'd0;
    // logic [4:0] shift_reg_125_next;

    // //Sync with 100MHz clk
    // always_comb begin
    //     shift_reg_125_next = shift_reg;
    // end

    // always_ff @(posedge clk_125) begin
    //     if( rst )
    //         shift_reg_125 <= 'd0;
    //     else
    //         shift_reg_125 <= shift_reg_125_next;
    // end


    // ///////// Pulse Buffer /////////////////////////
    // logic rd_en = 'd0;
    // logic [4:0] read_pulse;
    // fifo_generator_0 fifo_ch15 (
    //     .clk(clk_125),      // input wire clk
    //     .srst(rst),      // input wire rst
    //     .din(shift_reg_125),      // input wire [5 : 0] din
    //     .wr_en('d1),  // input wire wr_en
    //     .rd_en(rd_en),  // input wire rd_en
    //     .dout(read_pulse),    // output wire [5 : 0] dout
    //     .full(B15_IO25),    // output wire full
    //     .empty(B15_IO0)  // output wire empty
    // );
    
    // c_shift_ram_0 your_instance_name (
    //     .D(synchronized_pulse),      // input wire [0 : 0] D
    //     .CLK(clk_500),  // input wire CLK
    //     .SCLR(rst),  // input wire SCLR
    //     .Q(Q)      // output wire [0 : 0] Q
    // );

    // ///////// FSM /////////////////////// Para llenar la FIFO
    // enum logic {START, READ} state, state_next;
    
    // logic [BUFFER_WIDTH-1:0]     hold_state_delay;  //timer para retener la maquina de estados en un estado
    // logic                       hold_state_reset;  // resetear el timer para retener estado
    
    // always_comb begin
    //     state_next = START;
    //     rd_en = 'd0;
    //     hold_state_reset = 1'b1;

    //     case (state)
    //         START:  begin
    //                     hold_state_reset = 1'b0;
    //                     // Verifica si el timer alcanzo el valor predeterminado para este estado
    //                     if (hold_state_delay >= BUFFER-1) begin
    //                         state_next = READ;
    //                         hold_state_reset = 1'b1;
    //                     end 
    //                 end
    //         READ:   begin
    //                     state_next = READ;
    //                     rd_en = 'd1;                
    //                 end
    //     endcase
    // end

    // always_ff @(posedge clk_125) begin
    //     if(rst) 
    //         state <= START;
    //     else 
    //         state <= state_next;
    // end
    
    
    // always_ff @(posedge clk_125) begin
    //    if (rst || hold_state_reset) 
    //        hold_state_delay <= 'd0;
    //    else
    //        hold_state_delay <= hold_state_delay + 'd1;       
    // end

    //Evento completo - lectura
    enum logic [1:0] {STAND_BY, READING, WAITING} read_state, read_state_next;
    logic [79:0] evento_next;
    // logic [3:0]    sample_n;  //timer para retener la maquina de estados en un estado
    // logic          sample_n_reset;  // resetear el timer para retener estado

    always_comb begin
        read_state_next = STAND_BY;
        event_ready = 0;
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
                                event_ready = 'd1;
                                // sample_n_reset = 'd1;
                        end         
            WAITING:    begin
                            event_ready = 'd1;
                            if (~event_saved) begin
                                event_ready = 'd0;
                                read_state_next = WAITING;
                            end
                        end
        endcase
    end

    always_ff @(posedge clk_125) begin
        if(rst) begin
            read_state <= STAND_BY;
            evento <= 'd0;
        end
        else begin
            read_state <= read_state_next;
            evento <= evento_next;
        end
    end
    
    
    // always_ff @(posedge clk_500) begin
    //    if (rst || sample_n_reset) 
    //        sample_n <= 'd0;
    //    else
    //        sample_n <= sample_n + 'd1;       
    // end

    // //////// Counters
    // logic [7:0] pulse_counter = 'd0;
    // logic [7:0] pulse_counter_next = 'd0;

    // //Pulse Counter Logic
    // always_comb begin
    //     if (read_pulse)
    //         pulse_counter_next =  pulse_counter + 'd1;
    //     else
    //         pulse_counter_next = pulse_counter;
    // end


    // //FF
    // always_ff @ (posedge clk_100)
    //     pulse_counter <= pulse_counter_next;

    // ////////// ILA //////////////////////////////
    // ila_0 ILA_module (
    //     .clk(clk), // input wire clk



    //     .probe0(lvds_output), // input wire [0:0]  probe0  
    //     .probe1(synchronized_pulse), // input wire [0:0]  probe1 
    //     .probe2(read_pulse), // input wire [0:0]  probe2 
    //     .probe3(rd_en), // input wire [0:0]  probe3 
    //     .probe4(B15_IO25), // input wire [0:0]  probe4 
    //     .probe5(B15_IO0), // input wire [0:0]  probe5 
    //     .probe6(hold_state_reset), // input wire [0:0]  probe6 
    //     .probe7(hold_state_delay), // input wire [5:0]  probe7 
    //     .probe8(state_next), // input wire [0:0]  probe8 
    //     .probe9(state), // input wire [0:0]  probe9
    //     .probe10(pulse_counter)
    // );

endmodule
