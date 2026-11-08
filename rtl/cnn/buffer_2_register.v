`timescale 1ns / 1ps

module buffer_2_register #(
    parameter integer WORD_WIDTH = 192
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire [WORD_WIDTH-1:0] din,
    
    output reg valid_out,
    output reg [WORD_WIDTH-1:0] dout
);
    reg [WORD_WIDTH-1:0] dout_buff;
    reg valid_out_buff;

    always @(posedge clk) begin
        if (!rstn) begin
            dout <= {WORD_WIDTH{1'b0}};
            valid_out <= 1'b0;
        end
        else begin
            dout <= dout_buff;
            dout_buff <= din;
            valid_out <= valid_out_buff;
            valid_out_buff <= valid_in;
        end
    end

endmodule
