`timescale 1ns / 1ps

module bias_10_class_accumulator #(
    parameter integer DATA_WIDTH = 45
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire [10*DATA_WIDTH-1:0] din,
    input wire valid_bias,
    input wire [16*10-1:0] bias,
    
    output reg valid_out,
    output reg [10*(DATA_WIDTH+1)-1:0] dout
);
    localparam integer PARAM_EXTD_BIT = DATA_WIDTH - 16;

    wire valid_din = valid_in && valid_bias;
    
    wire signed [DATA_WIDTH-1:0] d0 = din[DATA_WIDTH*0 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d1 = din[DATA_WIDTH*1 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d2 = din[DATA_WIDTH*2 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d3 = din[DATA_WIDTH*3 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d4 = din[DATA_WIDTH*4 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d5 = din[DATA_WIDTH*5 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d6 = din[DATA_WIDTH*6 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d7 = din[DATA_WIDTH*7 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d8 = din[DATA_WIDTH*8 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d9 = din[DATA_WIDTH*9 +: DATA_WIDTH];
    
    wire signed [15:0] b0 = bias[16*0 +: 16];
    wire signed [15:0] b1 = bias[16*1 +: 16];
    wire signed [15:0] b2 = bias[16*2 +: 16];
    wire signed [15:0] b3 = bias[16*3 +: 16];
    wire signed [15:0] b4 = bias[16*4 +: 16];
    wire signed [15:0] b5 = bias[16*5 +: 16];
    wire signed [15:0] b6 = bias[16*6 +: 16];
    wire signed [15:0] b7 = bias[16*7 +: 16];
    wire signed [15:0] b8 = bias[16*8 +: 16];
    wire signed [15:0] b9 = bias[16*9 +: 16];
    
    wire signed [DATA_WIDTH-1:0] b0_ext = {{PARAM_EXTD_BIT{b0[15]}}, b0} <<< 14;
    wire signed [DATA_WIDTH-1:0] b1_ext = {{PARAM_EXTD_BIT{b1[15]}}, b1} <<< 14;
    wire signed [DATA_WIDTH-1:0] b2_ext = {{PARAM_EXTD_BIT{b2[15]}}, b2} <<< 14;
    wire signed [DATA_WIDTH-1:0] b3_ext = {{PARAM_EXTD_BIT{b3[15]}}, b3} <<< 14;
    wire signed [DATA_WIDTH-1:0] b4_ext = {{PARAM_EXTD_BIT{b4[15]}}, b4} <<< 14;
    wire signed [DATA_WIDTH-1:0] b5_ext = {{PARAM_EXTD_BIT{b5[15]}}, b5} <<< 14;
    wire signed [DATA_WIDTH-1:0] b6_ext = {{PARAM_EXTD_BIT{b6[15]}}, b6} <<< 14;
    wire signed [DATA_WIDTH-1:0] b7_ext = {{PARAM_EXTD_BIT{b7[15]}}, b7} <<< 14;
    wire signed [DATA_WIDTH-1:0] b8_ext = {{PARAM_EXTD_BIT{b8[15]}}, b8} <<< 14;
    wire signed [DATA_WIDTH-1:0] b9_ext = {{PARAM_EXTD_BIT{b9[15]}}, b9} <<< 14;
    
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc0_s1;
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc1_s1;
    
    reg signed [DATA_WIDTH-1:0] d2_s1;
    reg signed [DATA_WIDTH-1:0] d3_s1;
    reg signed [DATA_WIDTH-1:0] d4_s1;
    reg signed [DATA_WIDTH-1:0] d5_s1;
    reg signed [DATA_WIDTH-1:0] d6_s1;
    reg signed [DATA_WIDTH-1:0] d7_s1;
    reg signed [DATA_WIDTH-1:0] d8_s1;
    reg signed [DATA_WIDTH-1:0] d9_s1;
    reg signed [DATA_WIDTH-1:0] b2_s1;
    reg signed [DATA_WIDTH-1:0] b3_s1;
    reg signed [DATA_WIDTH-1:0] b4_s1;
    reg signed [DATA_WIDTH-1:0] b5_s1;
    reg signed [DATA_WIDTH-1:0] b6_s1;
    reg signed [DATA_WIDTH-1:0] b7_s1;
    reg signed [DATA_WIDTH-1:0] b8_s1;
    reg signed [DATA_WIDTH-1:0] b9_s1;
    reg valid_s1;
    
    reg signed [DATA_WIDTH:0] acc0_s2;
    reg signed [DATA_WIDTH:0] acc1_s2;
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc2_s2;
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc3_s2;
    
    reg signed [DATA_WIDTH-1:0] d4_s2;
    reg signed [DATA_WIDTH-1:0] d5_s2;
    reg signed [DATA_WIDTH-1:0] d6_s2;
    reg signed [DATA_WIDTH-1:0] d7_s2;
    reg signed [DATA_WIDTH-1:0] d8_s2;
    reg signed [DATA_WIDTH-1:0] d9_s2;
    reg signed [DATA_WIDTH-1:0] b4_s2;
    reg signed [DATA_WIDTH-1:0] b5_s2;
    reg signed [DATA_WIDTH-1:0] b6_s2;
    reg signed [DATA_WIDTH-1:0] b7_s2;
    reg signed [DATA_WIDTH-1:0] b8_s2;
    reg signed [DATA_WIDTH-1:0] b9_s2;
    
    reg valid_s2;
    
    reg signed [DATA_WIDTH:0] acc0_s3;
    reg signed [DATA_WIDTH:0] acc1_s3;
    reg signed [DATA_WIDTH:0] acc2_s3;
    reg signed [DATA_WIDTH:0] acc3_s3;
    
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc4_s3;
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc5_s3;
    
    reg signed [DATA_WIDTH-1:0] d6_s3;
    reg signed [DATA_WIDTH-1:0] d7_s3;
    reg signed [DATA_WIDTH-1:0] d8_s3;
    reg signed [DATA_WIDTH-1:0] d9_s3;
    reg signed [DATA_WIDTH-1:0] b6_s3;
    reg signed [DATA_WIDTH-1:0] b7_s3;
    reg signed [DATA_WIDTH-1:0] b8_s3;
    reg signed [DATA_WIDTH-1:0] b9_s3;
    
    reg valid_s3;
    
    reg signed [DATA_WIDTH:0] acc0_s4;
    reg signed [DATA_WIDTH:0] acc1_s4;
    reg signed [DATA_WIDTH:0] acc2_s4;
    reg signed [DATA_WIDTH:0] acc3_s4;
    reg signed [DATA_WIDTH:0] acc4_s4;
    reg signed [DATA_WIDTH:0] acc5_s4;
    
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc6_s4;
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc7_s4;
    reg signed [DATA_WIDTH-1:0] d8_s4;
    reg signed [DATA_WIDTH-1:0] d9_s4;
    reg signed [DATA_WIDTH-1:0] b8_s4;
    reg signed [DATA_WIDTH-1:0] b9_s4;
    
    reg valid_s4;
    
    reg signed [DATA_WIDTH:0] acc0_s5;
    reg signed [DATA_WIDTH:0] acc1_s5;
    reg signed [DATA_WIDTH:0] acc2_s5;
    reg signed [DATA_WIDTH:0] acc3_s5;
    reg signed [DATA_WIDTH:0] acc4_s5;
    reg signed [DATA_WIDTH:0] acc5_s5;
    reg signed [DATA_WIDTH:0] acc6_s5;
    reg signed [DATA_WIDTH:0] acc7_s5;
    
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc8_s5;
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc9_s5;
    
    reg valid_s5;
    
    always @(posedge clk) begin
        if (!rstn) begin
            valid_s1 <= 1'b0;
            valid_s2 <= 1'b0;
            valid_s3 <= 1'b0;
            valid_s4 <= 1'b0;
            valid_s5 <= 1'b0;
            valid_out <= 1'b0;
            dout <= {(10*(DATA_WIDTH+1)){1'b0}};
        end
        else begin
            valid_s1 <= valid_din;
            valid_s2 <= valid_s1;
            valid_s3 <= valid_s2;
            valid_s4 <= valid_s3;
            valid_s5 <= valid_s4;
            valid_out <= valid_s5;
            
            if (valid_din) begin
                acc0_s1 <= $signed({ d0[DATA_WIDTH-1], d0 }) + $signed({ b0_ext[DATA_WIDTH-1], b0_ext });
                acc1_s1 <= $signed({ d1[DATA_WIDTH-1], d1 }) + $signed({ b1_ext[DATA_WIDTH-1], b1_ext });
                
                d2_s1 <= d2;
                d3_s1 <= d3;
                d4_s1 <= d4;
                d5_s1 <= d5;
                d6_s1 <= d6;
                d7_s1 <= d7;
                d8_s1 <= d8;
                d9_s1 <= d9;
                
                b2_s1 <= b2_ext;
                b3_s1 <= b3_ext;
                b4_s1 <= b4_ext;
                b5_s1 <= b5_ext;
                b6_s1 <= b6_ext;
                b7_s1 <= b7_ext;
                b8_s1 <= b8_ext;
                b9_s1 <= b9_ext;
            end
            
            if (valid_s1) begin
                acc0_s2 <= acc0_s1;
                acc1_s2 <= acc1_s1;
                acc2_s2 <= $signed({ d2_s1[DATA_WIDTH-1], d2_s1 }) + $signed({ b2_s1[DATA_WIDTH-1], b2_s1 });
                acc3_s2 <= $signed({ d3_s1[DATA_WIDTH-1], d3_s1 }) + $signed({ b3_s1[DATA_WIDTH-1], b3_s1 });
                
                d4_s2 <= d4_s1;
                d5_s2 <= d5_s1;
                d6_s2 <= d6_s1;
                d7_s2 <= d7_s1;
                d8_s2 <= d8_s1;
                d9_s2 <= d9_s1;
                
                b4_s2 <= b4_s1;
                b5_s2 <= b5_s1;
                b6_s2 <= b6_s1;
                b7_s2 <= b7_s1;
                b8_s2 <= b8_s1;
                b9_s2 <= b9_s1;
            end
            
            if (valid_s2) begin
                acc0_s3 <= acc0_s2;
                acc1_s3 <= acc1_s2;
                acc2_s3 <= acc2_s2;
                acc3_s3 <= acc3_s2;
                
                acc4_s3 <= $signed({ d4_s2[DATA_WIDTH-1], d4_s2 }) + $signed({ b4_s2[DATA_WIDTH-1], b4_s2 });
                acc5_s3 <= $signed({ d5_s2[DATA_WIDTH-1], d5_s2 }) + $signed({ b5_s2[DATA_WIDTH-1], b5_s2 });
                
                d6_s3 <= d6_s2;
                d7_s3 <= d7_s2;
                d8_s3 <= d8_s2;
                d9_s3 <= d9_s2;
                
                b6_s3 <= b6_s2;
                b7_s3 <= b7_s2;
                b8_s3 <= b8_s2;
                b9_s3 <= b9_s2;
            end
            
            if (valid_s3) begin
                acc0_s4 <= acc0_s3;
                acc1_s4 <= acc1_s3;
                acc2_s4 <= acc2_s3;
                acc3_s4 <= acc3_s3;
                acc4_s4 <= acc4_s3;
                acc5_s4 <= acc5_s3;
                
                acc6_s4 <= $signed({ d6_s3[DATA_WIDTH-1], d6_s3 }) + $signed({ b6_s3[DATA_WIDTH-1], b6_s3 });
                acc7_s4 <= $signed({ d7_s3[DATA_WIDTH-1], d7_s3 }) + $signed({ b7_s3[DATA_WIDTH-1], b7_s3 });
                
                d8_s4 <= d8_s3;
                d9_s4 <= d9_s3;
                
                b8_s4 <= b8_s3;
                b9_s4 <= b9_s3;
            end
            
            if (valid_s4) begin
                acc0_s5 <= acc0_s4;
                acc1_s5 <= acc1_s4;
                acc2_s5 <= acc2_s4;
                acc3_s5 <= acc3_s4;
                acc4_s5 <= acc4_s4;
                acc5_s5 <= acc5_s4;
                acc6_s5 <= acc6_s4;
                acc7_s5 <= acc7_s4;
                
                acc8_s5 <= $signed({ d8_s4[DATA_WIDTH-1], d8_s4 }) + $signed({ b8_s4[DATA_WIDTH-1], b8_s4 });
                acc9_s5 <= $signed({ d9_s4[DATA_WIDTH-1], d9_s4 }) + $signed({ b9_s4[DATA_WIDTH-1], b9_s4 });
            end
            
            if (valid_s5) begin
                dout <= {acc9_s5, acc8_s5, acc7_s5, acc6_s5, acc5_s5, acc4_s5, acc3_s5, acc2_s5, acc1_s5, acc0_s5};
            end
        end
    end
    
endmodule
