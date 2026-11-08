`timescale 1ns / 1ps

module fc2_w(
    input wire clk,
    input wire rstn,
    
    input wire enable,
    input wire [4:0] channel_id,
    
    output reg valid_out,
    output reg  [16*8-1:0] weight_param
);
    (* ram_style = "block" *)
    reg [16*8-1:0] param_mem [0:19];
    
    initial begin
        $readmemh("fc2_w.mem", param_mem);
    end
    
    always @(posedge clk) begin
        if (!rstn) begin
            valid_out <= 1'b0;
            weight_param <= {(16*8){1'b0}};
        end
        else begin
            valid_out <= 1'b0;
            if (enable) begin
                valid_out <= 1'b1;
                weight_param <= param_mem[channel_id];
            end
        end
    end

endmodule