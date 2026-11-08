`timescale 1ns / 1ps
`default_nettype none

module cnn_subsystem #(
    parameter integer FRAME_PIXELS     = 784,
    parameter integer STAGE_FIFO_DEPTH = 1024
)(
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 100000000" *)
    input  wire       clk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 vga_clk CLK" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vga_clk, FREQ_HZ 25000000" *)
    input  wire       vga_clk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 sys_rstn RST" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME sys_rstn, POLARITY ACTIVE_LOW" *)
    input  wire       sys_rstn,

    input  wire       cnn_valid_in,
    input  wire       cnn_sof_in,
    input  wire [7:0] cnn_din,

    output wire [3:0] pred_class,
    output wire       pred_valid,
    output wire       pred_update,

    output wire [3:0] class_out,
    output wire       class_valid,

    output wire       stage_overflow,
    output wire       frame_dropped,
    output wire       sync_error
);
    wire cnn_rstn, vga_rstn;
    resetn_sync u_cnn_rstn (.clk(clk),     .arstn(sys_rstn), .srstn(cnn_rstn));
    resetn_sync u_vga_rstn (.clk(vga_clk), .arstn(sys_rstn), .srstn(vga_rstn));

    wire       cnn_ready;
    wire       cnn_valid;
    wire [7:0] cnn_data;

    cnn_stream_bridge #(
        .FRAME_PIXELS(FRAME_PIXELS), .FIFO_DEPTH(STAGE_FIFO_DEPTH)
    ) u_bridge (
        .sys_rstn(sys_rstn),
        .vga_clk(vga_clk),
        .s_valid(cnn_valid_in), .s_sof(cnn_sof_in), .s_data(cnn_din),
        .overflow(stage_overflow),
        .cnn_clk(clk),
        .m_ready(cnn_ready), .m_valid(cnn_valid), .m_data(cnn_data),
        .frame_accepted(), .frame_dropped(frame_dropped), .sync_error(sync_error)
    );

    cnn_accelerator u_cnn (
        .clk(clk), .rstn(cnn_rstn),
        .valid_in(cnn_valid), .din(cnn_data),
        .ready_to_upstream(cnn_ready),
        .valid_argmax(class_valid), .class_out(class_out)
    );

    argmax_out_cdc #(
        .DATA_WIDTH(4)
    ) u_argmax_cdc (
        .src_clk(clk), .src_rstn(cnn_rstn),
        .src_valid(class_valid), .src_data(class_out),
        .dst_clk(vga_clk), .dst_rstn(vga_rstn),
        .dst_data(pred_class), .dst_has_data(pred_valid), .dst_update(pred_update)
    );
endmodule

`default_nettype wire
