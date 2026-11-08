`timescale 1ns / 1ps

module pool2_layer(
    input wire clk,
    input wire rstn,
    
    input wire clear_reset,
    input wire enable_input,
    
    input wire valid_in,
    input wire [191:0] din,
    
    output wire ready_to_upstream,
    
    output wire valid_out,
    output wire [191:0] dout
);

    wire valid_out_ipt;
    wire [767:0] dout_ipt;
    pool2_ipt uut_ipt (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(clear_reset), 
        .enable_buffer_input(enable_input),
        
        .valid_in(valid_in), .din(din),
        
        .ready_to_upstream(ready_to_upstream),
        
        .valid_out(valid_out_ipt), .dout(dout_ipt)
    );
    
    pool_engine #(
        .DATA_WIDTH(24)
    ) uut_max_pool (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_ipt), .din(dout_ipt),
        
        .valid_out(valid_out), .dout(dout)
    );

endmodule
