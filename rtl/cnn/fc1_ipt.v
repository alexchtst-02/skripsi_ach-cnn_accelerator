`timescale 1ns / 1ps

module fc1_ipt(
    
    input wire clk,
    input wire rstn,
    
    input wire enable,
    
    input wire clear_reset,
    input wire enable_buffer_input,
    
    input wire valid_in,
    input wire [191:0] din,
    
    output wire ready_to_upstream,
    
    output wire valid_out,
    output wire [191:0] dout,
    output wire valid_weight,
    output wire [127:0] weight

);
    
    wire valid_out_buff_serial;
    wire [191:0] dout_buff_serial;
    buffer_4_serial_input #(
        .DATA_WIDTH(24),
        .TMUX(64)
    ) uut_buff_serial (
        .clk(clk), .rstn(rstn), .clear_reset(clear_reset),
        
        .enable(enable_buffer_input),
        
        .valid_in(valid_in),
        .din(din),
        
        .ready_to_upstream(ready_to_upstream),
        
        .valid_out(valid_out_buff_serial),
        .dout(dout_buff_serial)
    );
    
    buffer_2_register #(
        .WORD_WIDTH(192)
    ) uut_buff_reg (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_buff_serial),
        .din(dout_buff_serial),
        
        .valid_out(valid_out),
        .dout(dout)
    );
    
    fc1_weight_gen uut_weight (
        .clk(clk), .rstn(rstn),
        
        .enable(valid_out_buff_serial),
        .valid_weight(valid_weight),
        .weight(weight)
    );

endmodule
