`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo González
// Create Date: 16.09.2020 16:34
// Design Name: muon-daq
// Module Name: event_reader
// Project Name: muon-daq
// Target Devices: Trenz FPGA TE0720
// Tool Versions: Vivado 2019.1
// Description: 
//     
//  Behavior: 
// 
//////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////
// event_reader event_reader_inst(
            // .clk(),
            // .aresetn(),
            // //.state_i(),
            // .cmd(),
            // .dout_i(),
            // .empty_i(),
            // //.event_read(),
            // .rd_en_o(),
            // .event_half_o()
//     );
/////////////////////////////////////////

module  event_reader(
            input   logic   clk,
            input   logic   aresetn,
            //input   state_t [1:0] state_i,
            input   logic   [7:0] cmd,
            input   logic   [63:0] dout_i,
            input   logic   empty_i,
            //output  logic   event_read,
            output  logic   rd_en_o,
            output  logic   [31:0] event_half_o
        );
    
    //////////////////// FSM
    enum logic [3:0] {STANDBY, SEND_A, HOLD_A, SEND_B, HOLD_B, EMPTY}  state, state_next;
    
    always_comb begin : FSM
        state_next = STANDBY;
        rd_en_o = 'd0;
        case (state)
            STANDBY:    begin
                            if(cmd==8'h73) //ASCII s, start
                                if (~empty_i) begin
                                    state_next = SEND_A;
                                    rd_en_o = 'd1;
                                end
                                else
                                    state_next = EMPTY;
                        end

            SEND_A:       begin
                            state_next = HOLD_A;
                        end
            HOLD_A:     begin
                            state_next = HOLD_A;
                            if (cmd==8'h62) //ASCII b, event part B
                                state_next = SEND_B;
                        end

            SEND_B:     begin
                            state_next = HOLD_B;                            
                        end
            HOLD_B:     begin
                            state_next = HOLD_B;
                            if (cmd==8'h64) begin//ASCII d, Done.
                                state_next = STANDBY;
                            end 
                            else if (cmd==8'h61) begin//ASCII a, event part A        
                                rd_en_o = 'd1;
                                state_next = SEND_A;
                            end
                        end
            EMPTY:      begin
                            state_next = EMPTY;
                            if(cmd==8'h6b) //ASCII k, Acknowledgement
                                state_next = STANDBY;             
                        end
        endcase
    end

    always_ff @(posedge clk, negedge aresetn) begin
        if(aresetn == 'b0) 
            state <= STANDBY;
        else 
            state <= state_next;
    end
    
    //////////READER
    logic [31:0] event_half = 'd0;
    logic [31:0] event_half_next;
    logic [31:0] event_half_next_next;

    always_comb begin : saver
        event_half_next = 'hAAAAAAAAAAAAAAAA;
        //event_half_next_next = ;
        case (state)
            SEND_A:     begin
                            event_half_next[31:0] = dout_i[63:32];
                            //event_half_next_next[31:0] = dout_i[31:0];
                        end
            HOLD_A:     begin
                            event_half_next[31:0] = event_half;
                        end           
            SEND_B:     begin
                            event_half_next[31:0] = dout_i[31:0];
                        end
            HOLD_B:     begin
                            event_half_next[31:0] = event_half;
                        end
            EMPTY:      begin
                            event_half_next[31:0] = 'h65; //ASCII e, empty
                        end
        endcase
    end

    always_ff @( posedge clk, negedge aresetn ) begin
        if(aresetn == 'b0) 
            event_half <= 'd0;
        else 
            event_half <= event_half_next;
    end

    assign event_half_o = event_half;
    
endmodule