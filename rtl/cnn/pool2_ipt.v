`timescale 1ns / 1ps

module pool2_ipt (
    input wire clk,
    input wire rstn,
    
    input wire clear_reset,
    input wire enable_buffer_input,
    
    input wire valid_in,
    input wire [191:0] din,
    
    output wire ready_to_upstream,
    
    output wire valid_out,
    output wire [767:0] dout
);

    buffer_2_input_k2 #(
        .DATA_WIDTH(24),
        .TMUX(2),
        .LINE_WIDTH(11)
    ) uut_buff_2_ipt_k2 (
        .clk(clk), .rstn(rstn), .clear_reset(clear_reset),
        
        .enable(enable_buffer_input),
        
        .valid_in(valid_in),
        .din(din),
        
        .ready_to_upstream(ready_to_upstream),
        
        .valid_out(valid_out),
        .dout(dout)
    );

endmodule
