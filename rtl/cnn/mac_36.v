`timescale 1ns / 1ps

module mac_36 #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire signed [DATA_WIDTH*9*4-1:0] din,
    input wire signed [16*9*4-1:0] param,
    
    output wire valid_out,
    output wire [(DATA_WIDTH+16+5)*4-1:0] dout_pack
);
    localparam integer DOUT_WIDTH = DATA_WIDTH+16+5;
    
    wire signed [DATA_WIDTH*9-1:0] d0 = din[0*DATA_WIDTH*9 +: DATA_WIDTH*9];
    wire signed [DATA_WIDTH*9-1:0] d1 = din[1*DATA_WIDTH*9 +: DATA_WIDTH*9];
    wire signed [DATA_WIDTH*9-1:0] d2 = din[2*DATA_WIDTH*9 +: DATA_WIDTH*9];
    wire signed [DATA_WIDTH*9-1:0] d3 = din[3*DATA_WIDTH*9 +: DATA_WIDTH*9];
    
    wire signed [16*9-1:0] w0 = param[0*16*9 +: 16*9];
    wire signed [16*9-1:0] w1 = param[1*16*9 +: 16*9];
    wire signed [16*9-1:0] w2 = param[2*16*9 +: 16*9];
    wire signed [16*9-1:0] w3 = param[3*16*9 +: 16*9];
    
    wire valid_out0, valid_out1, valid_out2, valid_out3;
    wire signed [DOUT_WIDTH-1:0] dout0, dout1, dout2, dout3;
    
    mac_9 #( .DATA_WIDTH(DATA_WIDTH) ) u_mac_9_0 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), 
        .din_pack(d0), 
        .param_pack(w0),
        
        .valid_out(valid_out0), .dout(dout0)
    );
    
     mac_9 #( .DATA_WIDTH(DATA_WIDTH) ) u_mac_9_1 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), 
        .din_pack(d1), 
        .param_pack(w1),
        
        .valid_out(valid_out1), .dout(dout1)
    );
    
     mac_9 #( .DATA_WIDTH(DATA_WIDTH) ) u_mac_9_2 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), 
        .din_pack(d2), 
        .param_pack(w2),
        
        .valid_out(valid_out2), .dout(dout2)
    );
    
     mac_9 #( .DATA_WIDTH(DATA_WIDTH) ) u_mac_9_3 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), 
        .din_pack(d3), 
        .param_pack(w3),
        
        .valid_out(valid_out3), .dout(dout3)
    );
    
    assign valid_out = valid_out0 | valid_out1 | valid_out2 | valid_out3;
    assign dout_pack = {dout3, dout2, dout1, dout0};
    
endmodule
