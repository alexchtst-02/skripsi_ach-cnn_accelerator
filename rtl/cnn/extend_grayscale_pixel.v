`timescale 1ns / 1ps

module extend_grayscale_pixel(
    input wire clk,
    input wire rstn,

    input wire valid_in,
    input wire [7:0] din,

    output reg valid_out,
    output reg signed [24*8-1:0] dout
);
    wire signed [23:0] intial_data = $signed({16'b0, din}) <<< 14;

    always @(*) begin
        if (!rstn) begin
            valid_out = 1'b0;
            dout = 192'b0;
        end
        else begin
            valid_out = valid_in;
            dout = {8{intial_data}};
        end
    end
endmodule