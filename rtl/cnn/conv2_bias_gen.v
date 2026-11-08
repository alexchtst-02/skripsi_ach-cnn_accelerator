`timescale 1ns / 1ps

module conv2_bias_gen(
    input wire clk,
    input wire rstn,
    
    input wire enable,
    output wire valid_bias,
    output wire [16*8-1:0] bias
);
    wire valid_out_bias_addr_gen;
    wire [0:0] id_bias_addr_gen;
    circular_counter_index#(
        .INDEX_WIDTH(1),
        .MAX_INDEX(2)
    ) uut_bias_addr_gen (
        .clk(clk), .rstn(rstn),
        .enable(enable),
        .valid_out(valid_out_bias_addr_gen),
        .id(id_bias_addr_gen)
    );
    
    conv2_b uut_bias (
        .clk(clk), .rstn(rstn),
        
        .enable(valid_out_bias_addr_gen),
        .channel_id(id_bias_addr_gen),
        
        .valid_out(valid_bias),
        .weight_bias(bias)
    );

endmodule