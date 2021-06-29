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
    localparam COUNTER_MAX = 'd16;
    localparam COUNTER_WIDTH = $clog2(COUNTER_MAX);

    enum logic [3:0] {STANDBY, SEND_A, HOLD_A, SEND_B, HOLD_B, EMPTY}  state, state_next;
    
    //assign state_o = state;

    logic [COUNTER_WIDTH-1:0]   sent_channel_counter;  //Keeps count of channels already sent
    logic [COUNTER_WIDTH-1:0]   sent_channel_counter_next;
    logic                       sent_channel_counter_reset;  //reset counter

    always_comb begin : FSM
        state_next = STANDBY;
        sent_channel_counter_reset = 1'b1;
        rd_en_o = 'd0;
        sent_channel_counter_next = sent_channel_counter;
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
                            sent_channel_counter_reset = 1'b0;
                        end
            HOLD_A:     begin
                            state_next = HOLD_A;
                            sent_channel_counter_reset = 1'b0;
                            if (cmd==8'h62) //ASCII b, event part B
                                state_next = SEND_B;
                        end

            SEND_B:     begin
                            state_next = HOLD_B;
                            sent_channel_counter_reset = 1'b0;
                            
                        end
            HOLD_B:     begin
                            state_next = HOLD_B;
                            sent_channel_counter_reset = 1'b0;
                            if (sent_channel_counter>=COUNTER_MAX-1) begin
                                state_next = STANDBY;
                                sent_channel_counter_reset = 1'b1;
                            end 
                            else if (cmd==8'h61) begin//ASCII a, event part A                                
                                sent_channel_counter_next = sent_channel_counter + 1;
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

    always_ff @(posedge clk) begin
        if(aresetn == 'b0) 
            state <= STANDBY;
        else 
            state <= state_next;
    end
    
    
    always_ff @(posedge clk) begin
       if ((aresetn == 'b0) || sent_channel_counter_reset) 
           sent_channel_counter <= 'd0;
       else
           sent_channel_counter <= sent_channel_counter_next;       
    end


    //////////READER
    logic [31:0] event_half = 'd0;
    logic [31:0] event_half_next;
    logic [31:0] event_half_next_next;

    always_comb begin : saver
        event_half_next = 'd0;
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

    always_ff @( posedge clk ) begin
        if(aresetn == 'b0) 
            event_half <= 'd0;
        else 
            event_half <= event_half_next;
        
    end

    assign event_half_o = event_half;
    
endmodule