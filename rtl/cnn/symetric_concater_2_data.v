`timescale 1ns / 1ps

module symetric_concater_2_data #(
    parameter integer WORD_WIDTH = 192
)(
    input wire ready_to_upstream0,
    input wire valid_in0,
    input wire [WORD_WIDTH-1:0] din0,
    
    input wire ready_to_upstream1,
    input wire valid_in1,
    input wire [WORD_WIDTH-1:0] din1,
    
    output wire ready_to_upstraeam_out,
    output wire valid_in_out,
    output wire [WORD_WIDTH*2-1:0] din_out
);

    assign ready_to_upstraeam_out = ready_to_upstream0 && ready_to_upstream1;
    assign valid_in_out = valid_in0 && valid_in1;
    assign din_out = {din1, din0};

endmodule
