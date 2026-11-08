`timescale 1ns / 1ps

module buffer_acc_4ch #(
    parameter integer DATA_WIDTH = 48
)(
    input  wire clk,
    input  wire rstn,

    input  wire valid_in,
    input  wire signed [DATA_WIDTH-1:0] din,

    output reg valid_out,
    output reg [4*DATA_WIDTH-1:0] dout
);

    reg signed [DATA_WIDTH-1:0] data [0:3];
    reg [2:0] counter;

    integer i;

    always @(posedge clk) begin
        if (!rstn) begin
            counter <= 3'b000;
            valid_out <= 1'b0;
            dout <= {(4*DATA_WIDTH){1'b0}};
        end
        else begin

            valid_out <= 1'b0;
            if (valid_in) begin
            
                data[counter] <= din;
                
                if (counter == 3'd3) begin
                
                    for (i = 0; i < 3; i = i + 1) begin
                        dout[i*DATA_WIDTH +: DATA_WIDTH] <= data[i];
                    end
                    
                    dout[3*DATA_WIDTH +: DATA_WIDTH] <= din;
                    
                    valid_out <= 1'b1;
                    counter <= 3'd0;
                    
                end
                else begin
                    counter <= counter + 1'b1;
                end
            end
        end
    end

endmodule