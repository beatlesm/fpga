module signal(radio_clk, sig_out);
	input radio_clk;
	output reg sig_out;
	reg [1:0] counter;

	always @(posedge radio_clk)
		begin
			counter = counter + 1;
			sig_out = counter[1];
		end
endmodule

