`timescale 1ns / 1ps

module symetric_concater_4_data#(
    parameter integer WORD_WIDTH = 192
)(
    input wire ready_to_upstream0,
    input wire valid_in0,
    input wire [WORD_WIDTH-1:0] din0,
    
    input wire ready_to_upstream1,
    input wire valid_in1,
    input wire [WORD_WIDTH-1:0] din1,
    
    input wire ready_to_upstream2,
    input wire valid_in2,
    input wire [WORD_WIDTH-1:0] din2,
    
    input wire ready_to_upstream3,
    input wire valid_in3,
    input wire [WORD_WIDTH-1:0] din3,
    
    output wire ready_to_upstraeam_out,
    output wire valid_in_out,
    output wire [WORD_WIDTH*4-1:0] din_out
);

    assign ready_to_upstraeam_out = ready_to_upstream0 && ready_to_upstream1 && ready_to_upstream2 && ready_to_upstream3;
    assign valid_in_out = valid_in0 && valid_in1 && valid_in2 && valid_in3;
    assign din_out = {din3, din2, din1, din0};

endmodule