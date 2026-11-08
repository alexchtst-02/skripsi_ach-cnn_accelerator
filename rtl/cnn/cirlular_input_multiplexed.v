`timescale 1ns / 1ps

module cirlular_input_multiplexed #(
    parameter integer DATA_WIDTH = 24,
    parameter integer DATA_NUM = 2,
    parameter integer TIME_MULTIPLEX = 16
)(
    input wire clk,
    input wire rstn,
    
    input wire clear_reset,
    
    input wire enable,
    
    input wire valid_in,
    input wire [DATA_WIDTH*DATA_NUM-1:0] din,
    
    output wire ready_to_upstream,
    
    output reg valid_out,
    output wire [DATA_WIDTH-1:0] dout
);

    reg [DATA_WIDTH*DATA_NUM-1:0] data_reg;
    reg [9:0] tmux_counter;
    
    assign dout = data_reg[DATA_WIDTH-1:0];
    
//    assign ready_to_upstream = ~valid_out;
    assign ready_to_upstream = enable && (!valid_out || tmux_counter == TIME_MULTIPLEX-1);
//    wire fire_in = !valid_out && enable && valid_in;
    wire fire_in = valid_in && ready_to_upstream;
    
    always @(posedge clk) begin
        if (!rstn || clear_reset) begin
            data_reg <= {(DATA_WIDTH*DATA_NUM){1'b0}};
            data_reg <= 1'b0;
            valid_out <= 1'b0;
            tmux_counter <= 10'b0;
        end
        
        else begin
            if (fire_in) begin
                data_reg <= din;
                valid_out <= 1'b1;
                tmux_counter <= 10'b0;
            end
            
            else begin
                if (enable) begin
                
                    if (DATA_NUM > 1) begin
                        data_reg <= {
                            data_reg[DATA_WIDTH-1:0],
                            data_reg[DATA_WIDTH*DATA_NUM-1:DATA_WIDTH]
                        };
                    end
                    
                    if (tmux_counter == TIME_MULTIPLEX - 1) begin
                        valid_out <= 1'b0;
                        tmux_counter <= 10'd0;
                    end
                    else begin
                        tmux_counter <= tmux_counter + 1'b1;
                    end
                end
            end
        end
    end

endmodule
