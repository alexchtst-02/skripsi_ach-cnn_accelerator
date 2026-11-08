module burst_2_data #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,

    input wire clear_reset,
    
    input wire ready_from_downstream0,
    input wire ready_from_downstream1,

    input wire valid_in,
    input wire [DATA_WIDTH-1:0] din,
    
    output wire ready_to_upstream,

    output wire valid_out0,
    output wire [DATA_WIDTH-1:0] dout0,
    
    output wire valid_out1,
    output wire [DATA_WIDTH-1:0] dout1
);

    reg phase;

    reg [DATA_WIDTH-1:0] first_data;

    reg [DATA_WIDTH-1:0] pair_data0;
    reg [DATA_WIDTH-1:0] pair_data1;

    reg pair_valid;

    wire both_ready;

    assign both_ready =
        ready_from_downstream0 &&
            ready_from_downstream1;

    assign ready_to_upstream = !pair_valid;

    assign valid_out0 = pair_valid && both_ready;
    assign valid_out1 = pair_valid && both_ready;

    assign dout0 = pair_data0;
    assign dout1 = pair_data1;

    always @(posedge clk) begin
        if (!rstn || clear_reset) begin
            phase <= 1'b0;
            first_data <= {DATA_WIDTH{1'b0}};

            pair_data0 <= {DATA_WIDTH{1'b0}};
            pair_data1 <= {DATA_WIDTH{1'b0}};
            pair_valid <= 1'b0;
        end
        else begin

            if (pair_valid && both_ready) begin
                pair_valid <= 1'b0;
            end

            if (valid_in && ready_to_upstream) begin

                if (!phase) begin

                    first_data <= din;
                    phase <= 1'b1;

                end
                else begin

                    pair_data0 <= first_data;
                    pair_data1 <= din;

                    pair_valid <= 1'b1;
                    phase <= 1'b0;

                end
            end
        end
    end

endmodule