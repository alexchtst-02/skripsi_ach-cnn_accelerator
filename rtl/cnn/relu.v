`timescale 1ns / 1ps

module relu #(
    parameter integer DATA_WIDTH = 24
)(
    input wire valid_in,
    input wire signed [8*DATA_WIDTH-1:0] din,
    
    output wire valid_out,
    output wire signed [8*DATA_WIDTH-1:0] dout
);

    wire signed [DATA_WIDTH-1:0] d0 = $signed(din[DATA_WIDTH*0 +: DATA_WIDTH]);
    wire signed [DATA_WIDTH-1:0] d1 = $signed(din[DATA_WIDTH*1 +: DATA_WIDTH]);
    wire signed [DATA_WIDTH-1:0] d2 = $signed(din[DATA_WIDTH*2 +: DATA_WIDTH]);
    wire signed [DATA_WIDTH-1:0] d3 = $signed(din[DATA_WIDTH*3 +: DATA_WIDTH]);
    wire signed [DATA_WIDTH-1:0] d4 = $signed(din[DATA_WIDTH*4 +: DATA_WIDTH]);
    wire signed [DATA_WIDTH-1:0] d5 = $signed(din[DATA_WIDTH*5 +: DATA_WIDTH]);
    wire signed [DATA_WIDTH-1:0] d6 = $signed(din[DATA_WIDTH*6 +: DATA_WIDTH]);
    wire signed [DATA_WIDTH-1:0] d7 = $signed(din[DATA_WIDTH*7 +: DATA_WIDTH]);
    
    wire signed [DATA_WIDTH-1:0] relu_dout0 = $signed(d0[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d0);
    wire signed [DATA_WIDTH-1:0] relu_dout1 = $signed(d1[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d1);
    wire signed [DATA_WIDTH-1:0] relu_dout2 = $signed(d2[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d2);
    wire signed [DATA_WIDTH-1:0] relu_dout3 = $signed(d3[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d3);
    wire signed [DATA_WIDTH-1:0] relu_dout4 = $signed(d4[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d4);
    wire signed [DATA_WIDTH-1:0] relu_dout5 = $signed(d5[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d5);
    wire signed [DATA_WIDTH-1:0] relu_dout6 = $signed(d6[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d6);
    wire signed [DATA_WIDTH-1:0] relu_dout7 = $signed(d7[DATA_WIDTH-1] ? {DATA_WIDTH{1'b0}} : d7);
    
    assign dout = {relu_dout7, relu_dout6, relu_dout5, relu_dout4, relu_dout3, relu_dout2, relu_dout1, relu_dout0};
    assign valid_out = valid_in;
    
endmodule
