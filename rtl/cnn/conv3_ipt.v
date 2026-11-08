`timescale 1ns / 1ps

module conv3_ipt(
    input wire clk,
    input wire rstn,
    
    input wire clear_reset,
    input wire enable_buffer_input,
    
    input wire valid_in,
    input wire [191:0] din,
    
    output wire ready_to_upstream,
    
    output wire valid_out,
    output wire [1727:0] dout,
    output wire valid_weight,
    output wire [1151:0] weight
);
    wire valid_out_buff_2_ipt_k3;
    wire [1727:0] dout_buff_2_ipt_k3;
    buffer_2_input_k3 #(
        .DATA_WIDTH(24),
        .TMUX(64),
        .LINE_WIDTH(5)
    ) uut_buff_2_ipt_k3 (
        .clk(clk), .rstn(rstn), .clear_reset(clear_reset),
        
        .enable(enable_buffer_input),
        
        .valid_in(valid_in),
        .din(din),
        
        .ready_to_upstream(ready_to_upstream),
        
        .valid_out(valid_out_buff_2_ipt_k3),
        .dout(dout_buff_2_ipt_k3)
    );
    
    buffer_2_register #(
        .WORD_WIDTH(1728)
    ) uut_buff_reg (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_buff_2_ipt_k3),
        .din(dout_buff_2_ipt_k3),
        
        .valid_out(valid_out),
        .dout(dout)
    );
    
    conv3_weight_gen uut_weight (
        .clk(clk), .rstn(rstn),
        
        .enable(valid_out_buff_2_ipt_k3),
        .valid_weight(valid_weight),
        .weight(weight)
    );

endmodule
