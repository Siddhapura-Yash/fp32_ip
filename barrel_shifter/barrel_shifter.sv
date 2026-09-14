// 23 bit mantissa + guard + round + sticky
module barrel_shifter #(
    parameter EXPONENT_WIDTH        = 8,
    parameter MANTISSA_BIT_WIDTH    = 23 
)(
    input logic                             clk_i,
    input logic                             rst_n_i,
    input logic [EXPONENT_WIDTH-1:0]        exponent_difference_i,
    input logic [MANTISSA_BIT_WIDTH-1:0]    mantissa_in_i,
    input logic                             mantissa_in_valid_i,

    output logic [MANTISSA_BIT_WIDTH-1:0]   mantissa_out_o,
    output logic                            mantissa_out_valid_o,
    output logic                            guard_bit_o,
    output logic                            round_bit_o,
    output logic                            sticky_bit_o
);

    localparam int EXT_WIDTH = 2*MANTISSA_BIT_WIDTH + 2;
    localparam int PAD_WIDTH = MANTISSA_BIT_WIDTH + 2;
    localparam int SHIFT_WIDTH = $clog2(PAD_WIDTH+1);

    logic [EXT_WIDTH-1:0]extended;
    logic [EXT_WIDTH-1:0]shifted;
    logic [SHIFT_WIDTH-1:0]shift_amt_clamped;
    logic is_exponent_greater;

    always_comb begin
        is_exponent_greater = exponent_difference_i >= EXPONENT_WIDTH'(PAD_WIDTH);
        shift_amt_clamped = (is_exponent_greater)
                            ? SHIFT_WIDTH'(PAD_WIDTH)
                            : SHIFT_WIDTH'(exponent_difference_i);
        extended = {mantissa_in_i, {PAD_WIDTH{1'b0}}};
        shifted = extended >> shift_amt_clamped;
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(!rst_n_i) begin
            guard_bit_o          <= 1'b0;
            round_bit_o          <= 1'b0;
            sticky_bit_o         <= 1'b0;
            mantissa_out_o       <= {MANTISSA_BIT_WIDTH{1'b0}};
            mantissa_out_valid_o <= 1'b0;
        end 
        else if(is_exponent_greater) begin
            mantissa_out_o            <=  {MANTISSA_BIT_WIDTH{1'b0}};
            {guard_bit_o,round_bit_o} <=  2'b00;
            sticky_bit_o              <= |mantissa_in_i;
            mantissa_out_valid_o      <=  mantissa_in_valid_i;
        end 
        else begin
            mantissa_out_o            <=  shifted[47:25];
            {guard_bit_o,round_bit_o} <=  {shifted[24],shifted[23]};
            sticky_bit_o              <= |shifted[22:0];
            mantissa_out_valid_o      <=  mantissa_in_valid_i;
        end
    end

endmodule
