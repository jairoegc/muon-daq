//////////////////////////////////////////////////////////////////////////////
// Company: UTFSM
// Engineer: Jairo González
// Create Date: 16.09.2020 16:34
// Design Name: muon-daq
// Module Name: event_saver
// Project Name: muon-daq
// Target Devices: Trenz FPGA TE0720
// Tool Versions: Vivado 2019.1
// Description: 
//     
//  Behavior: 
// 
//////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////
// event_saver event_saver_inst(
//         .clk(),
//         .rst(),
//         .trigger(),     //1 bit 
//         //.state_i(),     //2bits
//         .event_i(),     //64bits width 15bits depth
//         .full_i(),      //1 bit  
//         .event_saved(), //1 bit
//         .wr_en_o(),     //1 bit
//         .din_o()        //64bits
//     );
/////////////////////////////////////////

module  event_saver(
            input   logic   clk,
            input   logic   rst,
            input   logic   trigger,
            //input   state_t [1:0] state_i,
            input   logic   [15:0][63:0] event_i,
            input   logic   full_i,
            output  logic   event_saved,
            output  logic   wr_en_o,
            output  logic   [63:0] din_o
        );

    //////////////////// FSM
    localparam COUNTER_MAX = 'd16;
    localparam COUNTER_WIDTH = $clog2(COUNTER_MAX);

    enum logic [1:0] {STAND_BY, WAITING, SAVING, DONE}  state, state_next;
    
    //assign state_o = state;

    logic [COUNTER_WIDTH-1:0]   hold_state_delay;  //timer para retener la maquina de estados en un estado
    logic                       hold_state_reset;  // resetear el timer para retener estado

    always_comb begin : FSM

        state_next = STAND_BY;
        hold_state_reset = 1'b1;

        case (state)
            STAND_BY:   begin
                            if(trigger)
                                state_next = WAITING;
                        end

            WAITING:    begin
                            state_next = WAITING;
                            if (!full_i) begin
                                state_next = SAVING;
                            end           
                        end

            SAVING:     begin
                            state_next = SAVING;
                            hold_state_reset = 1'b0;
                            if (hold_state_delay>=COUNTER_MAX-1) begin
                                state_next = DONE;
                                hold_state_reset = 1'b1;         
                            end
                        end

            DONE:       begin
                            state_next = STAND_BY;
                        end
        endcase
        
    end

    always_ff @(posedge clk) begin
        if(rst) 
            state <= STAND_BY;
        else 
            state <= state_next;
    end
    
    
    always_ff @(posedge clk) begin
       if (rst || hold_state_reset) 
           hold_state_delay <= 'd0;
       else
           hold_state_delay <= hold_state_delay + 'd1;       
    end


    //////////SAVER
    logic [15:0][63:0] event_sync;
    logic [15:0][63:0] event_sync_next;

    always_comb begin : saver
        event_sync_next = event_i;
        wr_en_o = 'd0;
        din_o = 'd0;
        event_saved = 'd0;
        case (state)
            SAVING:     begin
                            wr_en_o = 'd1;
                            din_o = event_sync[0][63:0];
                            event_sync_next = {64'd0,event_sync[15:1]};
                        end

            DONE:       begin
                            event_saved = 'd1;
                        end
        endcase
    end

    always_ff @( posedge clk ) begin
        if(rst) 
            event_sync <= 'd0;
        else 
            event_sync <= event_sync_next;
        
    end

endmodule