`timescale 1ns / 1ps

module conv3_b(
    input wire clk,
    input wire rstn,
    
    input wire enable,
    input wire [1:0] channel_id,
    
    output reg valid_out,
    output reg  [16*8-1:0] bias_param
);
    (* ram_style = "block" *)
    reg [16*8-1:0] param_mem [0:3];
    
    initial begin
        $readmemh("conv3_b.mem", param_mem);
    end
    
    always @(posedge clk) begin
        if (!rstn) begin
            valid_out <= 1'b0;
            bias_param <= {(16*8){1'b0}};
        end
        else begin
            valid_out <= 1'b0;
            if (enable) begin
                valid_out <= 1'b1;
                bias_param <= param_mem[channel_id];
            end
        end
    end

endmodule
