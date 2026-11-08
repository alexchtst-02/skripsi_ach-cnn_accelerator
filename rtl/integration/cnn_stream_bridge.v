`timescale 1ns / 1ps
`default_nettype none

module cnn_stream_bridge #(
    parameter integer FRAME_PIXELS = 784,
    parameter integer FIFO_DEPTH   = 1024
)(
    input  wire       sys_rstn,

    input  wire       vga_clk,
    input  wire       s_valid,
    input  wire       s_sof,
    input  wire [7:0] s_data,
    output wire       overflow,

    input  wire       cnn_clk,
    input  wire       m_ready,
    output wire       m_valid,
    output wire [7:0] m_data,
    output wire       frame_accepted,
    output wire       frame_dropped,
    output wire       sync_error
);
    initial begin
        if (FIFO_DEPTH < FRAME_PIXELS || (FIFO_DEPTH & (FIFO_DEPTH-1)) != 0)
            $fatal(1, "cnn_stream_bridge: FIFO_DEPTH harus pangkat 2 dan >= FRAME_PIXELS");
    end

    wire vga_rstn, cnn_rstn;
    resetn_sync u_vga_rstn (.clk(vga_clk), .arstn(sys_rstn), .srstn(vga_rstn));
    resetn_sync u_cnn_rstn (.clk(cnn_clk), .arstn(sys_rstn), .srstn(cnn_rstn));

    wire       fifo_full, fifo_empty;
    wire       fifo_wr_en, fifo_rd_en;
    wire [8:0] fifo_wr_data, fifo_rd_data;

    cnn_stage_fifo_wr u_wr (
        .clk(vga_clk), .rstn(vga_rstn),
        .s_valid(s_valid), .s_sof(s_sof), .s_data(s_data),
        .fifo_full(fifo_full), .fifo_wr_en(fifo_wr_en), .fifo_wr_data(fifo_wr_data),
        .overflow(overflow)
    );

    async_fifo #(
        .WORD_WIDTH(9), .DEPTH(FIFO_DEPTH)
    ) u_stage_fifo (
        .wr_clk(vga_clk), .rd_clk(cnn_clk), .sys_rstn(sys_rstn),
        .wr_en(fifo_wr_en), .wr_in(fifo_wr_data),
        .rd_en(fifo_rd_en), .rd_out(fifo_rd_data),
        .full(fifo_full), .rd_level(), .wr_level(), .empty(fifo_empty)
    );

    cnn_frame_gate #(
        .FRAME_PIXELS(FRAME_PIXELS)
    ) u_gate (
        .clk(cnn_clk), .rstn(cnn_rstn),
        .fifo_empty(fifo_empty), .fifo_rd_en(fifo_rd_en), .fifo_rd_data(fifo_rd_data),
        .cnn_ready(m_ready), .cnn_valid(m_valid), .cnn_din(m_data),
        .frame_accepted(frame_accepted), .frame_dropped(frame_dropped),
        .sync_error(sync_error)
    );
endmodule

`default_nettype wire
