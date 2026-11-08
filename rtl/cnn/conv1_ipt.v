`timescale 1ns / 1ps

module conv1_ipt(
    input wire clk,
    input wire rstn,
    
    input wire clear_reset,
    input wire enable_buffer_input,
    
    input wire valid_in,
    input wire [191:0] din,
    
    output wire ready_to_upstream,
    
    output wire valid_out,
    output wire [1727:0] dout,
    output wire valid_param,
    output wire signed [1151:0] weight_param
);

    kernel_3x3_reconstructor #(
        .DATA_WIDTH(24),
        .LINE_WIDTH(28)
    ) uut_k3r_0 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset_kernel(clear_reset),
        
        .ready_from_downstream(1'b1),
        .valid_in(valid_in),
        .din(din),
        
        .ready_to_upstream(ready_to_upstream),
        .valid_out(valid_out),
        .dout(dout)
    );
    
    conv1_w uut_weight (
        .valid_out(valid_param),
        .weight_param(weight_param)
    );

endmodule
