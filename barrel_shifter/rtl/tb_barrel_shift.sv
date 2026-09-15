module tb_barrel_shifter;

parameter EXPONENT_WIDTH = 8;
parameter STICKY_BIT_WIDTH = 1 << EXPONENT_WIDTH;
parameter MANTISSA_BIT_WIDTH = 23;

logic clk;
logic rst_n;
logic [EXPONENT_WIDTH-1:0]exponent_difference;
logic [MANTISSA_BIT_WIDTH-1:0]mantissa_in;
logic mantissa_in_valid;

logic [MANTISSA_BIT_WIDTH-1:0]mantissa_out;
logic mantissa_out_valid;
logic guard_bit;
logic round_bit;
logic sticky_bit;

localparam int TB_EXPONENT_WIDTH = 8;
localparam int TB_MANTISSA_BIT_WIDTH = 23;

barrel_shifter #(
    .EXPONENT_WIDTH(TB_EXPONENT_WIDTH),
    .MANTISSA_BIT_WIDTH(TB_MANTISSA_BIT_WIDTH)
) DUT (
    .clk_i(clk),
    .rst_n_i(rst_n),
    .exponent_difference_i(exponent_difference),
    .mantissa_in_i(mantissa_in),
    .mantissa_in_valid_i(mantissa_in_valid),
    
    .mantissa_out_o(mantissa_out),
    .mantissa_out_valid_o(mantissa_out_valid),
    .guard_bit_o(guard_bit),
    .round_bit_o(round_bit),
    .sticky_bit_o(sticky_bit)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 1;
end

initial begin
    #5;
    rst_n = 0;

    #5 rst_n = 1;

       @(negedge clk)
       mantissa_in = 23'b000_0000_0000_0000_0000_0001;
       exponent_difference = 0;

       @(negedge clk)
       mantissa_in = 23'b111_1111_1111_1111_1111_1111;
       exponent_difference = 0;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 1;

       @(negedge clk)
       mantissa_in = 23'b000_0000_0000_0000_0000_0001;
       exponent_difference = 1;

       @(negedge clk)
       mantissa_in = 23'b000_0000_0000_0000_0000_0001;
       exponent_difference = 2;

       @(negedge clk)
       mantissa_in = 23'b000_0000_0000_0000_0000_0001;
       exponent_difference = 3;

       @(negedge clk)
       mantissa_in = 23'b000_0000_0000_0000_0000_0011;
       exponent_difference = 1;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 22;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 23;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 24;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 25;

       @(negedge clk)
       mantissa_in = 23'b000_0000_0000_0000_0000_0001;
       exponent_difference = 25;

       @(negedge clk)
       mantissa_in = 23'b000_0000_0000_0000_0000_0000;
       exponent_difference = 200;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 255;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 21;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 22;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 23;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 24;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 25;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 26;

       @(negedge clk)
       mantissa_in = 23'b000_0000_0000_0000_0000_0000;
       exponent_difference = 25;

       @(negedge clk)
       mantissa_in = 23'b000_0000_0000_0000_0000_0001;
       exponent_difference = 255;

       @(negedge clk)
       mantissa_in = 23'b100_0000_0000_0000_0000_0000;
       exponent_difference = 128;
    #100;
    $finish;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_barrel_shifter);
end

// initial begin
//     $monitor("mantissa_out = %b | guard = %b | round = %b | sticky = %b",mantissa_out,guard_bit,round_bit,sticky_bit);
// end


endmodule