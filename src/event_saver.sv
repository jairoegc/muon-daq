`timescale 1ns / 1ps
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
//         .aresetn(),
//         .trigger(),     //1 bit 
//         //.state_i(),     //2bits
//         .event_i(),     //64bits width 15bits depth
//         .full_i(),      //1 bit
//         .event_ready_i()  //1 bit
//         .event_saved(), //1 bit
//         .wr_en_o(),     //1 bit
//         .din_o()        //64bits
//     );
/////////////////////////////////////////

module  event_saver(
            input   logic   clk,
            input   logic   aresetn,
            input   logic   trigger,
            //input   state_t [1:0] state_i,
            input   logic   [15:0][63:0] event_i,
            input   logic   full_i,
            input   logic   event_ready_i,
            output  logic   event_saved,
            output  logic   wr_en_o,
            output  logic   [63:0] din_o
        );

    /////////////// Event and Trigger clock synchronization ///////////////////
    logic [15:0][63:0] event_synchronized_0 = 'd0;
    logic [15:0][63:0] event_synchronized = 'd0;
    logic [15:0][63:0] event_synchronized_0_next;
	logic [15:0][63:0] event_synchronized_next;
	
	always_comb begin
		event_synchronized_0_next = event_i;
        event_synchronized_next = event_synchronized_0;
	end

	always_ff@(posedge clk, negedge aresetn)
	begin
		if(aresetn == 'b0) begin
            event_synchronized_0 <= 'd0;
			event_synchronized <= 'd0;
        end
		else begin
            event_synchronized_0 <= event_synchronized_0_next;
			event_synchronized <= event_synchronized_next;
        end
	end
    
    logic event_ready_sync;
    synchronizer event_ready_sync_inst(
        .clk(clk),
        .aresetn(aresetn),
        .i_signal(event_ready_i),
        .o_signal(event_ready_sync)
    );

    posedge_detector posedge_detector_inst(
        .clk(clk), 
        .aresetn(aresetn),
        .signal(event_ready_sync),
        .detection(event_ready_sync_posedge)
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
                            if(event_ready_sync_posedge)
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

    always_ff @(posedge clk, negedge aresetn) begin
        if(aresetn == 'b0) 
            state <= STAND_BY;
        else 
            state <= state_next;
    end
    
    
    always_ff @(posedge clk, negedge aresetn) begin
       if ((aresetn == 'b0) || hold_state_reset) 
           hold_state_delay <= 'd0;
       else
           hold_state_delay <= hold_state_delay + 'd1;       
    end


    //////////SAVER
    logic [15:0][63:0] event_channel_shift, event_channel_shift_next;
    logic [63:0] din, din_next;
    logic wr_en, wr_en_next;
    always_comb begin : saver
        event_channel_shift_next = event_synchronized;
        wr_en_next = 'd0;
        din_next = 'd0;
        event_saved = 'd0;
        case (state)
            SAVING:     begin
                            wr_en_next = 'd1;
                            din_next = event_channel_shift[0][63:0];
                            event_channel_shift_next = {64'd0,event_channel_shift[15:1]};
                        end

            DONE:       begin
                            event_saved = 'd1;
                        end
        endcase
    end

    always_ff @( posedge clk, negedge aresetn ) begin
        if(aresetn == 'b0) begin
            event_channel_shift <= 'd0;
            din <= 'd0;
            wr_en <= 'd0;
        end
        else begin
            event_channel_shift <= event_channel_shift_next;
            din <= din_next;
            wr_en <= wr_en_next;
        end
    end

    assign din_o = din;
    assign wr_en_o = wr_en;
endmodule