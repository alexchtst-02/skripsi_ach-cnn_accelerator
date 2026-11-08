`timescale 1ns / 1ps

module fc2_b(
    output wire valid_out,
    output wire [16*10-1:0] param_bias
);
    (* ram_style = "block" *)
    reg [16*10-1:0] param_mem [0:0];
    
    initial begin
        $readmemh("fc2_b.mem", param_mem);
    end
    
    assign valid_out  = 1'b1;
    assign param_bias = param_mem[0];

endmodule