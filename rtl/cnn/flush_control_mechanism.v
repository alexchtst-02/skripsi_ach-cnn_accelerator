`timescale 1ns / 1ps

module flush_control_mechanism #(
    parameter integer ADDRESS_WIDTH = 10,
    parameter integer MAX_PIXELS = 28*28,
    parameter integer CONV1_POOL1 = 13*13,
    parameter integer CONV2 = 11*11*2,
    parameter integer POOL2 = 5*5*2,
    parameter integer CONV3 = 3*3*4,
    parameter integer POOL3 = 1*1*4
)(
    input wire rstn,
    
    input wire [ADDRESS_WIDTH-1:0] pixel_counter,
    input wire [ADDRESS_WIDTH-1:0] occ_conv1_pool1,
    input wire [ADDRESS_WIDTH-1:0] occ_conv2,
    input wire [ADDRESS_WIDTH-1:0] occ_pool2,
    input wire [ADDRESS_WIDTH-1:0] occ_conv3,
    input wire [ADDRESS_WIDTH-1:0] occ_pool3,
    input wire valid_argmax,
    
    output wire ready_to_upstream_out,
    
    // global flush to drain and re start and clear the data again
    output reg flush,
    output reg flush_imidiate
);
    wire done_pixel_stream = (pixel_counter == MAX_PIXELS);
    wire done_conv1_pool1 = (occ_conv1_pool1 == CONV1_POOL1);
    wire done_conv2 = (occ_conv2 == CONV2);
    wire done_pool2 = (occ_pool2 == POOL2);
    wire done_conv3 = (occ_conv3 == CONV3);
    wire done_pool3 = (occ_pool3 == POOL3);
    
    wire process_finish = done_pool3 && valid_argmax;
    wire prcocess_all_done = done_pixel_stream && done_conv1_pool1 && done_conv2 && done_pool2 && done_conv3 && done_pool3;
    
    assign ready_to_upstream_out = done_pixel_stream ? 1'b0 : 1'b1;
    
    always @(*) begin
        if (!rstn) begin
            flush = 1'b0;
            flush_imidiate = 1'b0;
        end
        else begin
            flush = 1'b0;
            flush_imidiate = 1'b0;
            
            if (process_finish) begin
                flush_imidiate = 1'b1;
            end
            
            if (prcocess_all_done) begin
                flush = 1'b1;
            end
        end
    end

endmodule