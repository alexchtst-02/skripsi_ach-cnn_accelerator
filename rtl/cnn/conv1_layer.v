`timescale 1ns / 1ps

module conv1_layer(
    input wire clk,
    input wire rstn,
    
    input wire clear_reset,
    input wire enable_input,
    
    input wire valid_in,
    input wire [191:0] din,
    
    output wire ready_to_upstream,
    
    output wire valid_out,
    output wire [191:0] dout,
    
    output wire raw_valid_out,
    output wire [367:0] raw_dout
);
    wire valid_out_ipt;
    wire [1727:0] dout_ipt;
    wire valid_param;
    wire signed [1151:0] weight_param;
    conv1_ipt uut_ipt (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(clear_reset),
        .enable_buffer_input(enable_input),
        
        .valid_in(valid_in), .din(din),
        
        .ready_to_upstream(ready_to_upstream),
        
        .valid_out(valid_out_ipt), .dout(dout_ipt),
        .valid_param(valid_param), .weight_param(weight_param)
    );
    
    wire [359:0] dout_convolver;
    wire valid_out_convolver;
    convolver_engine #(
        .DATA_WIDTH(24)
    ) uut_convolver (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_ipt), .din(dout_ipt),
        .valid_weight(valid_param), .weight(weight_param),
        
        .valid_out(valid_out_convolver), .dout(dout_convolver)
    );
    
    // bias implementation => produce 8 channels pararel as 1 pixel contain 8 channels
    
    wire valid_bias;
    wire signed [127:0] param_bias;
    conv1_b uut_bias (
        .valid_out(valid_bias),
        .param_bias(param_bias)
    );
    
    
    bias_accumulator #(
        .DATA_WIDTH(45)
    ) uut_bias_acc (
        .clk(clk), .rstn(rstn),
        
        .valid_din(valid_out_convolver), .din(dout_convolver),
        .valid_bias(valid_bias), .bias(param_bias),
        
        .valid_out(raw_valid_out), .dout(raw_dout)
    );
    
    // implement relu 
    
    wire signed [367:0] dout_bias_relu;
    wire valid_out_bias_relu;
    
    relu #(
        .DATA_WIDTH(46)
    ) uut_relu (
        .valid_in(raw_valid_out),
        .din(raw_dout),
        .valid_out(valid_out_bias_relu),
        .dout(dout_bias_relu)
    );
    
    // reduce data width with fixed point Q10.14 fixed point
    // max and min implementation in this module 
    
    requant_10_14 #(
        .DATA_FRACT_BIT(28),
        .DATA_INT_BIT(18)
    ) uut_req_10_14 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_bias_relu),
        .din(dout_bias_relu),
        
        .valid_out(valid_out),
        .dout(dout)
    );
    
endmodule
