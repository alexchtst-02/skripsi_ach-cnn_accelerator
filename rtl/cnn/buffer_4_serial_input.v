`timescale 1ns / 1ps

module buffer_4_serial_input #(
    parameter integer DATA_WIDTH = 24,
    parameter integer TMUX = 64
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
    
    wire ready_to_upstream_tmux_cnt;
    
    wire ready_to_upstream_b4d;
    assign ready_to_upstream = ready_to_upstream_b4d;
    
    wire valid_out0_b4d;
    wire [DATA_WIDTH*8-1:0] dut0_b4d;
    wire valid_out1_b4d;
    wire [DATA_WIDTH*8-1:0] dut1_b4d;
    wire valid_out2_b4d;
    wire [DATA_WIDTH*8-1:0] dut2_b4d;
    wire valid_out3_b4d;
    wire [DATA_WIDTH*8-1:0] dut3_b4d;
    burst_4_data #(
        .DATA_WIDTH(DATA_WIDTH*8)
    ) uut_b4d (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(clear_reset),
        
        .ready_from_downstream0(ready_to_upstream_tmux_cnt),
        .ready_from_downstream1(ready_to_upstream_tmux_cnt),
        .ready_from_downstream2(ready_to_upstream_tmux_cnt),
        .ready_from_downstream3(ready_to_upstream_tmux_cnt),
        
        .valid_in(valid_in), .din(din),
        
        .ready_to_upstream(ready_to_upstream_b4d),
        
        .valid_out0(valid_out0_b4d), .dout0(dut0_b4d),
        .valid_out1(valid_out1_b4d), .dout1(dut1_b4d),
        .valid_out2(valid_out2_b4d), .dout2(dut2_b4d),
        .valid_out3(valid_out3_b4d), .dout3(dut3_b4d)
    );
    
    wire valid_out_sc4d;
    wire [DATA_WIDTH*8*4-1:0] dout_sc4d;
    wire ready_to_upstream_sc4d;
    symetric_concater_4_data #(
        .WORD_WIDTH(DATA_WIDTH*8)
    ) uut_sc4d (
        .ready_to_upstream0(1'b1),
        .valid_in0(valid_out0_b4d),
        .din0(dut0_b4d),

        .ready_to_upstream1(1'b1),
        .valid_in1(valid_out1_b4d),
        .din1(dut1_b4d),
        
        .ready_to_upstream2(1'b1),
        .valid_in2(valid_out2_b4d),
        .din2(dut2_b4d),

        .ready_to_upstream3(1'b1),
        .valid_in3(valid_out3_b4d),
        .din3(dut3_b4d),

        .ready_to_upstraeam_out(ready_to_upstream_sc4d),
        .valid_in_out(valid_out_sc4d),
        .din_out(dout_sc4d)
    );
    
    cirlular_input_multiplexed #(
        .DATA_WIDTH(DATA_WIDTH*8),
        .DATA_NUM(4),
        .TIME_MULTIPLEX(TMUX)
    ) uut_tmux_cnt (
        .clk(clk), .rstn(rstn), .clear_reset(clear_reset),
        
        .enable(enable),
        
        .valid_in(valid_out_sc4d),
        .din(dout_sc4d),
        
        .ready_to_upstream(ready_to_upstream_tmux_cnt),
        
        .valid_out(valid_out),
        .dout(dout)
    );

endmodule
