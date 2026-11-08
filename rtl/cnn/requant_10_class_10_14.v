`timescale 1ns / 1ps

module requant_10_class_10_14  #(
    parameter integer DATA_FRACT_BIT = 28,
    parameter integer DATA_INT_BIT = 17
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire [10*(DATA_FRACT_BIT + DATA_INT_BIT)-1:0] din,
    
    output reg valid_out,
    output reg [24*10-1:0] dout
);

    localparam integer FRACT_DIFF_BIT = DATA_FRACT_BIT - 14;
    localparam integer DATA_WIDTH = DATA_FRACT_BIT + DATA_INT_BIT;
    
    localparam signed [23:0] MAX_Q10_14 = 24'sh7FFFFF;
    localparam signed [23:0] MIN_Q10_14 = 24'sh800000;
    
    localparam integer SHIFTED_DATA_WIDTH = DATA_INT_BIT + 14;
    
    wire signed [DATA_WIDTH-1:0] d0 = din[0*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d1 = din[1*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d2 = din[2*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d3 = din[3*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d4 = din[4*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d5 = din[5*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d6 = din[6*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d7 = din[7*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d8 = din[8*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d9 = din[9*DATA_WIDTH +: DATA_WIDTH];
    
    wire signed [SHIFTED_DATA_WIDTH-1:0] shifted_data_0 = d0 >>> FRACT_DIFF_BIT;
    wire signed [SHIFTED_DATA_WIDTH-1:0] shifted_data_1 = d1 >>> FRACT_DIFF_BIT;
    wire signed [SHIFTED_DATA_WIDTH-1:0] shifted_data_2 = d2 >>> FRACT_DIFF_BIT;
    wire signed [SHIFTED_DATA_WIDTH-1:0] shifted_data_3 = d3 >>> FRACT_DIFF_BIT;
    wire signed [SHIFTED_DATA_WIDTH-1:0] shifted_data_4 = d4 >>> FRACT_DIFF_BIT;
    wire signed [SHIFTED_DATA_WIDTH-1:0] shifted_data_5 = d5 >>> FRACT_DIFF_BIT;
    wire signed [SHIFTED_DATA_WIDTH-1:0] shifted_data_6 = d6 >>> FRACT_DIFF_BIT;
    wire signed [SHIFTED_DATA_WIDTH-1:0] shifted_data_7 = d7 >>> FRACT_DIFF_BIT;
    wire signed [SHIFTED_DATA_WIDTH-1:0] shifted_data_8 = d8 >>> FRACT_DIFF_BIT;
    wire signed [SHIFTED_DATA_WIDTH-1:0] shifted_data_9 = d9 >>> FRACT_DIFF_BIT;
    
    function signed [23:0] saturated_output;
        input signed [SHIFTED_DATA_WIDTH-1:0] data;
        
        begin
            if (data > MAX_Q10_14)
                saturated_output = MAX_Q10_14;
                
            else if (data < MIN_Q10_14)
                saturated_output = MIN_Q10_14;
                
            else 
                saturated_output = data[23:0];
                
        end
    endfunction
    
    always @(posedge clk) begin
        if (!rstn) begin
            valid_out <= 1'b0;
            dout <= {( 10*24 ){1'b0}};
        end
        else begin
            valid_out <= 1'b0;

            if (valid_in) begin
                valid_out <= 1'b1;
                dout <= {
                    saturated_output(shifted_data_9),
                    saturated_output(shifted_data_8),
                    saturated_output(shifted_data_7),
                    saturated_output(shifted_data_6),
                    saturated_output(shifted_data_5),
                    saturated_output(shifted_data_4),
                    saturated_output(shifted_data_3),
                    saturated_output(shifted_data_2),
                    saturated_output(shifted_data_1), 
                    saturated_output(shifted_data_0)
                };
            end
        end
    end

endmodule
