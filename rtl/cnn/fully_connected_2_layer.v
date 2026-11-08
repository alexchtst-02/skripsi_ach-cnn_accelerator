`timescale 1ns / 1ps

module fully_connected_2_layer(
    input wire clk,
    input wire rstn,
    
    input wire clear_reset,
    input wire enable_input,
    
    input wire valid_in,
    input wire [191:0] din,
    
    output wire ready_to_upstream,
    
    output wire valid_out,
    output wire [239:0] dout,
    
    output wire raw_valid_out,
    output wire [449:0] raw_dout
);

    wire valid_out_ipt;
    wire [191:0] dout_ipt;
    wire valid_param;
    wire signed [127:0] weight_param;
    fc2_ipt uut_ipt (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(clear_reset), 
        .enable_buffer_input(enable_input),
        
        .valid_in(valid_in), .din(din),
        
        .ready_to_upstream(ready_to_upstream),
        
        .valid_out(valid_out_ipt), .dout(dout_ipt),
        .valid_weight(valid_param), .weight(weight_param)
    );
    
    // in feature = 16, out feat = 10 
    
    wire [42:0] dout_multiplier;
    wire valid_out_multiplier;
    vector_8 #(
        .DATA_WIDTH(24)
    ) uut_multiplier (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_ipt), .din(dout_ipt),
        .valid_param(valid_param), .param(weight_param),
        
        .valid_out(valid_out_multiplier), .dout(dout_multiplier)
    );
    
    // buffer the accumulation from acc(8) 2 times and accumulate each other => acc(8) + acc(8) = acc(16)
    
    wire valid_out_buff_acc_partial;
    wire [85:0] dout_buff_acc_partial;
    buffer_acc_partial #(
        .DATA_WIDTH(43)
    ) uut_buff_acc_partial (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_multiplier),
        .din(dout_multiplier),
        
        .valid_out(valid_out_buff_acc_partial),
        .dout(dout_buff_acc_partial)
    );
    
    wire valid_out_acc_partial;
    wire [43:0] dout_acc_partial;
    accumulator_partial #(
        .DATA_WIDTH(43)
    ) uut_acc_partial (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_buff_acc_partial),
        .din(dout_buff_acc_partial),
        
        .valid_out(valid_out_acc_partial),
        .dout(dout_acc_partial)
    );
    
    // 1 valid feature is the results from 16 in feature correspond to its param
    // we buffer until 10 data and do bias acc + relu and requantitze
    
    wire valid_out_buff_class_10;
    wire [439:0] dout_buff_class_10;
    buffer_class_10 #(
        .DATA_WIDTH(44)
    ) uut_buff_class_10 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_acc_partial),
        .din(dout_acc_partial),
        
        .valid_out(valid_out_buff_class_10),
        .dout(dout_buff_class_10)
    );
    
    // this wime we need no sync because the bias is combinatoral
    
    wire valid_bias;
    wire [159:0] param_bias;
    fc2_b uut_bias (
        
        .valid_out(valid_bias),
        .param_bias(param_bias)
    );
    
    
    bias_10_class_accumulator #(
        .DATA_WIDTH(44)
    ) uut_bias_10_class_acc (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_buff_class_10),
        .din(dout_buff_class_10),
        
        .valid_bias(valid_bias),
        .bias(param_bias),
        
        .valid_out(raw_valid_out),
        .dout(raw_dout)
    );
    
    wire valid_out_bias_10_class_relu;
    wire [449:0] dout_bias_10_class_relu;
    relu_argmax #(
        .DATA_WIDTH(45)
    ) uut_relu (
        .valid_in(raw_valid_out),
        .din(raw_dout),
        .valid_out(valid_out_bias_10_class_relu),
        .dout(dout_bias_10_class_relu)
    );
    
    requant_10_class_10_14 #(
        .DATA_FRACT_BIT(28),
        .DATA_INT_BIT(17)
    ) uut_req_10_14 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_bias_10_class_relu),
        .din(dout_bias_10_class_relu),
        
        .valid_out(valid_out),
        .dout(dout)
    );

endmodule
