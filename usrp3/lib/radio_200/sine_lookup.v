module sine_lookup(input clk, input [10:0] addr, output reg [16:0] value);

wire [15:0] sine_1sym;  // sine with 1 symmetry
blockram512x16bit_2clklatency my_quarter_sine_LUT(     // the LUT contains only one quarter of the sine wave
    .rdclock(clk),
    .rdaddress(addr[9] ? ~addr[8:0] : addr[8:0]),   // first symmetry
    .q(sine_1sym)
);

// now for the second symmetry, we need to use addr[10]
// but since our blockram has 2 clock latencies on reads
// we need a two-clock delayed version of addr[10]
reg addr10_delay1; always @(posedge clk) addr10_delay1 <= addr[10];
reg addr10_delay2; always @(posedge clk) addr10_delay2 <= addr10_delay1;

wire [15:0] sine_2sym = addr10_delay2 ? {1'b0,-sine_1sym} : {1'b1,sine_1sym};  // second symmetry

// add a third latency to the module output for best performance
always @(posedge clk) value <= sine_2sym;
endmodule

