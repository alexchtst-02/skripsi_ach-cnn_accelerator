`timescale 1ns / 1ps

module buffer_2_serial_input #(
    parameter integer DATA_WIDTH = 24,
    parameter integer TMUX = 16
)(
    input wire clk,
    input wire rstn,
    
    input wire clear_reset,
    input wire enable,
    
    input wire valid_in,
    input wire [DATA_WIDTH*8-1:0] din,
    
    output wire ready_to_upstream,
    output wire valid_out,
    output wire [DATA_WIDTH*8-1:0] dout
);
    
    wire ready_to_upstream_b2d;
    wire ready_to_upstream_tmux_cnt;
    assign ready_to_upstream = ready_to_upstream_b2d;
    
    wire valid_out0_b2d;
    wire [DATA_WIDTH*8-1:0] dut0_b2d;
    wire valid_out1_b2d;
    wire [DATA_WIDTH*8-1:0] dut1_b2d;
    burst_2_data #(
        .DATA_WIDTH(DATA_WIDTH*8)
    ) uut_b2d (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(clear_reset),
        
        .ready_from_downstream0(ready_to_upstream_tmux_cnt),
        .ready_from_downstream1(ready_to_upstream_tmux_cnt),
        
        .valid_in(valid_in), .din(din),
        
        .ready_to_upstream(ready_to_upstream_b2d),
        
        .valid_out0(valid_out0_b2d), .dout0(dut0_b2d),
        .valid_out1(valid_out1_b2d), .dout1(dut1_b2d)
    );
    
    wire valid_out_sc2d;
    wire [DATA_WIDTH*8*2-1:0] dout_sc2d;
    wire ready_to_upstream_sc2d;
    symetric_concater_2_data #(
        .WORD_WIDTH(DATA_WIDTH*8)
    ) uut_sc2d (
        .ready_to_upstream0(1'b1),
        .valid_in0(valid_out0_b2d),
        .din0(dut0_b2d),

        .ready_to_upstream1(1'b1),
        .valid_in1(valid_out1_b2d),
        .din1(dut1_b2d),

        .ready_to_upstraeam_out(ready_to_upstream_sc2d),
        .valid_in_out(valid_out_sc2d),
        .din_out(dout_sc2d)
    );
    
    cirlular_input_multiplexed #(
        .DATA_WIDTH(DATA_WIDTH*8),
        .DATA_NUM(2),
        .TIME_MULTIPLEX(TMUX)
    ) uut_tmux_cnt (
        .clk(clk), .rstn(rstn), .clear_reset(clear_reset),
        
        .enable(enable),
        
        .valid_in(valid_out_sc2d),
        .din(dout_sc2d),
        
        .ready_to_upstream(ready_to_upstream_tmux_cnt),
        
        .valid_out(valid_out),
        .dout(dout)
    );

endmodule
