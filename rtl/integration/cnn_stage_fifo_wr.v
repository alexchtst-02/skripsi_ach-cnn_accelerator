`timescale 1ns / 1ps
`default_nettype none

module cnn_stage_fifo_wr (
    input  wire       clk,
    input  wire       rstn,

    input  wire       s_valid,
    input  wire       s_sof,
    input  wire [7:0] s_data,

    input  wire       fifo_full,
    output wire       fifo_wr_en,
    output wire [8:0] fifo_wr_data,

    output reg        overflow
);
    reg       valid_q;
    reg       sof_q;
    reg [7:0] data_q;

    always @(posedge clk) begin
        if (!rstn) begin
            valid_q  <= 1'b0;
            sof_q    <= 1'b0;
            data_q   <= 8'd0;
            overflow <= 1'b0;
        end else begin
            valid_q <= s_valid;
            sof_q   <= s_sof;
            data_q  <= s_data;
            if (valid_q && fifo_full)
                overflow <= 1'b1;
        end
    end

    assign fifo_wr_en   = valid_q && !fifo_full;
    assign fifo_wr_data = {sof_q, data_q};
endmodule

`default_nettype wire
