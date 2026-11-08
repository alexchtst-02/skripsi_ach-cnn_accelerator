`timescale 1ns / 1ps

module accumulator_partial #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire [2*DATA_WIDTH-1:0] din,
    output reg valid_out,
    output reg signed [DATA_WIDTH:0] dout
);

    wire signed [DATA_WIDTH-1:0] din0 = din[DATA_WIDTH*0 +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] din1 = din[DATA_WIDTH*1 +: DATA_WIDTH];
    
    reg signed [DATA_WIDTH-1:0] din0_s1;
    reg signed [DATA_WIDTH-1:0] din1_s1;
    reg valid_s1;
    
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] dout_s2;
    reg valid_s2;
    
    always @(posedge clk) begin
        if (!rstn) begin
            valid_s1 <= 1'b0;
            valid_s2 <= 1'b0;
            valid_out <= 1'b0;
            dout <= {(DATA_WIDTH+1){1'b0}};
        end
        else begin
            
            valid_s1 <= valid_in;
            valid_s2 <= valid_s1;
            valid_out <= valid_s2; 
            
            if (valid_in) begin
                din0_s1 <= din0;
                din1_s1 <= din1;
            end
            
            if (valid_s1) begin
                dout_s2 <= 
                    $signed({din0_s1[DATA_WIDTH-1], din0_s1}) + 
                    $signed({din1_s1[DATA_WIDTH-1], din1_s1});
            end
            
            if (valid_s2) begin
                dout <= dout_s2;
            end
        end
    end
    
endmodule
