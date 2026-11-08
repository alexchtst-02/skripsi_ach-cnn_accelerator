`timescale 1ns / 1ps

module relayout_comparator_kernel #(
    parameter integer DATA_WIDTH = 24
)(
    input wire valid_in,
    input wire [DATA_WIDTH*8*4-1:0] din,
    
    output wire valid_out,
    output wire [DATA_WIDTH*8*4-1:0] dout
);

    wire [8*DATA_WIDTH-1:0] px0 =  din[8*DATA_WIDTH*0 +: 8*DATA_WIDTH];
    wire [8*DATA_WIDTH-1:0] px1 =  din[8*DATA_WIDTH*1 +: 8*DATA_WIDTH];
    wire [8*DATA_WIDTH-1:0] px2 =  din[8*DATA_WIDTH*2 +: 8*DATA_WIDTH];
    wire [8*DATA_WIDTH-1:0] px3 =  din[8*DATA_WIDTH*3 +: 8*DATA_WIDTH];
    
    wire [4*DATA_WIDTH-1:0] ch0 = {
        px3[DATA_WIDTH*0 +: DATA_WIDTH],
        px2[DATA_WIDTH*0 +: DATA_WIDTH],
        px1[DATA_WIDTH*0 +: DATA_WIDTH],
        px0[DATA_WIDTH*0 +: DATA_WIDTH]
    };
    
    wire [4*DATA_WIDTH-1:0] ch1 = {
        px3[DATA_WIDTH*1 +: DATA_WIDTH],
        px2[DATA_WIDTH*1 +: DATA_WIDTH],
        px1[DATA_WIDTH*1 +: DATA_WIDTH],
        px0[DATA_WIDTH*1 +: DATA_WIDTH]
    };
    
    wire [4*DATA_WIDTH-1:0] ch2 = {
        px3[DATA_WIDTH*2 +: DATA_WIDTH],
        px2[DATA_WIDTH*2 +: DATA_WIDTH],
        px1[DATA_WIDTH*2 +: DATA_WIDTH],
        px0[DATA_WIDTH*2 +: DATA_WIDTH]
    };
    
    wire [4*DATA_WIDTH-1:0] ch3 = {
        px3[DATA_WIDTH*3 +: DATA_WIDTH],
        px2[DATA_WIDTH*3 +: DATA_WIDTH],
        px1[DATA_WIDTH*3 +: DATA_WIDTH],
        px0[DATA_WIDTH*3 +: DATA_WIDTH]
    };
    
    wire [4*DATA_WIDTH-1:0] ch4 = {
        px3[DATA_WIDTH*4 +: DATA_WIDTH],
        px2[DATA_WIDTH*4 +: DATA_WIDTH],
        px1[DATA_WIDTH*4 +: DATA_WIDTH],
        px0[DATA_WIDTH*4 +: DATA_WIDTH]
    };

    wire [4*DATA_WIDTH-1:0] ch5 = {
        px3[DATA_WIDTH*5 +: DATA_WIDTH],
        px2[DATA_WIDTH*5 +: DATA_WIDTH],
        px1[DATA_WIDTH*5 +: DATA_WIDTH],
        px0[DATA_WIDTH*5 +: DATA_WIDTH]
    };
    
    wire [4*DATA_WIDTH-1:0] ch6 = {
        px3[DATA_WIDTH*6 +: DATA_WIDTH],
        px2[DATA_WIDTH*6 +: DATA_WIDTH],
        px1[DATA_WIDTH*6 +: DATA_WIDTH],
        px0[DATA_WIDTH*6 +: DATA_WIDTH]
    };
    
    wire [4*DATA_WIDTH-1:0] ch7 = {
        px3[DATA_WIDTH*7 +: DATA_WIDTH],
        px2[DATA_WIDTH*7 +: DATA_WIDTH],
        px1[DATA_WIDTH*7 +: DATA_WIDTH],
        px0[DATA_WIDTH*7 +: DATA_WIDTH]
    };
    
    assign dout = {ch7, ch6, ch5, ch4, ch3, ch2, ch1, ch0};
    assign valid_out = valid_in;

endmodule
