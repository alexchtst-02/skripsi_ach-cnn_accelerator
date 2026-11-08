`timescale 1ns / 1ps

module group_feature_fifo #(
    parameter integer WORD_WIDTH = 24*8,
    parameter integer DEPTH = 1024,
    parameter integer MAX_OCCUPANCY = 676,
    parameter integer ADDRESS_WIDTH = 10
)(  
    input wire clk,
    input wire rstn,
    
    input wire enable_next_read,
    
    input wire clear,
    input wire valid_in,
    input wire [WORD_WIDTH-1:0] din,
    
    output wire [ADDRESS_WIDTH-1:0] wr_cnt,
    output wire [ADDRESS_WIDTH-1:0] rd_cnt,
    output reg valid_out,
    output reg [WORD_WIDTH-1:0] dout
);  
    localparam integer MIN_WRITE_COUNT = 2;
    
    (* ram_style = "block" *)
    reg [WORD_WIDTH-1:0] mem [0:DEPTH-1];
    
    reg [ADDRESS_WIDTH-1:0] rd_ptr, wr_ptr;
    
    assign wr_cnt = wr_ptr;
    assign rd_cnt = rd_ptr;
    
    wire accept = valid_out && enable_next_read;
    wire out_free = !valid_out || enable_next_read;
    
    wire allowed_to_read  = 
        out_free && 
            (wr_ptr > rd_ptr) && 
                (rd_ptr < MAX_OCCUPANCY);
                
    wire allowed_to_write = (wr_ptr < MAX_OCCUPANCY) && valid_in;
    
    always @(posedge clk) begin
        if (!rstn || clear) begin
            valid_out <= 1'b0;
            dout <= {WORD_WIDTH{1'b0}};
            rd_ptr <= {ADDRESS_WIDTH{1'b0}};
            wr_ptr <= {ADDRESS_WIDTH{1'b0}};
        end
        else begin
            if (allowed_to_read) begin
                valid_out <= 1'b1;
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1'b1;
            end
            else if (accept)
                valid_out <= 1'b0;
    
            if (allowed_to_write) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1'b1;
            end
        end
    end
    
endmodule
