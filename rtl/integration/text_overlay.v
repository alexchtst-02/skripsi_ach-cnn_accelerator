`timescale 1ns / 1ps
`default_nettype none

module text_overlay #(
    parameter integer FRAME_WIDTH  = 640,
    parameter integer FRAME_HEIGHT = 480,
    parameter integer SCALE        = 3,
    parameter integer TEXT_X       = 188,
    parameter integer TEXT_Y       = 400,
    parameter integer BOX_PAD      = 4,
    parameter integer LATCH_Y      = 390,
    parameter [15:0]  FG_COLOR     = 16'h0FFF,
    parameter [15:0]  BG_COLOR     = 16'h0000
)(
    input  wire        clk,
    input  wire        rstn,

    input  wire        pix_valid,
    input  wire [9:0]  pix_x,
    input  wire [9:0]  pix_y,
    input  wire [15:0] din,

    input  wire [3:0]  pred_class,
    input  wire        pred_valid,

    output wire [15:0] dout
);
    localparam integer NUM_CHARS = 11;
    localparam integer CHAR_W    = 8 * SCALE;
    localparam integer TEXT_W    = NUM_CHARS * CHAR_W;
    localparam integer TEXT_H    = 8 * SCALE;
    localparam integer BOX_X0    = TEXT_X - BOX_PAD;
    localparam integer BOX_Y0    = TEXT_Y - BOX_PAD;
    localparam integer BOX_X1    = TEXT_X + TEXT_W + BOX_PAD;
    localparam integer BOX_Y1    = TEXT_Y + TEXT_H + BOX_PAD;

    initial begin
        if (SCALE < 1 || BOX_X0 < 0 || BOX_Y0 < 0 ||
            BOX_X1 > FRAME_WIDTH || BOX_Y1 > FRAME_HEIGHT ||
            LATCH_Y >= BOX_Y0 || LATCH_Y >= FRAME_HEIGHT)
            $fatal(1, "text_overlay: posisi teks/latch di luar frame atau latch setelah kotak teks");
    end

    reg [3:0] shown_class;
    reg       shown_valid;
    always @(posedge clk) begin
        if (!rstn) begin
            shown_class <= 4'd0;
            shown_valid <= 1'b0;
        end else if (pix_valid && pix_y == LATCH_Y) begin
            shown_class <= pred_class;
            shown_valid <= pred_valid && (pred_class <= 4'd9);
        end
    end

    wire in_box  = (pix_x >= BOX_X0) && (pix_x < BOX_X1) &&
                   (pix_y >= BOX_Y0) && (pix_y < BOX_Y1);
    wire in_text = (pix_x >= TEXT_X) && (pix_x < TEXT_X + TEXT_W) &&
                   (pix_y >= TEXT_Y) && (pix_y < TEXT_Y + TEXT_H);

    wire [9:0] rel_x    = pix_x - TEXT_X[9:0];
    wire [9:0] rel_y    = pix_y - TEXT_Y[9:0];
    wire [9:0] char_idx = rel_x / CHAR_W;
    wire [9:0] char_px  = rel_x % CHAR_W;
    wire [2:0] font_col = char_px / SCALE;
    wire [2:0] font_row = rel_y / SCALE;

    reg [4:0] glyph;
    always @(*) begin
        case (char_idx)
            10'd0:   glyph = 5'd10;
            10'd1:   glyph = 5'd11;
            10'd2:   glyph = 5'd12;
            10'd3:   glyph = 5'd13;
            10'd4:   glyph = 5'd14;
            10'd5:   glyph = 5'd15;
            10'd6:   glyph = 5'd16;
            10'd7:   glyph = 5'd12;
            10'd8:   glyph = 5'd13;
            10'd9:   glyph = 5'd17;
            10'd10:  glyph = shown_valid ? {1'b0, shown_class} : 5'd18;
            default: glyph = 5'd17;
        endcase
    end

    wire [7:0] row_bits;
    font_rom_8x8 u_font (.glyph(glyph), .row(font_row), .bits(row_bits));

    wire font_on = in_text && row_bits[3'd7 - font_col];

    assign dout = font_on ? FG_COLOR :
                  in_box  ? BG_COLOR :
                            din;
endmodule

`default_nettype wire
