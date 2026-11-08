`timescale 1ns / 1ps
`default_nettype none

module cnn_frame_gate #(
    parameter integer FRAME_PIXELS = 784
)(
    input  wire       clk,
    input  wire       rstn,

    input  wire       fifo_empty,
    output wire       fifo_rd_en,
    input  wire [8:0] fifo_rd_data,

    input  wire       cnn_ready,
    output reg        cnn_valid,
    output reg  [7:0] cnn_din,

    output reg        frame_accepted,
    output reg        frame_dropped,
    output reg        sync_error
);
    localparam [1:0] S_ALIGN     = 2'd0,
                     S_STREAM    = 2'd1,
                     S_WAIT_BUSY = 2'd2;

    localparam integer CNT_W = $clog2(FRAME_PIXELS + 1);

    reg [1:0]       state;
    reg [CNT_W-1:0] count;
    reg             rd_pending;

    wire       word_valid = rd_pending;
    wire       word_sof   = fifo_rd_data[8];
    wire [7:0] word_px    = fifo_rd_data[7:0];

    assign fifo_rd_en = !fifo_empty && !rd_pending && (state != S_WAIT_BUSY);

    always @(posedge clk) begin
        if (!rstn) begin
            state          <= S_ALIGN;
            count          <= {CNT_W{1'b0}};
            rd_pending     <= 1'b0;
            cnn_valid      <= 1'b0;
            cnn_din        <= 8'd0;
            frame_accepted <= 1'b0;
            frame_dropped  <= 1'b0;
            sync_error     <= 1'b0;
        end else begin
            rd_pending     <= fifo_rd_en;
            cnn_valid      <= 1'b0;
            frame_accepted <= 1'b0;
            frame_dropped  <= 1'b0;

            case (state)
                S_ALIGN: begin
                    if (word_valid && word_sof) begin
                        if (cnn_ready) begin
                            cnn_valid      <= 1'b1;
                            cnn_din        <= word_px;
                            count          <= 1;
                            frame_accepted <= 1'b1;
                            state          <= (FRAME_PIXELS == 1) ? S_WAIT_BUSY : S_STREAM;
                        end else begin
                            frame_dropped  <= 1'b1;
                        end
                    end
                end

                S_STREAM: begin
                    if (word_valid) begin
                        if (word_sof)
                            sync_error <= 1'b1;
                        cnn_valid <= 1'b1;
                        cnn_din   <= word_px;
                        count     <= count + 1'b1;
                        if (count == FRAME_PIXELS-1)
                            state <= S_WAIT_BUSY;
                    end
                end

                S_WAIT_BUSY: begin
                    if (!cnn_ready)
                        state <= S_ALIGN;
                end

                default: state <= S_ALIGN;
            endcase
        end
    end
endmodule

`default_nettype wire
