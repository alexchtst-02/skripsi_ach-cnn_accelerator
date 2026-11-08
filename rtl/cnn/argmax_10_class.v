`timescale 1ns / 1ps

module argmax_10_class #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire [DATA_WIDTH*10-1:0] din,
    
    output reg valid_out,
    output reg [3:0] class_out
);
    
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
    
    reg signed [DATA_WIDTH-1:0] max_d0_level0;
    reg [3:0] idx0_level0;
    reg signed [DATA_WIDTH-1:0] max_d1_level0;
    reg [3:0] idx1_level0;
    reg signed [DATA_WIDTH-1:0] max_d2_level0;
    reg [3:0] idx2_level0;
    reg signed [DATA_WIDTH-1:0] max_d3_level0;
    reg [3:0] idx3_level0;
    reg signed [DATA_WIDTH-1:0] max_d4_level0;
    reg [3:0] idx4_level0;
    reg valid_s0;
    
    reg signed [DATA_WIDTH-1:0] max_d0_level1;
    reg [3:0] idx0_level1;
    reg signed [DATA_WIDTH-1:0] max_d1_level1;
    reg [3:0] idx1_level1;
    reg signed [DATA_WIDTH-1:0] max_d2_level1;
    reg [3:0] idx2_level1;
    reg valid_s1;
    
    reg signed [DATA_WIDTH-1:0] max_d0_level2;
    reg [3:0] idx0_level2;
    reg signed [DATA_WIDTH-1:0] max_d1_level2;
    reg [3:0] idx1_level2;
    reg valid_s2;
    
    reg signed [DATA_WIDTH-1:0] max_d0_level3;
    reg [3:0] idx0_level3;
    reg valid_s3;
    
    always @(posedge clk) begin
        if (!rstn) begin
            valid_s0 <= 1'b0;
            valid_s1 <= 1'b0;
            valid_s2 <= 1'b0;
            valid_s3 <= 1'b0;
            valid_out <= 1'b0;
            class_out <= 4'b0;
        end
        else begin
            valid_s0 <= valid_in;
            valid_s1 <= valid_s0;
            valid_s2 <= valid_s1;
            valid_s3 <= valid_s2;
            valid_out <= valid_s3;
            
            if (valid_in) begin
                max_d0_level0 <= (d0 >= d1) ? d0 : d1;
                idx0_level0 <= (d0 >= d1) ? 4'd0 : 4'd1;
                
                max_d1_level0 <= (d2 >= d3) ? d2 : d3;
                idx1_level0 <= (d2 >= d3) ? 4'd2 : 4'd3;
                
                max_d2_level0 <= (d4 >= d5) ? d4 : d5;
                idx2_level0 <= (d4 >= d5) ? 4'd4 : 4'd5;
                
                max_d3_level0 <= (d6 >= d7) ? d6 : d7;
                idx3_level0 <= (d6 >= d7) ? 4'd6 : 4'd7;
                
                max_d4_level0 <= (d8 >= d9) ? d8 : d9;
                idx4_level0 <= (d8 >= d9) ? 4'd8 : 4'd9;
            end
            
            if (valid_s0) begin
                max_d0_level1 <= (max_d0_level0 >= max_d1_level0) ? max_d0_level0 : max_d1_level0;
                idx0_level1 <= (max_d0_level0 >= max_d1_level0) ? idx0_level0 : idx1_level0;
                
                max_d1_level1 <= (max_d2_level0 >= max_d3_level0) ? max_d2_level0 : max_d3_level0;
                idx1_level1 <= (max_d2_level0 >= max_d3_level0) ? idx2_level0 : idx3_level0;
                
                max_d2_level1 <= max_d4_level0;
                idx2_level1 <= idx4_level0;
            end
            
            if (valid_s1) begin
                max_d0_level2 <= (max_d0_level1 >= max_d1_level1) ? max_d0_level1 : max_d1_level1;
                idx0_level2 <= (max_d0_level1 >= max_d1_level1) ? idx0_level1 : idx1_level1;
                
                max_d1_level2 <= max_d2_level1;
                idx1_level2 <= idx2_level1;
            end
            
            if (valid_s2) begin
                max_d0_level3 <= (max_d0_level2 >= max_d1_level2) ? max_d0_level2 : max_d1_level2;
                idx0_level3 <= (max_d0_level2 >= max_d1_level2) ? idx0_level2 : idx1_level2;
            end
            
            if (valid_s3) begin
                class_out <= idx0_level3;
            end
        end
    end
    
endmodule

