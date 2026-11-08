`timescale 1ns / 1ps

module relu_argmax #(
    parameter integer DATA_WIDTH = 24
)(
    input wire valid_in,
    input wire signed [10*DATA_WIDTH-1:0] din,
    
    output wire valid_out,
    output wire signed [10*DATA_WIDTH-1:0] dout
);

    wire signed [DATA_WIDTH-1:0] d0 = din[DATA_WIDTH*0 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d1 = din[DATA_WIDTH*1 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d2 = din[DATA_WIDTH*2 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d3 = din[DATA_WIDTH*3 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d4 = din[DATA_WIDTH*4 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d5 = din[DATA_WIDTH*5 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d6 = din[DATA_WIDTH*6 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d7 = din[DATA_WIDTH*7 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d8 = din[DATA_WIDTH*8 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d9 = din[DATA_WIDTH*9 +: DATA_WIDTH];
    
    
    wire signed [DATA_WIDTH-1:0] relu_dout0 = d0[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d0;
    wire signed [DATA_WIDTH-1:0] relu_dout1 = d1[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d1;
    wire signed [DATA_WIDTH-1:0] relu_dout2 = d2[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d2;
    wire signed [DATA_WIDTH-1:0] relu_dout3 = d3[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d3;
    wire signed [DATA_WIDTH-1:0] relu_dout4 = d4[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d4;
    wire signed [DATA_WIDTH-1:0] relu_dout5 = d5[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d5;
    wire signed [DATA_WIDTH-1:0] relu_dout6 = d6[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d6;
    wire signed [DATA_WIDTH-1:0] relu_dout7 = d7[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d7;
    wire signed [DATA_WIDTH-1:0] relu_dout8 = d8[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d8;
    wire signed [DATA_WIDTH-1:0] relu_dout9 = d9[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d9;
    
    assign dout = {relu_dout9, relu_dout8, relu_dout7, relu_dout6, relu_dout5, relu_dout4, relu_dout3, relu_dout2, relu_dout1, relu_dout0};
    assign valid_out = valid_in;
    
endmodule
