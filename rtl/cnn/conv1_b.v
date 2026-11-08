`timescale 1ns / 1ps

module conv1_b(
    output wire valid_out,
    output wire [16*8-1:0] param_bias
);
    reg [16*8-1:0] param_mem [0:0];
    
    initial begin
        $readmemh("conv1_b.mem", param_mem);
    end
    
    assign param_bias = param_mem[0];
    assign valid_out = 1'b1;

endmodule