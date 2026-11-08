`timescale 1ns / 1ps

module cnn_accelerator(
    input wire clk,
    input wire rstn,
    
    input wire valid_in,
    input wire [7:0] din,
    
    output wire ready_to_upstream,
    
    output wire valid_argmax,
    output wire [3:0] class_out
);

    wire ready_to_upstream_out_fcm;
    assign ready_to_upstream = ready_to_upstream_out_fcm;

    wire [9:0] wr_cnt_gff;
    wire [9:0] rd_cnt_gff;
    
    wire [9:0] wr_cnt_gff_pool1;
    wire [9:0] rd_cnt_gff_pool1;
    
    wire [9:0] wr_cnt_gff_conv2;
    wire [9:0] rd_cnt_gff_conv2;
    
    wire [9:0] wr_cnt_gff_pool2;
    wire [9:0] rd_cnt_gff_pool2;
    
    wire [9:0] wr_cnt_gff_conv3;
    wire [9:0] rd_cnt_gff_conv3;
    
    wire [9:0] wr_cnt_gff_pool3;
    wire [9:0] rd_cnt_gff_pool3;
    
    wire enable_next_read_gff;
    wire valid_out_gff;
    wire [7:0] dout_gff;

    wire global_flush_fcm;
    wire global_flush_imidiate_fcm;
    flush_control_mechanism #(
        .ADDRESS_WIDTH(10),
    
        .MAX_PIXELS(784),
        .CONV1_POOL1(169),
        .CONV2(242),
        .POOL2(50),
        .CONV3(36),
        .POOL3(4)
    ) uut_fcm (
        .rstn(rstn),
    
        .pixel_counter(wr_cnt_gff),
        .occ_conv1_pool1(rd_cnt_gff_pool1),
        .occ_conv2(rd_cnt_gff_conv2),
        .occ_pool2(rd_cnt_gff_pool2),
        .occ_conv3(rd_cnt_gff_conv3),
        .occ_pool3(rd_cnt_gff_pool3),
    
        .valid_argmax(valid_argmax),
    
        .ready_to_upstream_out(ready_to_upstream_out_fcm),
    
        .flush(global_flush_fcm),
        .flush_imidiate(global_flush_imidiate_fcm)
    );
    
    wire [7:0] pixel_data = din;
    wire valid_pixel_data = valid_in;
    
    wire enable_next_read_gff;
    wire valid_out_gff;
    wire [7:0] dout_gff;

    group_feature_fifo #(
        .WORD_WIDTH(8),
        .DEPTH(1024),
        .MAX_OCCUPANCY(784),
        .ADDRESS_WIDTH(10)
    ) uut_gff (
        .clk(clk), .rstn(rstn),

        .clear(global_flush_fcm),

        .enable_next_read(enable_next_read_gff),

        .valid_in(valid_pixel_data),
        .din(pixel_data),

        .wr_cnt(wr_cnt_gff),
        .rd_cnt(rd_cnt_gff),

        .valid_out(valid_out_gff),
        .dout(dout_gff)
    );

    wire valid_out_egp;
    wire [191:0] dout_egp;

    extend_grayscale_pixel uut_egp (
        .clk(clk), .rstn(rstn),

        .valid_in(valid_out_gff),
        .din(dout_gff),

        .valid_out(valid_out_egp),
        .dout(dout_egp)
    );
    
    
    wire valid_in_conv1 = valid_out_egp;
    wire [191:0] din_conv1 = dout_egp;
    wire raw_valid_out_conv1;
    wire [367:0] raw_dout_conv1;
    wire valid_out_conv1;
    wire [191:0] dout_conv1;
    conv1_layer uut_conv1 (
        .clk(clk), .rstn(rstn),

        .clear_reset(global_flush_fcm),

        .enable_input(1'b1),

        .valid_in(valid_in_conv1),
        .din(din_conv1),

        .ready_to_upstream(enable_next_read_gff),

        .raw_valid_out(raw_valid_out_conv1),
        .raw_dout(raw_dout_conv1),

        .valid_out(valid_out_conv1),
        .dout(dout_conv1)
    );
    
    wire ready_to_upstream_pool1;

    wire valid_in_pool1 = valid_out_conv1;
    wire [191:0] din_pool1 = dout_conv1;
    wire valid_out_pool1;
    wire [191:0] dout_pool1;

    pool1_layer uut_pool1 (
        .clk(clk), .rstn(rstn),

        .clear_reset(global_flush_fcm),

        .enable_input(1'b1),

        .valid_in(valid_in_pool1),
        .din(din_pool1),

        .ready_to_upstream(ready_to_upstream_pool1),

        .valid_out(valid_out_pool1),
        .dout(dout_pool1)
    );
    
    wire enable_next_read_gff_pool1;
    wire valid_out_gff_pool1;
    wire [191:0] dout_gff_pool1;
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(256),
        .MAX_OCCUPANCY(169),
        .ADDRESS_WIDTH(10)
    ) uut_gff_pool1 (
        .clk(clk), .rstn(rstn),

        .clear(global_flush_fcm),

        .enable_next_read(enable_next_read_gff_pool1),

        .valid_in(valid_out_pool1),
        .din(dout_pool1),

        .wr_cnt(wr_cnt_gff_pool1),
        .rd_cnt(rd_cnt_gff_pool1),

        .valid_out(valid_out_gff_pool1),
        .dout(dout_gff_pool1)
    );
    
    wire valid_in_conv2 = valid_out_gff_pool1;
    wire [191:0] din_conv2 = dout_gff_pool1;
    wire raw_valid_out_conv2;
    wire [391:0] raw_dout_conv2;
    wire valid_out_conv2;
    wire [191:0] dout_conv2;
    
    conv2_layer uut_conv2 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_conv2),
        .din(din_conv2),
        
        .ready_to_upstream(enable_next_read_gff_pool1),
        
        .raw_valid_out(raw_valid_out_conv2),
        .raw_dout(raw_dout_conv2),
        
        .valid_out(valid_out_conv2),
        .dout(dout_conv2)
    );
    
    wire enable_next_read_gff_conv2;
    wire valid_out_gff_conv2;
    wire [191:0] dout_gff_conv2;
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(256),
        .MAX_OCCUPANCY(242),
        .ADDRESS_WIDTH(10)
    ) uut_gff_conv2 (
        .clk(clk), .rstn(rstn),

        .clear(global_flush_fcm),

        .enable_next_read(enable_next_read_gff_conv2),

        .valid_in(valid_out_conv2),
        .din(dout_conv2),

        .wr_cnt(wr_cnt_gff_conv2),
        .rd_cnt(rd_cnt_gff_conv2),

        .valid_out(valid_out_gff_conv2),
        .dout(dout_gff_conv2)
    );
    
    wire valid_in_pool2 = valid_out_gff_conv2;
    wire [191:0] din_pool2 = dout_gff_conv2;
    wire valid_out_pool2;
    wire [191:0] dout_pool2;
    
    pool2_layer uut_pool2 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(global_flush_fcm),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_pool2),
        .din(din_pool2),
        
        .ready_to_upstream(enable_next_read_gff_conv2),
        
        .valid_out(valid_out_pool2),
        .dout(dout_pool2)
    );
    
    wire enable_next_read_gff_pool2;
    wire valid_out_gff_pool2;
    wire [191:0] dout_gff_pool2;
    
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(256),
        .MAX_OCCUPANCY(50),
        .ADDRESS_WIDTH(10)
    ) uut_gff_pool2 (
        .clk(clk), .rstn(rstn),
        
        .clear(global_flush_fcm),
        
        .enable_next_read(enable_next_read_gff_pool2),
        
        .valid_in(valid_out_pool2),
        .din(dout_pool2),
        
        .wr_cnt(wr_cnt_gff_pool2),
        .rd_cnt(rd_cnt_gff_pool2),
        
        .valid_out(valid_out_gff_pool2),
        .dout(dout_gff_pool2)
    );
    
    wire valid_in_conv3 = valid_out_gff_pool2;
    wire [191:0] din_conv3 = dout_gff_pool2;
    wire raw_valid_out_conv3;
    wire [399:0] raw_dout_conv3;
    wire valid_out_conv3;
    wire [191:0] dout_conv3;
    
    conv3_layer uut_conv3 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(global_flush_fcm),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_conv3),
        .din(din_conv3),
        
        .ready_to_upstream(enable_next_read_gff_pool2),
        
        .raw_valid_out(raw_valid_out_conv3),
        .raw_dout(raw_dout_conv3),
        
        .valid_out(valid_out_conv3),
        .dout(dout_conv3)
    );
    
    wire enable_next_read_gff_conv3;
    wire valid_out_gff_conv3;
    wire [191:0] dout_gff_conv3;
    
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(128),
        .MAX_OCCUPANCY(36),
        .ADDRESS_WIDTH(10)
    ) uut_gff_conv3 (
        .clk(clk), .rstn(rstn),
        
        .clear(global_flush_fcm),
        
        .enable_next_read(enable_next_read_gff_conv3),
        
        .valid_in(valid_out_conv3),
        .din(dout_conv3),
        
        .wr_cnt(wr_cnt_gff_conv3),
        .rd_cnt(rd_cnt_gff_conv3),
        
        .valid_out(valid_out_gff_conv3),
        .dout(dout_gff_conv3)
    );
    
    wire valid_in_pool3 = valid_out_gff_conv3;
    wire [191:0] din_pool3 = dout_gff_conv3;
    wire valid_out_pool3;
    wire [191:0] dout_pool3;
    
    pool3_layer uut_pool3 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(global_flush_fcm),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_pool3),
        .din(din_pool3),
        
        .ready_to_upstream(enable_next_read_gff_conv3),
        
        .valid_out(valid_out_pool3),
        .dout(dout_pool3)
    );
    
    wire enable_next_read_gff_pool3;
    wire valid_out_gff_pool3;
    wire [191:0] dout_gff_pool3;
    
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(8),
        .MAX_OCCUPANCY(4),
        .ADDRESS_WIDTH(10)
    ) uut_gff_5 (
        .clk(clk), .rstn(rstn),
        
        .clear(global_flush_fcm),
        
        .enable_next_read(enable_next_read_gff_pool3),
        
        .valid_in(valid_out_pool3),
        .din(dout_pool3),
        
        .wr_cnt(wr_cnt_gff_pool3),
        .rd_cnt(rd_cnt_gff_pool3),
        
        .valid_out(valid_out_gff_pool3),
        .dout(dout_gff_pool3)
    );
    
    wire valid_in_fc1 = valid_out_gff_pool3;
    wire [191:0] din_fc1 = dout_gff_pool3;
    wire raw_valid_out_fc1;
    wire [367:0] raw_dout_fc1;
    wire valid_out_fc1;
    wire [191:0] dout_fc1;
    
    fully_connected_1_layer uut_fc1 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(global_flush_fcm),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_fc1),
        .din(din_fc1),
        
        .ready_to_upstream(enable_next_read_gff_pool3),
        
        .raw_valid_out(raw_valid_out_fc1),
        .raw_dout(raw_dout_fc1),
        
        .valid_out(valid_out_fc1),
        .dout(dout_fc1)
    );
    
    wire valid_in_fc2 = valid_out_fc1;
    wire [191:0] din_fc2 = dout_fc1;
    wire raw_valid_out_fc2;
    wire [449:0] raw_dout_fc2;
    wire valid_out_fc2;
    wire [239:0] dout_fc2;
    
    // unused
    wire ready_to_upstream_fc2;
    
    fully_connected_2_layer uut_fc2 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(global_flush_fcm),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_fc2),
        .din(din_fc2),
        
        .ready_to_upstream(ready_to_upstream_fc2),
        
        .raw_valid_out(raw_valid_out_fc2),
        .raw_dout(raw_dout_fc2),
        
        .valid_out(valid_out_fc2),
        .dout(dout_fc2)
    );
    
    argmax_10_class uut_argmax (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_fc2),
        .din(dout_fc2),
        
        .valid_out(valid_argmax),
        .class_out(class_out)
    );


endmodule
