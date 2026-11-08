`timescale 1ns / 1ps

module buffer_1_input_k2 #(
    parameter integer DATA_WIDTH = 24,
    parameter integer TMUX = 1,
    parameter integer LINE_WIDTH = 26
)(
    input wire clk,
    input wire rstn,
    
    input wire clear_reset,
    input wire enable,
    
    input wire valid_in,
    input wire [DATA_WIDTH*8-1:0] din,
    
    output wire ready_to_upstream,
    output wire valid_out,
    output wire [DATA_WIDTH*8*4-1:0] dout
);
    
    wire ready_to_upstream_tmux_cnt;
    
    wire ready_to_upstream_k2r_0;
    wire valid_out_k2r_0;
    wire [DATA_WIDTH*8*4-1:0] dout_k2r_0;
    kernel_2x2_reconstructor #(
        .DATA_WIDTH(DATA_WIDTH),
        .LINE_WIDTH(LINE_WIDTH)
    ) uut_k2r_0 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset_kernel(clear_reset),
        
        .ready_from_downstream(ready_to_upstream_tmux_cnt),
        .valid_in(valid_in),
        .din(din),
        
        .ready_to_upstream(ready_to_upstream),
        .valid_out(valid_out_k2r_0),
        .dout(dout_k2r_0)
    );
    
    cirlular_input_multiplexed #(
        .DATA_WIDTH(DATA_WIDTH*8*4),
        .DATA_NUM(1),
        .TIME_MULTIPLEX(TMUX)
    ) uut_tmux_cnt (
        .clk(clk), .rstn(rstn), .clear_reset(clear_reset),
        
        .enable(enable),
        
        .valid_in(valid_out_k2r_0),
        .din(dout_k2r_0),
        
        .ready_to_upstream(ready_to_upstream_tmux_cnt),
        
        .valid_out(valid_out),
        .dout(dout)
    );

endmodule
