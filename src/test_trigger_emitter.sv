`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo González
// Create Date: 16.09.2020 16:34
// Design Name: muon-daq
// Module Name: test_trigger_emitter
// Project Name: muon-daq
// Target Devices: Trenz FPGA TE0720
// Tool Versions: Vivado 2019.1
// Description: Emit a trigger signal of 1 cycle after an arbitrary number of 
//              clock cycles.
// 
//////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////
// test_trigger_emitter test_trigger_emitter_inst(
//             .clk(), //1 bit
//             .aresetn(), //1 bit
//             .start_i(), //1 bit
//             .trigger_o() //1 bit
//         );

/////////////////////////////////////////

module  test_trigger_emitter(
            input   logic   clk,
            input   logic   aresetn,
            input   logic   start_i,
            output  logic   trigger_o
        );

    // Trigger counter parameters and variables
    localparam TRIGGER_COUNTER_MAX = 'd48;
    localparam TRIGGER_COUNTER_WIDTH = $clog2(TRIGGER_COUNTER_MAX);

    logic [TRIGGER_COUNTER_WIDTH-1:0] trigger_counter;
    logic trigger_counter_reset;

    // Trigger simulator FSM
    enum logic [1:0] {STANDBY, COUNTING, EMIT}  trigger_state, trigger_state_next;

    always_comb begin : Trigger_FSM
        trigger_state_next = STANDBY;
        trigger_counter_reset = 1'b1;
        case (trigger_state)
            STANDBY:    begin
                            if (start_i)
                                trigger_state_next = COUNTING;
                        end
            COUNTING:   begin
                            trigger_state_next = COUNTING;
                            trigger_counter_reset = 1'b0;
                            if (trigger_counter>=TRIGGER_COUNTER_MAX-1) begin
                                trigger_state_next  = EMIT;
                                trigger_counter_reset = 1'b1;
                            end
                        end 
            EMIT:       begin                            
                            trigger_state_next = STANDBY;  
                        end
        endcase
    end

    always_ff @(posedge clk, negedge aresetn) begin
        if(aresetn == 'b0) 
            trigger_state <= STANDBY;
        else 
             trigger_state <=  trigger_state_next;
    end

    always_ff @(posedge clk, negedge aresetn) begin
        if ((aresetn == 'b0) || trigger_counter_reset) 
            trigger_counter <= 'd0;
        else
            trigger_counter <= trigger_counter + 'd1;       
    end

    // Trigger
    logic trigger = 0;
    logic trigger_next;
    assign trigger_o = trigger;

    always_comb begin
        if (trigger_state == EMIT)
            trigger_next = 1'b1;
        else
            trigger_next = 1'b0;
    end

    always_ff @(posedge clk, negedge aresetn) begin
        if ((aresetn == 'b0)) 
            trigger <= 'd0;
        else
            trigger <= trigger_next;
    end
    

endmodule