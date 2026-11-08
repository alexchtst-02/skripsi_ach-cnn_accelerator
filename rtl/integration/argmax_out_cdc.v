`timescale 1ns / 1ps
`default_nettype none

module argmax_out_cdc #(
    parameter integer DATA_WIDTH = 4
)(
    input  wire                  src_clk,
    input  wire                  src_rstn,
    input  wire                  src_valid,
    input  wire [DATA_WIDTH-1:0] src_data,

    input  wire                  dst_clk,
    input  wire                  dst_rstn,
    output reg  [DATA_WIDTH-1:0] dst_data,
    output reg                   dst_has_data,
    output reg                   dst_update
);
    reg [DATA_WIDTH-1:0] src_hold;
    reg                  src_toggle;

    always @(posedge src_clk) begin
        if (!src_rstn) begin
            src_hold   <= {DATA_WIDTH{1'b0}};
            src_toggle <= 1'b0;
        end else if (src_valid) begin
            src_hold   <= src_data;
            src_toggle <= ~src_toggle;
        end
    end

    wire toggle_sync;
    cdc_bit_sync u_toggle_sync (
        .aclk(dst_clk), .aresetn(dst_rstn),
        .in(src_toggle), .out(toggle_sync)
    );

    reg toggle_seen;
    always @(posedge dst_clk) begin
        if (!dst_rstn) begin
            toggle_seen  <= 1'b0;
            dst_data     <= {DATA_WIDTH{1'b0}};
            dst_has_data <= 1'b0;
            dst_update   <= 1'b0;
        end else begin
            dst_update <= 1'b0;
            if (toggle_sync != toggle_seen) begin
                toggle_seen  <= toggle_sync;
                dst_data     <= src_hold;
                dst_has_data <= 1'b1;
                dst_update   <= 1'b1;
            end
        end
    end
endmodule

`default_nettype wire
