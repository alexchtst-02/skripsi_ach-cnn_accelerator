`timescale 1ns / 1ps

module conv3_bias_gen(
    input wire clk,
    input wire rstn,
    
    input wire enable,
    output wire valid_bias,
    output wire [16*8-1:0] bias
);
    
    wire valid_out_weight_addr_gen;
    wire [1:0] id_weight_addr_gen;
    circular_counter_index #(
        .INDEX_WIDTH(2),
        .MAX_INDEX(3)
    ) uut_weight_addr_gen (
        .clk(clk), .rstn(rstn),
        .enable(enable),
        .valid_out(valid_out_weight_addr_gen),
        .id(id_weight_addr_gen)
    );
    
    conv3_b uut_bias (
        .clk(clk), .rstn(rstn),
        .enable(valid_out_weight_addr_gen),
        .channel_id(id_weight_addr_gen),
        .valid_out(valid_bias),
        .bias_param(bias)
    );

endmodule
