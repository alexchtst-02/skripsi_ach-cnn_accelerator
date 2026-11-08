`timescale 1ns / 1ps

module conv3_weight_gen(
    input wire clk,
    input wire rstn,
    
    input wire enable,
    output wire valid_weight,
    output wire [16*8*9-1:0] weight
);
    
    wire valid_out_weight_addr_gen;
    wire [5:0] id_weight_addr_gen;
    circular_counter_index #(
        .INDEX_WIDTH(6),
        .MAX_INDEX(63)
    ) uut_weight_addr_gen (
        .clk(clk), .rstn(rstn),
        .enable(enable),
        .valid_out(valid_out_weight_addr_gen),
        .id(id_weight_addr_gen)
    );
    
    conv3_w uut_weight (
        .clk(clk), .rstn(rstn),
        .enable(valid_out_weight_addr_gen),
        .channel_id(id_weight_addr_gen),
        .valid_out(valid_weight),
        .weight_param(weight)
    );

endmodule
