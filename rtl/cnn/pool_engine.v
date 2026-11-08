`timescale 1ns / 1ps

module pool_engine #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire [DATA_WIDTH*8*4-1:0] din,
    
    output wire valid_out,
    output wire [DATA_WIDTH*8-1:0] dout
);

    wire valid_out_rck;
    wire [767:0] dout_rck;
    relayout_comparator_kernel #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut_rck (
        .valid_in(valid_in),
        .din(din),
        .valid_out(valid_out_rck),
        .dout(dout_rck)
    );
    
    comparator_32 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut_comp32 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_rck),
        .din(dout_rck),
        
        .valid_out(valid_out),
        .dout(dout)
    );

endmodule
