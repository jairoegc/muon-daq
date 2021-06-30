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
// Description: Emits 36 events of 15 bits, each with duration of the
// the current event number, and with an aribrary waiting time between each
// event. 
// The events emits 6 signals per event, in 2 groups of 3 consecutives
// signals, emulating a muon interaction with a sTGC detector, and changes the
// the signals to be emitted at every event.
// Also it emits a trigger signal of 1 cycle after an arbitrary number of 
// clock cycles next to an event emission.
//
//////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////

    // test_signals_emitter test_signals_emitter_inst(
    //         .clk(), //1 bit
    //         .aresetn(), //1 bit
    //         .start_i(), //1 bit
    //         .trigger_o() //1 bit
    //         .signals_o() //15 bit array
    //     );
   
/////////////////////////////////////////



module  test_signals_emitter(
            input   logic   clk,
            input   logic   aresetn,
            input   logic   start_i,
            output  logic   trigger_o,
            output  logic   [15:0] signals_o
        );
    
    ///////// Counters parameters and variables

    // Event counter: 
    localparam EVENT_COUNTER_MAX = 'd36; //how many events should be emitted
    localparam EVENT_COUNTER_WIDTH = $clog2(EVENT_COUNTER_MAX);
    logic [EVENT_COUNTER_WIDTH-1:0] event_counter, event_counter_next;
    logic event_counter_reset;
    
    // Waiting counter:
    localparam WAITING_COUNTER_MAX = 'd200; //How 'many clk cycles should be waited until next event
    localparam WAITING_COUNTER_WIDTH = $clog2(WAITING_COUNTER_MAX);
    logic [WAITING_COUNTER_WIDTH-1:0] waiting_counter;
    logic waiting_counter_reset;

    //Hold state counter:
    localparam HOLD_MAX = EVENT_COUNTER_MAX; //It holds the emision state depending of the event number
    localparam HOLD_WIDTH = $clog2(HOLD_MAX);
    logic [HOLD_WIDTH-1:0]   hold_state_delay;  //timer para retener la maquina de estados en un estado
    logic                    hold_state_reset;  // resetear el timer para retener estado

    // FSM
    enum logic [1:0] {STANDBY, EMITTING, WAITING}  signal_state, signal_state_next;

    always_comb begin : FSM
        signal_state_next = STANDBY;
        hold_state_reset = 1'b1;
        event_counter_reset = 1'b1;
        waiting_counter_reset = 1'b1;
        event_counter_next = 'd0;
        case (signal_state)
            STANDBY:    begin
                            if (start_i)
                                signal_state_next = EMITTING;
                        end
            EMITTING:   begin
                            signal_state_next = EMITTING;
                            event_counter_reset = 1'b0;
                            hold_state_reset = 1'b0;
                            event_counter_next = event_counter;
                            if (event_counter >= EVENT_COUNTER_MAX-1) begin
                                signal_state_next = STANDBY;
                                event_counter_reset = 1'b1;
                                hold_state_reset = 1'b1;
                            end
                            else if (hold_state_delay >= HOLD_MAX - event_counter - 2) begin
                                signal_state_next  = WAITING;
                                event_counter_next = event_counter + 'd1;
                                hold_state_reset = 1'b1;
                            end
                        end 
            WAITING:    begin                            
                            signal_state_next = WAITING;
                            event_counter_reset = 1'b0;
                            waiting_counter_reset = 1'b0;
                            event_counter_next = event_counter;
                            if (waiting_counter >= WAITING_COUNTER_MAX-1) begin 
                                signal_state_next = EMITTING;
                                waiting_counter_reset = 1'b1;     
                            end        
                        end
        endcase
    end
    always_ff @(posedge clk, negedge aresetn) begin
        if(aresetn == 'b0) 
            signal_state <= STANDBY;
        else 
            signal_state <= signal_state_next;
    end
    
    always_ff @(posedge clk, negedge aresetn) begin
       if ((aresetn == 'b0) || hold_state_reset) 
           hold_state_delay <= 'd0;
       else
           hold_state_delay <= hold_state_delay + 'd1;       
    end

    always_ff @(posedge clk, negedge aresetn) begin
       if ((aresetn == 'b0) || event_counter_reset) 
           event_counter <= 'd0;
       else
           event_counter <= event_counter_next;       
    end

    always_ff @(posedge clk, negedge aresetn) begin
       if ((aresetn == 'b0) || waiting_counter_reset) 
           waiting_counter <= 'd0;
       else
           waiting_counter <= waiting_counter + 'd1;       
    end

    //Signals
    logic [15:0] signals = 'd0;
    logic [15:0] signals_next;

    logic [15:0] signals_aux = 'd0; // Aux var to keep the previous event value
    logic [15:0] signals_aux_next;
    assign signals_o[15:0] = signals[15:0];

    always_comb begin : SIGNALS
        signals_next = 'd0;
        signals_aux_next = 'd0; 
        case (signal_state)
            STANDBY:    begin
                            if (start_i)
                                signals_next = {8'b00000111,8'b11100000};
                        end
            EMITTING:   begin
                            signals_next = signals;
                            signals_aux_next = signals;
                            if (event_counter >= EVENT_COUNTER_MAX-1) begin
                                signals_next = 'd0;
                                signals_aux_next = 'd0; 
                            end
                        end 
            WAITING:    begin
                            signals_aux_next = signals_aux;
                            // if (event_counter > EVENT_COUNTER_MAX-1) begin
                            //     signals_aux_next = 'd0;
                            
                            if (waiting_counter >= WAITING_COUNTER_MAX-1) begin
                                if ((event_counter == 'd6)||(event_counter == 'd12)||(event_counter == 'd18)||(event_counter == 'd24)||(event_counter == 'd30))
                                    signals_next = {signals_aux[15:8]<<1,8'b11100000};
                                else if (event_counter == 'd36)
                                    signals_next = {8'b00000111,8'b11100000};
                                else
                                    signals_next = {signals_aux[15:8],signals_aux[7:0]>>1};

                                // case (event_counter)
                                //     'd5,'d11,'d17,'d23,'d29:    signals_next = {signals[15:8]<<1,8'b11100000};
                                //     'd35:                       signals_next =  {8'b00000111,8'b11100000};
                                // endcase
                            end        
                        end
        endcase
    end

    always_ff @(posedge clk, negedge aresetn) begin
        if ((aresetn == 'b0)) begin
            signals <= 'd0;
            signals_aux <= 'd0;
        end
        else begin
            signals <= signals_next;
            signals_aux <= signals_aux_next;
        end   
    end

    /////////////////////////////// Trigger emitter

    wire send_triger;
    posedge_detector posedge_detector_inst(
        .clk(clk), 
        .aresetn(aresetn),
        .signal(signal_state==EMITTING),
        .detection(send_triger)
    );

    test_trigger_emitter test_trigger_emitter_inst(
            .clk(clk), //1 bit
            .aresetn(aresetn), //1 bit
            .start_i(send_triger), //1 bit
            .trigger_o(trigger_o) //1 bit
        );
endmodule