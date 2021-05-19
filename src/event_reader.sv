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
//         .clk(),
//         .rst(),
//         //.state_i(),      //2bits
//         .event_o(),      //64bits width 15bits depth
//         .empty_i(),      //1 bit
//         .event_read(),   //1 bit
//         .rd_en_o(),      //1 bit
//         .dout_i()        //64bits
//     );
/////////////////////////////////////////

module  event_reader(
            input   logic   clk,
            input   logic   rst,
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

    enum logic [2:0] {STANDBY, READ, SEND_1, SEND_2, EMPTY}  state, state_next;
    
    //assign state_o = state;

    logic [COUNTER_WIDTH-1:0]   hold_state_delay;  //timer para retener la maquina de estados en un estado
    logic                       hold_state_reset;  // resetear el timer para retener estado

    always_comb begin : FSM

        state_next = STANDBY;
        hold_state_reset = 1'b1;

        case (state)
            STANDBY:    begin
                            if(cmd==8'h73)
                                if (~empty_i)
                                    state_next = READ;
                                else
                                    state_next = EMPTY;
                        end

            READ:       begin
                            state_next = SEND_1;
                            hold_state_reset = 1'b0;
                            if (hold_state_delay>=COUNTER_MAX-1) begin
                                state_next = STANDBY;
                                hold_state_reset = 1'b1;         
                            end 
                        end

            SEND_1:     begin
                            state_next = SEND_1;
                            if(cmd==8'h6E)
                                state_next = SEND_2;
                        end

            SEND_2:     begin
                            state_next = SEND_2;
                            if(cmd==8'h6E)
                                state_next = READ;
                        end
            EMPTY:      begin
                            state_next = EMPTY;
                            if(cmd==8'h6E)
                                state_next = STANDBY;             
                        end
        endcase
        
    end

    always_ff @(posedge clk) begin
        if(rst) 
            state <= STANDBY;
        else 
            state <= state_next;
    end
    
    
    always_ff @(posedge clk) begin
       if (rst || hold_state_reset) 
           hold_state_delay <= 'd0;
       else
           hold_state_delay <= hold_state_delay + 'd1;       
    end


    //////////READER
    logic [31:0] event_half = 'd0;
    logic [31:0] event_half_next;

    always_comb begin : saver
        event_half_next = 'd0;
        rd_en_o = 'd0;
        case (state)
            READ:       begin
                            rd_en_o = 'd1; // Duda, la salida queda fija en la fifo despues de bajar el flag? 
                        end

            SEND_1:     begin
                            event_half_next[31:0] = dout_i[63:32];
                        end
            SEND_2:     begin
                            event_half_next[31:0] = dout_i[31:0];
                        end
            EMPTY:      begin
                            event_half_next[31:0] = 'h65; //ASCII e, empty
                        end
        endcase
    end

    always_ff @( posedge clk ) begin
        if(rst) 
            event_half <= 'd0;
        else 
            event_half <= event_half_next;
        
    end

    assign event_half_o = event_half;
    
endmodule