`timescale 1ns / 1ps

module conv2_b(
    input wire clk,
    input wire rstn,
    
    input wire enable,
    input wire [0:0] channel_id,
    
    output reg valid_out,
    output reg  [16*8-1:0] weight_bias
);
    (* ram_style = "block" *)
    reg [16*8-1:0] param_mem [0:1];
    
    initial begin
        $readmemh("conv2_b.mem", param_mem);
    end
    
    always @(posedge clk) begin
        if (!rstn) begin
            valid_out <= 1'b0;
            weight_bias <= {(16*8){1'b0}};
        end
        else begin
            valid_out <= 1'b0;
            if (enable) begin
                valid_out <= 1'b1;
                weight_bias <= param_mem[channel_id];
            end
        end
    end

endmodule
