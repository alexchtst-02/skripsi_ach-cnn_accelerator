`timescale 1ns / 1ps

module convolver_engine #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire [DATA_WIDTH*8*9-1:0] din,
    
    input wire valid_weight,
    input wire [16*8*9-1:0] weight,
    
    output wire valid_out,
    output wire [(DATA_WIDTH+16+5)*8-1:0] dout
);
    
    wire valid_out_rmk;
    wire [DATA_WIDTH*8*9-1:0] dout_rmk;
    relayout_mac_kernel #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut_rmk (
        .valid_in(valid_in),
        .din(din),
        
        .valid_out(valid_out_rmk),
        .dout(dout_rmk)
    );
    
    mac_72  #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut_mac_72 (
        .clk(clk), .rstn(rstn),
        
        .valid_din(valid_out_rmk),
        .din(dout_rmk),
        .valid_param(valid_weight),
        .param(weight),
        
        .valid_out(valid_out),
        .dout(dout)
    );

endmodule
