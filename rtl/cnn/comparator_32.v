`timescale 1ns / 1ps

module comparator_32 #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire [8*4*DATA_WIDTH-1:0] din,
    
    output wire valid_out,
    output wire signed [8*DATA_WIDTH-1:0] dout
);

    wire [DATA_WIDTH*4-1:0] d0 = din[0*DATA_WIDTH*4 +: DATA_WIDTH*4];
    wire [DATA_WIDTH*4-1:0] d1 = din[1*DATA_WIDTH*4 +: DATA_WIDTH*4];
    wire [DATA_WIDTH*4-1:0] d2 = din[2*DATA_WIDTH*4 +: DATA_WIDTH*4];
    wire [DATA_WIDTH*4-1:0] d3 = din[3*DATA_WIDTH*4 +: DATA_WIDTH*4];
    wire [DATA_WIDTH*4-1:0] d4 = din[4*DATA_WIDTH*4 +: DATA_WIDTH*4];
    wire [DATA_WIDTH*4-1:0] d5 = din[5*DATA_WIDTH*4 +: DATA_WIDTH*4];
    wire [DATA_WIDTH*4-1:0] d6 = din[6*DATA_WIDTH*4 +: DATA_WIDTH*4];
    wire [DATA_WIDTH*4-1:0] d7 = din[7*DATA_WIDTH*4 +: DATA_WIDTH*4];
    
    wire valid_out0, valid_out1, valid_out2, valid_out3, valid_out4, valid_out5, valid_out6, valid_out7;
    wire signed [23:0] dout0, dout1, dout2, dout3, dout4, dout5, dout6, dout7;
    
    comparator_4 #( .DATA_WIDTH(DATA_WIDTH) ) u_comp_4_0 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), .din_pack(d0),
        
        .valid_out(valid_out0), .dout(dout0)
    );
    
    comparator_4 #( .DATA_WIDTH(DATA_WIDTH) ) u_comp_4_1 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), .din_pack(d1),
        
        .valid_out(valid_out1), .dout(dout1)
    );
    
    comparator_4 #( .DATA_WIDTH(DATA_WIDTH) ) u_comp_4_2 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), .din_pack(d2),
        
        .valid_out(valid_out2), .dout(dout2)
    );
    
    comparator_4 #( .DATA_WIDTH(DATA_WIDTH) ) u_comp_4_3 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), .din_pack(d3),
        
        .valid_out(valid_out3), .dout(dout3)
    );
    
    comparator_4 #( .DATA_WIDTH(DATA_WIDTH) ) u_comp_4_4 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), .din_pack(d4),
        
        .valid_out(valid_out4), .dout(dout4)
    );
    
    comparator_4 #( .DATA_WIDTH(DATA_WIDTH) ) u_comp_4_5 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), .din_pack(d5),
        
        .valid_out(valid_out5), .dout(dout5)
    );
    
    comparator_4 #( .DATA_WIDTH(DATA_WIDTH) ) u_comp_4_6 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), .din_pack(d6),
        
        .valid_out(valid_out6), .dout(dout6)
    );
    
    comparator_4 #( .DATA_WIDTH(DATA_WIDTH) ) u_comp_4_7 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), .din_pack(d7),
        
        .valid_out(valid_out7), .dout(dout7)
    );
    
    assign valid_out = valid_out0 | valid_out1 | valid_out2 | valid_out3 | valid_out4 | valid_out5 | valid_out6 | valid_out7;
    assign dout = {dout7, dout6, dout5, dout4, dout3, dout2, dout1, dout0};
    

endmodule
