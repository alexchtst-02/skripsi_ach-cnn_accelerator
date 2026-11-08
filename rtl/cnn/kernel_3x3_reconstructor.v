`timescale 1ns / 1ps

module kernel_3x3_reconstructor #(
    parameter integer DATA_WIDTH = 24,
    parameter integer LINE_WIDTH = 28
)(
    input wire clk,
    input wire rstn,
    
    input wire clear_reset_kernel,
    
    input wire ready_from_downstream,
    input wire valid_in,
    input wire [DATA_WIDTH*8-1:0] din,
    
    output wire ready_to_upstream,
    output wire valid_out,
    output reg [DATA_WIDTH*8*9-1:0] dout
);
    localparam integer MAX_LINE_DEPTH = LINE_WIDTH*2 + 3;
    
    reg [9:0] h_counter, v_counter;
    reg [DATA_WIDTH*8-1:0] data_shift_register [0:MAX_LINE_DEPTH-1];
    reg valid_out_r;
    
    assign valid_out = valid_out_r;
    assign ready_to_upstream = (!valid_out) || ready_from_downstream;
    wire fire_fill_data = valid_in && ready_to_upstream;
    
    integer i;
    
    always @(posedge clk) begin
        if (!rstn || clear_reset_kernel) begin
            dout <= {(DATA_WIDTH*8*9){1'b0}};
            h_counter <= 10'b0;
            v_counter <= 10'b0;
            valid_out_r <= 1'b0;
        end
        else begin
            if (valid_out_r && ready_from_downstream)
                valid_out_r <= 1'b0;
    
           if (fire_fill_data) begin
                valid_out_r <= (v_counter >= 2) && (h_counter >= 2);
            
                dout <= {
                    din,
                    data_shift_register[0],
                    data_shift_register[1],
                    
                    data_shift_register[LINE_WIDTH-1],
                    data_shift_register[LINE_WIDTH],
                    data_shift_register[LINE_WIDTH+1],
                    
                    data_shift_register[LINE_WIDTH*2-1],
                    data_shift_register[LINE_WIDTH*2],
                    data_shift_register[LINE_WIDTH*2+1]
                };
            
                for (i = 0; i < MAX_LINE_DEPTH-1; i = i + 1)
                    data_shift_register[i+1] <= data_shift_register[i];
                data_shift_register[0] <= din;
                
                if (h_counter == LINE_WIDTH-1) begin
                    h_counter <= 10'd0;
                    if (v_counter == LINE_WIDTH-1)
                        v_counter <= 10'd0;
                    else
                        v_counter <= v_counter + 1'b1;
                end
                else
                    h_counter <= h_counter + 1'b1;
            end
        end
    end

endmodule