`timescale 1ns / 1ps

module conv2_layer(
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
    output wire [391:0] raw_dout
);
    
    wire valid_out_ipt;
    wire [1727:0] dout_ipt;
    wire valid_param;
    wire signed [1151:0] weight_param;
    conv2_ipt uut_ipt (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(clear_reset), 
        .enable_buffer_input(enable_input),
        
        .valid_in(valid_in), .din(din),
        
        .ready_to_upstream(ready_to_upstream),
        
        .valid_out(valid_out_ipt), .dout(dout_ipt),
        .valid_weight(valid_param), .weight(weight_param)
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
    
    // in ch = 8 and out ch = 16
    // the 8 channels resluts must be accumulated and produce 1 ch from 16 ch
    
    wire valid_out_acc_8ch;
    wire [47:0] dout_acc_8ch;
    accumulator_8ch #(
        .DATA_WIDTH(45)
    ) uut_acc_8ch (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_convolver), .din(dout_convolver),
        
        .valid_out(valid_out_acc_8ch), .dout(dout_acc_8ch)
    );
    
    // gathered 8 channels [because the bias acc can only consume 8 datas]
    
    wire valid_out_buff_acc_ch8;
    wire [383:0] dout_buff_acc_ch8;
    buffer_acc_8ch #(
        .DATA_WIDTH(48)
    ) uut_buff_acc_ch8 (
         .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_acc_8ch), .din(dout_acc_8ch),
        
        .valid_out(valid_out_buff_acc_ch8), .dout(dout_buff_acc_ch8)
    );
    
    // bias implementation => produce 8 channels that has been buffered
    // as the bias circular stream is delayed 2 cycle we need to delay the buffer data to synchronize data pairing
    
    wire valid_out_buff_reg;
    wire [383:0] dout_buff_reg;
    buffer_2_register #(
        .WORD_WIDTH(384)
    ) uut_buff_reg (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_buff_acc_ch8),
        .din(dout_buff_acc_ch8),
        
        .valid_out(valid_out_buff_reg),
        .dout(dout_buff_reg)
    );
    
    wire valid_bias;
    wire [127:0] param_bias;
    conv2_bias_gen uut_bias (
        .clk(clk), .rstn(rstn),
        
        .enable(valid_out_buff_acc_ch8),
        
        .valid_bias(valid_bias),
        .bias(param_bias)
    );
    
    bias_accumulator #(
        .DATA_WIDTH(48)
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
    wire [391:0] dout_bias_relu;
    relu #(
        .DATA_WIDTH(49)
    ) uut_relu (
        .valid_in(raw_valid_out),
        .din(raw_dout),
        .valid_out(valid_out_bias_relu),
        .dout(dout_bias_relu)
    );
    
    // requantitize
    
    requant_10_14 #(
        .DATA_FRACT_BIT(28),
        .DATA_INT_BIT(21)
    ) uut_req_10_14 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_bias_relu),
        .din(dout_bias_relu),
        
        .valid_out(valid_out),
        .dout(dout)
    );

endmodule
