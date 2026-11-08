`timescale 1ns / 1ps

module accumulator_4ch #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire signed [4*DATA_WIDTH-1:0] din,
    
    output reg valid_out,
    output reg signed [DATA_WIDTH+2-1:0] dout
);

    wire signed [DATA_WIDTH-1:0] d0 = din[0*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d1 = din[1*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d2 = din[2*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d3 = din[3*DATA_WIDTH +: DATA_WIDTH];
    
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc0_s1;
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc1_s1;
    reg valid_s1;
    
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH+1:0] acc0_s2;
    
    reg valid_s2;
    
    
    always @(posedge clk) begin
        if (!rstn) begin
            valid_s1 <= 1'b0;
            valid_s2 <= 1'b0;
            valid_out <= 1'b0;
            dout <= {(DATA_WIDTH+2){1'b0}};
        end
        else begin
            
            valid_s1 <= valid_in;
            valid_s2 <= valid_s1;
            valid_out <= valid_s2; 
            
            if (valid_in) begin
                acc0_s1 <= 
                    $signed({d0[DATA_WIDTH-1], d0}) + 
                    $signed({d1[DATA_WIDTH-1], d1});
                
                acc1_s1 <= 
                    $signed({d2[DATA_WIDTH-1], d2}) + 
                    $signed({d3[DATA_WIDTH-1], d3});
                
            end
            
            if (valid_s1) begin
                acc0_s2 <= 
                    $signed({acc0_s1[DATA_WIDTH+1-1], acc0_s1}) + 
                    $signed({acc1_s1[DATA_WIDTH+1-1], acc1_s1});
                
            end
            
            if (valid_s2) begin
                dout <= acc0_s2;
            end
        end
    end
    
endmodule
