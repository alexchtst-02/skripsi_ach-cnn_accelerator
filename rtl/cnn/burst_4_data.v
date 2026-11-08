`timescale 1ns / 1ps

module burst_4_data #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,
    
    input wire clear_reset,
    
    input wire ready_from_downstream0,
    input wire ready_from_downstream1,
    input wire ready_from_downstream2,
    input wire ready_from_downstream3,

    input wire valid_in,
    input wire [DATA_WIDTH-1:0] din,
    
    output wire ready_to_upstream,

    output wire valid_out0,
    output wire [DATA_WIDTH-1:0] dout0,

    output wire valid_out1,
    output wire [DATA_WIDTH-1:0] dout1,

    output wire valid_out2,
    output wire [DATA_WIDTH-1:0] dout2,

    output wire valid_out3,
    output wire [DATA_WIDTH-1:0] dout3
);


    reg [1:0] data_counter;

    reg [DATA_WIDTH-1:0] buffer0;
    reg [DATA_WIDTH-1:0] buffer1;
    reg [DATA_WIDTH-1:0] buffer2;
    reg [DATA_WIDTH-1:0] buffer3;

    reg burst_valid;

    wire all_downstream_ready;

    assign all_downstream_ready =
        ready_from_downstream0 &&
            ready_from_downstream1 &&
                ready_from_downstream2 &&
                    ready_from_downstream3;

    assign ready_to_upstream = !burst_valid;

    assign valid_out0 = burst_valid && all_downstream_ready;
    assign valid_out1 = burst_valid && all_downstream_ready;
    assign valid_out2 = burst_valid && all_downstream_ready;
    assign valid_out3 = burst_valid && all_downstream_ready;

    assign dout0 = buffer0;
    assign dout1 = buffer1;
    assign dout2 = buffer2;
    assign dout3 = buffer3;

    always @(posedge clk) begin
        if (!rstn || clear_reset) begin

            data_counter <= 2'd0;

            buffer0 <= {DATA_WIDTH{1'b0}};
            buffer1 <= {DATA_WIDTH{1'b0}};
            buffer2 <= {DATA_WIDTH{1'b0}};
            buffer3 <= {DATA_WIDTH{1'b0}};

            burst_valid <= 1'b0;

        end
        else begin

            if (burst_valid && all_downstream_ready) begin
                burst_valid <= 1'b0;
            end

            if (valid_in && ready_to_upstream) begin
                case (data_counter)

                    2'd0: begin
                        buffer0 <= din;
                        data_counter <= 2'd1;
                    end

                    2'd1: begin
                        buffer1 <= din;
                        data_counter <= 2'd2;
                    end

                    2'd2: begin
                        buffer2 <= din;
                        data_counter <= 2'd3;
                    end

                    2'd3: begin
                        buffer3 <= din;

                        data_counter <= 2'd0;
                        burst_valid <= 1'b1;
                    end

                    default: begin
                        data_counter <= 2'd0;
                    end

                endcase
            end
        end
    end

endmodule