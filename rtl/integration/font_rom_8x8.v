`timescale 1ns / 1ps
`default_nettype none

module font_rom_8x8 (
    input  wire [4:0] glyph,
    input  wire [2:0] row,
    output reg  [7:0] bits
);
    localparam [4:0] G_P = 5'd10, G_R = 5'd11, G_E = 5'd12, G_D = 5'd13,
                     G_I = 5'd14, G_C = 5'd15, G_T = 5'd16, G_SPACE = 5'd17,
                     G_DASH = 5'd18;

    reg [63:0] glyph_bits;

    always @(*) begin
        case (glyph)
            5'd0:    glyph_bits = 64'h3C_66_6E_76_66_66_3C_00;
            5'd1:    glyph_bits = 64'h18_38_18_18_18_18_7E_00;
            5'd2:    glyph_bits = 64'h3C_66_06_0C_30_60_7E_00;
            5'd3:    glyph_bits = 64'h3C_66_06_1C_06_66_3C_00;
            5'd4:    glyph_bits = 64'h0C_1C_3C_6C_7E_0C_0C_00;
            5'd5:    glyph_bits = 64'h7E_60_7C_06_06_66_3C_00;
            5'd6:    glyph_bits = 64'h3C_66_60_7C_66_66_3C_00;
            5'd7:    glyph_bits = 64'h7E_66_0C_18_18_18_18_00;
            5'd8:    glyph_bits = 64'h3C_66_66_3C_66_66_3C_00;
            5'd9:    glyph_bits = 64'h3C_66_66_3E_06_66_3C_00;
            G_P:     glyph_bits = 64'h7C_66_66_7C_60_60_60_00;
            G_R:     glyph_bits = 64'h7C_66_66_7C_78_6C_66_00;
            G_E:     glyph_bits = 64'h7E_60_60_78_60_60_7E_00;
            G_D:     glyph_bits = 64'h78_6C_66_66_66_6C_78_00;
            G_I:     glyph_bits = 64'h3C_18_18_18_18_18_3C_00;
            G_C:     glyph_bits = 64'h3C_66_60_60_60_66_3C_00;
            G_T:     glyph_bits = 64'h7E_18_18_18_18_18_18_00;
            G_DASH:  glyph_bits = 64'h00_00_00_7E_00_00_00_00;
            default: glyph_bits = 64'h00_00_00_00_00_00_00_00;
        endcase

        bits = glyph_bits[63 - row*8 -: 8];
    end
endmodule

`default_nettype wire
