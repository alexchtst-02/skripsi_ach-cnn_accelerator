`timescale 1ns / 1ps

module accumulator_8ch #(
    parameter integer DATA_WIDTH = 24
)(
    input wire clk,
    input wire rstn,

    input wire valid_in,
    input wire signed [8*DATA_WIDTH-1:0] din,

    output reg valid_out,
    output reg signed [DATA_WIDTH+3-1:0] dout
);

    wire signed [DATA_WIDTH-1:0] d0 = din[0*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d1 = din[1*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d2 = din[2*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d3 = din[3*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d4 = din[4*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d5 = din[5*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d6 = din[6*DATA_WIDTH +: DATA_WIDTH];
    wire signed [DATA_WIDTH-1:0] d7 = din[7*DATA_WIDTH +: DATA_WIDTH];

    // -------------------------------------------------------
    // Stage 1
    // DATA_WIDTH + 1
    // -------------------------------------------------------

    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc0_s1;
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc1_s1;
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc2_s1;
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH:0] acc3_s1;

    reg valid_s1;

    // -------------------------------------------------------
    // Stage 2
    // DATA_WIDTH + 2
    // -------------------------------------------------------

    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH+1:0] acc0_s2;
    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH+1:0] acc1_s2;

    reg valid_s2;

    // -------------------------------------------------------
    // Stage 3
    // DATA_WIDTH + 3
    // -------------------------------------------------------

    (* use_dsp = "no" *)
    reg signed [DATA_WIDTH+2:0] acc0_s3;

    reg valid_s3;

    always @(posedge clk) begin
        if (!rstn) begin

            valid_s1  <= 1'b0;
            valid_s2  <= 1'b0;
            valid_s3  <= 1'b0;
            valid_out <= 1'b0;

            dout <= {(DATA_WIDTH+3){1'b0}};

        end
        else begin

            valid_s1  <= valid_in;
            valid_s2  <= valid_s1;
            valid_s3  <= valid_s2;
            valid_out <= valid_s3;

            // ------------------------------------------------
            // Stage 1
            // ------------------------------------------------

            if (valid_in) begin

                acc0_s1 <=
                    $signed({
                        d0[DATA_WIDTH-1],
                        d0
                    }) +
                    $signed({
                        d1[DATA_WIDTH-1],
                        d1
                    });

                acc1_s1 <=
                    $signed({
                        d2[DATA_WIDTH-1],
                        d2
                    }) +
                    $signed({
                        d3[DATA_WIDTH-1],
                        d3
                    });

                acc2_s1 <=
                    $signed({
                        d4[DATA_WIDTH-1],
                        d4
                    }) +
                    $signed({
                        d5[DATA_WIDTH-1],
                        d5
                    });

                acc3_s1 <=
                    $signed({
                        d6[DATA_WIDTH-1],
                        d6
                    }) +
                    $signed({
                        d7[DATA_WIDTH-1],
                        d7
                    });

            end

            // ------------------------------------------------
            // Stage 2
            //
            // acc_s1 = [DATA_WIDTH:0]
            // sign bit = DATA_WIDTH
            // ------------------------------------------------

            if (valid_s1) begin

                acc0_s2 <=
                    $signed({
                        acc0_s1[DATA_WIDTH],
                        acc0_s1
                    }) +
                    $signed({
                        acc1_s1[DATA_WIDTH],
                        acc1_s1
                    });

                acc1_s2 <=
                    $signed({
                        acc2_s1[DATA_WIDTH],
                        acc2_s1
                    }) +
                    $signed({
                        acc3_s1[DATA_WIDTH],
                        acc3_s1
                    });

            end

            // ------------------------------------------------
            // Stage 3
            //
            // acc_s2 = [DATA_WIDTH+1:0]
            // sign bit = DATA_WIDTH+1
            // ------------------------------------------------

            if (valid_s2) begin

                acc0_s3 <=
                    $signed({
                        acc0_s2[DATA_WIDTH+1],
                        acc0_s2
                    }) +
                    $signed({
                        acc1_s2[DATA_WIDTH+1],
                        acc1_s2
                    });

            end

            if (valid_s3) begin
                dout <= acc0_s3;
            end

        end
    end

endmodule