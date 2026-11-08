`timescale 1ns / 1ps

module circular_counter_index #(
    parameter integer INDEX_WIDTH = 5,
    parameter integer MAX_INDEX = 7
)(
    input wire clk,
    input wire rstn,
    
    input wire enable,
    
    output reg valid_out,
    output reg [INDEX_WIDTH-1:0] id
);
    reg [INDEX_WIDTH-1:0] counter; 
    
    always @(posedge clk) begin
        if (!rstn) begin
            valid_out <= 1'b0;
            id <= {INDEX_WIDTH{1'b0}};
            counter <= {INDEX_WIDTH{1'b0}};
        end
        else begin
            valid_out <= 1'b0;
            if (enable) begin
                valid_out <= 1'b1;
                id <= counter;
                
                counter <= counter + 1'b1;
                
                if (counter == MAX_INDEX) begin
                    counter <= 1'b0;
                end
            end
        end
    end

endmodule
