`timescale 1ns / 1ps

module mac_72 #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_din,
    input wire signed [DATA_WIDTH*9*8-1:0] din,
    input wire valid_param,
    input wire signed [16*9*8-1:0] param,
    
    output wire valid_out,
    output wire [(DATA_WIDTH+16+5)*8-1:0] dout
);
    
    localparam integer DOUT_WIDTH = DATA_WIDTH+16+5;
    
    wire valid_in = valid_param && valid_din;
    
    wire signed [DATA_WIDTH*9-1:0] d0 = din[0*DATA_WIDTH*9 +: DATA_WIDTH*9];
    wire signed [DATA_WIDTH*9-1:0] d1 = din[1*DATA_WIDTH*9 +: DATA_WIDTH*9];
    wire signed [DATA_WIDTH*9-1:0] d2 = din[2*DATA_WIDTH*9 +: DATA_WIDTH*9];
    wire signed [DATA_WIDTH*9-1:0] d3 = din[3*DATA_WIDTH*9 +: DATA_WIDTH*9];
    wire signed [DATA_WIDTH*9*4-1:0] din_36_0 = {d3, d2, d1, d0};
    
    wire signed [DATA_WIDTH*9-1:0] d4 = din[4*DATA_WIDTH*9 +: DATA_WIDTH*9];
    wire signed [DATA_WIDTH*9-1:0] d5 = din[5*DATA_WIDTH*9 +: DATA_WIDTH*9];
    wire signed [DATA_WIDTH*9-1:0] d6 = din[6*DATA_WIDTH*9 +: DATA_WIDTH*9];
    wire signed [DATA_WIDTH*9-1:0] d7 = din[7*DATA_WIDTH*9 +: DATA_WIDTH*9];
    wire signed [DATA_WIDTH*9*4-1:0] din_36_1 = {d7, d6, d5, d4};
    
    wire signed [16*9-1:0] w0 = param[0*16*9 +: 16*9];
    wire signed [16*9-1:0] w1 = param[1*16*9 +: 16*9];
    wire signed [16*9-1:0] w2 = param[2*16*9 +: 16*9];
    wire signed [16*9-1:0] w3 = param[3*16*9 +: 16*9];
    wire signed [16*9*4-1:0] param_36_0 = {w3, w2, w1, w0};
    
    wire signed [16*9-1:0] w4 = param[4*16*9 +: 16*9];
    wire signed [16*9-1:0] w5 = param[5*16*9 +: 16*9];
    wire signed [16*9-1:0] w6 = param[6*16*9 +: 16*9];
    wire signed [16*9-1:0] w7 = param[7*16*9 +: 16*9];
    wire signed [16*4*9-1:0] param_36_1 = {w7, w6, w5, w4};
    
    wire valid_out0, valid_out1;
    wire [4*DOUT_WIDTH-1:0] dout0, dout1;
    
    mac_36 #( .DATA_WIDTH(DATA_WIDTH) ) u_mac_36_0 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), 
        .din(din_36_0), 
        .param(param_36_0),
        
        .valid_out(valid_out0), .dout_pack(dout0)
    );
    
    mac_36 #( .DATA_WIDTH(DATA_WIDTH) ) u_mac_36_1 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), 
        .din(din_36_1), 
        .param(param_36_1),
        
        .valid_out(valid_out1), .dout_pack(dout1)
    );
    
    assign valid_out = valid_out0 | valid_out1;
    assign dout = {dout1, dout0};
    
endmodule
