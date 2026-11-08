`timescale 1ns / 1ps

module buffer_acc_partial #(
    parameter integer DATA_WIDTH = 48
)(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire signed [DATA_WIDTH-1:0] din,
    
    output reg valid_out,
    output reg [2*DATA_WIDTH-1:0] dout
);

    reg [DATA_WIDTH-1:0] data [0:1];
    reg [1:0] counter;
    
    integer i;
    
    always @(posedge clk) begin
        if (!rstn) begin
            counter <= 2'b00;
            dout <= {(2*DATA_WIDTH){1'b0}};
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;
            if (valid_in) begin
                
                data[counter] <= din;
                
                if (counter == 2'd1) begin
                
                    for (i = 0; i < 1; i = i + 1) begin
                        dout[i*DATA_WIDTH +: DATA_WIDTH] <= data[i];
                    end
                    
                    dout[1*DATA_WIDTH +: DATA_WIDTH] <= din;
                    valid_out <= 1'b1;
                    counter <= 2'd0;
                    
                end
                else begin
                    counter <= counter + 1'b1;
                end
            end
        end
    end

endmodule
