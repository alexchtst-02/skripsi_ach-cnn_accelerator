`timescale 1ns / 1ps

module relayout_mac_kernel #(
    parameter integer DATA_WIDTH = 24
)(
    input wire valid_in,
    input wire signed [DATA_WIDTH*8*9-1:0] din,
    
    output wire valid_out,
    output wire signed [DATA_WIDTH*8*9-1:0] dout
);

    wire signed [8*DATA_WIDTH-1:0] px0 =  din[8*DATA_WIDTH*0 +: 8*DATA_WIDTH];
    wire signed [8*DATA_WIDTH-1:0] px1 =  din[8*DATA_WIDTH*1 +: 8*DATA_WIDTH];
    wire signed [8*DATA_WIDTH-1:0] px2 =  din[8*DATA_WIDTH*2 +: 8*DATA_WIDTH];
    wire signed [8*DATA_WIDTH-1:0] px3 =  din[8*DATA_WIDTH*3 +: 8*DATA_WIDTH];
    wire signed [8*DATA_WIDTH-1:0] px4 =  din[8*DATA_WIDTH*4 +: 8*DATA_WIDTH];
    wire signed [8*DATA_WIDTH-1:0] px5 =  din[8*DATA_WIDTH*5 +: 8*DATA_WIDTH];
    wire signed [8*DATA_WIDTH-1:0] px6 =  din[8*DATA_WIDTH*6 +: 8*DATA_WIDTH];
    wire signed [8*DATA_WIDTH-1:0] px7 =  din[8*DATA_WIDTH*7 +: 8*DATA_WIDTH];
    wire signed [8*DATA_WIDTH-1:0] px8 =  din[8*DATA_WIDTH*8 +: 8*DATA_WIDTH];
    
    wire signed [9*DATA_WIDTH-1:0] ch0 = {
        px8[DATA_WIDTH*0 +: DATA_WIDTH], 
        px7[DATA_WIDTH*0 +: DATA_WIDTH], 
        px6[DATA_WIDTH*0 +: DATA_WIDTH], 
        px5[DATA_WIDTH*0 +: DATA_WIDTH],
        px4[DATA_WIDTH*0 +: DATA_WIDTH],
        px3[DATA_WIDTH*0 +: DATA_WIDTH],
        px2[DATA_WIDTH*0 +: DATA_WIDTH],
        px1[DATA_WIDTH*0 +: DATA_WIDTH],
        px0[DATA_WIDTH*0 +: DATA_WIDTH]
    };
    
    wire signed [9*DATA_WIDTH-1:0] ch1 = {
        px8[DATA_WIDTH*1 +: DATA_WIDTH], 
        px7[DATA_WIDTH*1 +: DATA_WIDTH], 
        px6[DATA_WIDTH*1 +: DATA_WIDTH], 
        px5[DATA_WIDTH*1 +: DATA_WIDTH],
        px4[DATA_WIDTH*1 +: DATA_WIDTH],
        px3[DATA_WIDTH*1 +: DATA_WIDTH],
        px2[DATA_WIDTH*1 +: DATA_WIDTH],
        px1[DATA_WIDTH*1 +: DATA_WIDTH],
        px0[DATA_WIDTH*1 +: DATA_WIDTH]
    };
    
    wire signed [9*DATA_WIDTH-1:0] ch2 = {
        px8[DATA_WIDTH*2 +: DATA_WIDTH], 
        px7[DATA_WIDTH*2 +: DATA_WIDTH], 
        px6[DATA_WIDTH*2 +: DATA_WIDTH], 
        px5[DATA_WIDTH*2 +: DATA_WIDTH],
        px4[DATA_WIDTH*2 +: DATA_WIDTH],
        px3[DATA_WIDTH*2 +: DATA_WIDTH],
        px2[DATA_WIDTH*2 +: DATA_WIDTH],
        px1[DATA_WIDTH*2 +: DATA_WIDTH],
        px0[DATA_WIDTH*2 +: DATA_WIDTH]
    };
    
    wire signed [9*DATA_WIDTH-1:0] ch3 = {
        px8[DATA_WIDTH*3 +: DATA_WIDTH], 
        px7[DATA_WIDTH*3 +: DATA_WIDTH], 
        px6[DATA_WIDTH*3 +: DATA_WIDTH], 
        px5[DATA_WIDTH*3 +: DATA_WIDTH],
        px4[DATA_WIDTH*3 +: DATA_WIDTH],
        px3[DATA_WIDTH*3 +: DATA_WIDTH],
        px2[DATA_WIDTH*3 +: DATA_WIDTH],
        px1[DATA_WIDTH*3 +: DATA_WIDTH],
        px0[DATA_WIDTH*3 +: DATA_WIDTH]
    };
    
    wire signed [9*DATA_WIDTH-1:0] ch4 = {
        px8[DATA_WIDTH*4 +: DATA_WIDTH], 
        px7[DATA_WIDTH*4 +: DATA_WIDTH], 
        px6[DATA_WIDTH*4 +: DATA_WIDTH], 
        px5[DATA_WIDTH*4 +: DATA_WIDTH],
        px4[DATA_WIDTH*4 +: DATA_WIDTH],
        px3[DATA_WIDTH*4 +: DATA_WIDTH],
        px2[DATA_WIDTH*4 +: DATA_WIDTH],
        px1[DATA_WIDTH*4 +: DATA_WIDTH],
        px0[DATA_WIDTH*4 +: DATA_WIDTH]
    };
    
    wire signed [9*DATA_WIDTH-1:0] ch5 = {
        px8[DATA_WIDTH*5 +: DATA_WIDTH], 
        px7[DATA_WIDTH*5 +: DATA_WIDTH], 
        px6[DATA_WIDTH*5 +: DATA_WIDTH], 
        px5[DATA_WIDTH*5 +: DATA_WIDTH],
        px4[DATA_WIDTH*5 +: DATA_WIDTH],
        px3[DATA_WIDTH*5 +: DATA_WIDTH],
        px2[DATA_WIDTH*5 +: DATA_WIDTH],
        px1[DATA_WIDTH*5 +: DATA_WIDTH],
        px0[DATA_WIDTH*5 +: DATA_WIDTH]
    };
    
    wire signed [9*DATA_WIDTH-1:0] ch6 = {
        px8[DATA_WIDTH*6 +: DATA_WIDTH], 
        px7[DATA_WIDTH*6 +: DATA_WIDTH], 
        px6[DATA_WIDTH*6 +: DATA_WIDTH], 
        px5[DATA_WIDTH*6 +: DATA_WIDTH],
        px4[DATA_WIDTH*6 +: DATA_WIDTH],
        px3[DATA_WIDTH*6 +: DATA_WIDTH],
        px2[DATA_WIDTH*6 +: DATA_WIDTH],
        px1[DATA_WIDTH*6 +: DATA_WIDTH],
        px0[DATA_WIDTH*6 +: DATA_WIDTH]
    };
    
    wire signed [9*DATA_WIDTH-1:0] ch7 = {
        px8[DATA_WIDTH*7 +: DATA_WIDTH], 
        px7[DATA_WIDTH*7 +: DATA_WIDTH], 
        px6[DATA_WIDTH*7 +: DATA_WIDTH], 
        px5[DATA_WIDTH*7 +: DATA_WIDTH],
        px4[DATA_WIDTH*7 +: DATA_WIDTH],
        px3[DATA_WIDTH*7 +: DATA_WIDTH],
        px2[DATA_WIDTH*7 +: DATA_WIDTH],
        px1[DATA_WIDTH*7 +: DATA_WIDTH],
        px0[DATA_WIDTH*7 +: DATA_WIDTH]
    };
    
    assign dout = {ch7, ch6, ch5, ch4, ch3, ch2, ch1, ch0};
//    assign dout = {ch0, ch1, ch2, ch3, ch4, ch5, ch6, ch7};
    assign valid_out = valid_in;

endmodule