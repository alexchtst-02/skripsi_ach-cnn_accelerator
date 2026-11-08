`timescale 1ns / 1ps

module mac_9 #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire signed [9*DATA_WIDTH-1:0] din_pack,
    input wire signed [9*16-1:0] param_pack,
    
    output reg valid_out,
    output reg signed [DATA_WIDTH+16+5-1:0] dout
);

    localparam integer MULT_WIDTH = DATA_WIDTH+16;

    wire signed [DATA_WIDTH-1:0] d0 = din_pack[0*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d1 = din_pack[1*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d2 = din_pack[2*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d3 = din_pack[3*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d4 = din_pack[4*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d5 = din_pack[5*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d6 = din_pack[6*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d7 = din_pack[7*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d8 = din_pack[8*DATA_WIDTH +: DATA_WIDTH];
    
    wire signed [15:0] w0 = param_pack[0*16 +: 16];
    wire signed [15:0] w1 = param_pack[1*16 +: 16];
    wire signed [15:0] w2 = param_pack[2*16 +: 16];
    wire signed [15:0] w3 = param_pack[3*16 +: 16];
    wire signed [15:0] w4 = param_pack[4*16 +: 16];
    wire signed [15:0] w5 = param_pack[5*16 +: 16];
    wire signed [15:0] w6 = param_pack[6*16 +: 16];
    wire signed [15:0] w7 = param_pack[7*16 +: 16];
    wire signed [15:0] w8 = param_pack[8*16 +: 16];
    
    (* use_dsp = "yes" *)
    reg signed [MULT_WIDTH-1:0] mult0_s1;
    (* use_dsp = "yes" *)
    reg signed [MULT_WIDTH-1:0] mult1_s1;
    (* use_dsp = "yes" *)
    reg signed [MULT_WIDTH-1:0] mult2_s1;
    (* use_dsp = "yes" *)
    reg signed [MULT_WIDTH-1:0] mult3_s1;
    (* use_dsp = "yes" *)
    reg signed [MULT_WIDTH-1:0] mult4_s1;
    (* use_dsp = "yes" *)
    reg signed [MULT_WIDTH-1:0] mult5_s1;
    (* use_dsp = "yes" *)
    reg signed [MULT_WIDTH-1:0] mult6_s1;
    (* use_dsp = "yes" *)
    reg signed [MULT_WIDTH-1:0] mult7_s1;
    (* use_dsp = "yes" *)
    reg signed [MULT_WIDTH-1:0] mult8_s1;
    
    reg valid_s1;
    
    (* use_dsp = "no" *)
    reg signed [MULT_WIDTH+1-1:0] mult_add0_s2;
    (* use_dsp = "no" *)
    reg signed [MULT_WIDTH+1-1:0] mult_add1_s2;
    (* use_dsp = "no" *)
    reg signed [MULT_WIDTH+1-1:0] mult_add2_s2;
    (* use_dsp = "no" *)
    reg signed [MULT_WIDTH+1-1:0] mult_add3_s2;
    
    reg signed [MULT_WIDTH-1:0] mult_d_s2;
    
    reg valid_s2;
    
    (* use_dsp = "no" *)
    reg signed [MULT_WIDTH+2-1:0] mult_add0_s3;
    (* use_dsp = "no" *)
    reg signed [MULT_WIDTH+2-1:0] mult_add1_s3;
    
    reg signed [MULT_WIDTH-1:0] mult_d_s3;
    
    reg valid_s3;
    
    (* use_dsp = "no" *)
    reg signed [MULT_WIDTH+3-1:0] mult_add0_s4;
    
    reg signed [MULT_WIDTH-1:0] mult_d_s4;
    
    reg valid_s4;
    
    reg signed [MULT_WIDTH+4-1:0] dout_s5;
    reg valid_s5;
    
    always @(posedge clk) begin
        if (!rstn) begin
            valid_out <= 1'b0;
            valid_s1 <= 1'b0;
            valid_s2 <= 1'b0;
            valid_s3 <= 1'b0;
            valid_s4 <= 1'b0;
            valid_s5 <= 1'b0;
            
            dout <= {(MULT_WIDTH+5){1'b0}};
        end
        else begin
            
            valid_s1 <= valid_in;
            valid_s2 <= valid_s1;
            valid_s3 <= valid_s2;
            valid_s4 <= valid_s3;
            valid_s5 <= valid_s4;
            valid_out <= valid_s5;
            
            if (valid_in) begin
                mult0_s1 <= $signed(d0) * $signed(w0);
                mult1_s1 <= $signed(d1) * $signed(w1);
                mult2_s1 <= $signed(d2) * $signed(w2);
                mult3_s1 <= $signed(d3) * $signed(w3);
                mult4_s1 <= $signed(d4) * $signed(w4);
                mult5_s1 <= $signed(d5) * $signed(w5);
                mult6_s1 <= $signed(d6) * $signed(w6);
                mult7_s1 <= $signed(d7) * $signed(w7);
                mult8_s1 <= $signed(d8) * $signed(w8);
            end
            
            if (valid_s1) begin
                mult_add0_s2 <= 
                    $signed({mult0_s1[MULT_WIDTH-1], mult0_s1}) + 
                    $signed({mult1_s1[MULT_WIDTH-1], mult1_s1});
                    
                mult_add1_s2 <= 
                    $signed({mult2_s1[MULT_WIDTH-1], mult2_s1}) + 
                    $signed({mult3_s1[MULT_WIDTH-1], mult3_s1});
                
                mult_add2_s2 <= 
                    $signed({mult4_s1[MULT_WIDTH-1], mult4_s1}) + 
                    $signed({mult5_s1[MULT_WIDTH-1], mult5_s1});
                    
                mult_add3_s2 <= 
                    $signed({mult6_s1[MULT_WIDTH-1], mult6_s1}) + 
                    $signed({mult7_s1[MULT_WIDTH-1], mult7_s1});
                    
                mult_d_s2 <= mult8_s1;
            end
            
            if (valid_s2) begin
                mult_add0_s3 <= 
                    $signed({mult_add0_s2[MULT_WIDTH+1-1], mult_add0_s2}) + 
                    $signed({mult_add1_s2[MULT_WIDTH+1-1], mult_add1_s2});
                    
                mult_add1_s3 <= 
                    $signed({mult_add2_s2[MULT_WIDTH+1-1], mult_add2_s2}) + 
                    $signed({mult_add3_s2[MULT_WIDTH+1-1], mult_add3_s2});
                    
                mult_d_s3 <= mult_d_s2;
            end
            
            if (valid_s3) begin
                mult_add0_s4 <= 
                    $signed({mult_add0_s3[MULT_WIDTH+2-1], mult_add0_s3}) + 
                    $signed({mult_add1_s3[MULT_WIDTH+2-1], mult_add1_s3});
                
                mult_d_s4 <= mult_d_s3;
            end
            
            if (valid_s4) begin
                dout_s5 <= 
                    $signed({mult_add0_s4[MULT_WIDTH+3-1], mult_add0_s4}) +
                    $signed({ { 4{mult_d_s4[MULT_WIDTH-1]} }, mult_d_s4});
            end
            
            if (valid_s5) begin
                dout <=  {dout_s5[MULT_WIDTH+4-1], dout_s5};
            end
        end
    end

endmodule
