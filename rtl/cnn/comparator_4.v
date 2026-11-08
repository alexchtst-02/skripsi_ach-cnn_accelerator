`timescale 1ns / 1ps

module comparator_4 #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire [4*DATA_WIDTH-1:0] din_pack,
    
    output reg valid_out,
    output reg signed [DATA_WIDTH-1:0] dout
);
    wire signed [DATA_WIDTH-1:0] d0 = din_pack[0*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d1 = din_pack[1*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d2 = din_pack[2*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d3 = din_pack[3*DATA_WIDTH +: DATA_WIDTH];
    
    reg signed [DATA_WIDTH-1:0] comp_s1;
    reg signed [DATA_WIDTH-1:0] d2_s1;
    reg signed [DATA_WIDTH-1:0] d3_s1;
    reg valid_s1;
    
    reg signed [DATA_WIDTH-1:0] comp_s2;
    reg signed [DATA_WIDTH-1:0] d3_s2;
    reg signed valid_s2;
    
    reg signed [DATA_WIDTH-1:0] comp_s3;
    reg valid_s3;
    

    always @(posedge clk) begin
        if (!rstn) begin
            valid_out <= 1'b0;
            valid_s1 <= 1'b0;
            valid_s2 <= 1'b0;
            valid_s3 <= 1'b0;
            dout <= {DATA_WIDTH{1'b0}};
        end        
        else begin
            valid_s1 <= valid_in;
            valid_s2 <= valid_s1;
            valid_s3 <= valid_s2;
            valid_out <= valid_s3;
            
            if (valid_in) begin
                comp_s1 <= (d0 > d1) ? d0 : d1;
                d2_s1 <= d2;
                d3_s1 <= d3;
            end
            
            if (valid_s1) begin
                comp_s2 <= (comp_s1 > d2_s1) ? comp_s1 : d2_s1;
                d3_s2 <= d3_s1;
            end
            
            if (valid_s2) begin
                comp_s3 <= (comp_s2 > d3_s2) ? comp_s2 : d3_s2;
            end
            
            if (valid_s3) begin
                dout <= comp_s3;
            end
            
        end
    end

endmodule
