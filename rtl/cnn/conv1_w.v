`timescale 1ns / 1ps

module conv1_w(
    output wire valid_out,
    output wire signed [16*8*9-1:0] weight_param
);
    reg [16*8*9-1:0] param_mem [0:0];
    
    initial begin
        $readmemh("conv1_w.mem", param_mem);
    end
    
    assign weight_param = param_mem[0];
    assign valid_out = 1'b1;

endmodule
