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
            input   logic   clk,
            input   logic   aresetn,
            input   logic   event_saved,
            input   logic   [15:0] Ch_A_P,
            //input   logic   [15:0] Ch_A_N,
            input   logic   trig_tresh,
            output  logic   [15:0][63:0] evento
        );

    //Acquisition
    logic [15:0][63:0] shift_reg = 'd0;
    logic [15:0][63:0] shift_reg_next;
    genvar i;
    generate
        for (i=0; i<16; i++) begin
            // /////////// Input LVDS //////////////////////////////
            // logic IBUF_output;
            // // IBUFDS: Differential Input Buffer
            // // 7 Series
            // // Xilinx HDL Libraries Guide, version 13.4
            // IBUFDS #(
            //     .DIFF_TERM("TRUE"), // Differential Termination
            //     .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
            //     .IOSTANDARD("LVDS_25") // Specify the input I/O standard
            //     ) IBUFDS_LVDS_25 (
            //     .O(IBUF_output), // Buffer output
            //     .I(Ch_A_P[i]), // Diff_p buffer input (connect directly to top-level port)
            //     .IB(Ch_A_N[i]) // Diff_n buffer input (connect directly to top-level port)
            // );  
            // // End of IBUFDS_inst instantiation

            ///////// Pulse Sync ////////////////////////////
            logic synchronized_pulse;
            synchronizer sync_inst(
                .clk(clk),
                .aresetn(aresetn),
                .i_signal(Ch_A_P[i]),
                .o_signal(synchronized_pulse)
            );

            //Shift register 64 bits (deserializer)
            always_comb begin
                shift_reg_next[i][63:0] = {synchronized_pulse, shift_reg[i][63:1]};
            end
            always_ff @(posedge clk, negedge aresetn) begin
                if( aresetn == 'b0)
                    shift_reg[i] <= 'd0;
                else
                    shift_reg[i] <= shift_reg_next[i];
            end
        end
    endgenerate

    //Discrimination
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
                            evento_next = evento;
                            if (~event_saved) begin
                                //event_ready = 'd1;
                                read_state_next = WAITING;
                            end
                        end
        endcase
    end

    always_ff @(posedge clk, negedge aresetn) begin
        if(aresetn == 'b0) begin
            read_state <= STAND_BY;
            evento <= 'd0;
        end
        else begin
            read_state <= read_state_next;
            evento <= evento_next;
        end
    end

endmodule
