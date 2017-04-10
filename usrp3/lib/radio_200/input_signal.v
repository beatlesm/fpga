module input_signal(radio_clk, get_tx);
   input radio_clk;
   output [31:0] get_tx;
   reg [1:0] counter = 2'b00;
   reg [31:0] tx_out;

   always @(posedge radio_clk) begin
      counter = counter + 1;
      if (counter[1] == 1) begin
      	tx_out[31:16] <= 16'b1010101010101010;
      	tx_out[15:0] <= 16'b1010101010101010;
	end 
      else begin
      	tx[31:16] <= 16'b0000000000000000;
      	tx[15:0] <= 16'b0000000000000000;
	end
   end
   assign get_tx = tx_out;
endmodule

