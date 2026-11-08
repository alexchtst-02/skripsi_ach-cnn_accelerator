`timescale 1ns / 1ps

module fully_connected_1_layer(
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
    wire [191:0] dout_ipt;
    wire valid_param;
    wire signed [127:0] weight_param;
    fc1_ipt uut_ipt (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(clear_reset), 
        .enable_buffer_input(enable_input),
        
        .valid_in(valid_in), .din(din),
        
        .ready_to_upstream(ready_to_upstream),
        
        .valid_out(valid_out_ipt), .dout(dout_ipt),
        .valid_weight(valid_param), .weight(weight_param)
    );
    
    // in feature = 32, out feat = 16 
    // vecotr 8 multiplied 8 data with param and accumulate it
    
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
    
    // since 8 from 32 is 1/4 we need to buffer this operation 4 times and accumulate the whole buffer
    
    wire valid_out_buff_4ch;
    wire [171:0] dout_buff_4ch;
    buffer_acc_4ch #(
        .DATA_WIDTH(43)
    ) uut_buff_4ch (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_multiplier), .din(dout_multiplier),
        
        .valid_out(valid_out_buff_4ch), .dout(dout_buff_4ch)
    );
    
    wire valid_out_acc_4ch;
    wire [44:0] dout_acc_4ch;
    accumulator_4ch #(
        .DATA_WIDTH(43)
    ) uut_acc_4ch (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_buff_4ch), .din(dout_buff_4ch),
        
        .valid_out(valid_out_acc_4ch), .dout(dout_acc_4ch)
    );
    
    // the results value of the acc 4 ch is 1 valid feature from 16, we need to buffer it 8 and do bias operation
    wire valid_out_buff_acc_ch8;
    wire [359:0] dout_buff_acc_ch8;
    buffer_acc_8ch #(
        .DATA_WIDTH(45)
    ) uut_buff_acc_ch8 (
         .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_acc_4ch), .din(dout_acc_4ch),
        
        .valid_out(valid_out_buff_acc_ch8), .dout(dout_buff_acc_ch8)
    );
    
    wire valid_out_buff_reg;
    wire [359:0] dout_buff_reg;
    buffer_2_register #(
        .WORD_WIDTH(360)
    ) uut_buff_reg (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_buff_acc_ch8),
        .din(dout_buff_acc_ch8),
        
        .valid_out(valid_out_buff_reg),
        .dout(dout_buff_reg)
    );
    
    wire valid_bias;
    wire [127:0] param_bias;
    fc1_bias_gen uut_bias (
        .clk(clk), .rstn(rstn),
        
        .enable(valid_out_buff_acc_ch8),
        
        .valid_bias(valid_bias),
        .bias(param_bias)
    );
    
    bias_accumulator #(
        .DATA_WIDTH(45)
    ) uut_bias_acc (
         .clk(clk), .rstn(rstn),
        
        .valid_din(valid_out_buff_reg),
        .din(dout_buff_reg),
        
        .valid_bias(valid_bias),
        .bias(param_bias),
        
        .valid_out(raw_valid_out),
        .dout(raw_dout)
    );
    
    // implement relu 
    
    wire valid_out_bias_relu;
    wire [367:0] dout_bias_relu;
    
    relu #(
        .DATA_WIDTH(46)
    ) uut_relu (
        .valid_in(raw_valid_out),
        .din(raw_dout),
        .valid_out(valid_out_bias_relu),
        .dout(dout_bias_relu)
    );
    
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
