module input_signal(radio_clk, run_tx, tx_idle, tx);
   input radio_clk;
   input run_tx;
   input tx_idle;
   output tx;
   reg [1:0] counter;

   always @(posedge radio_clk) begin
      counter = counter + 1;
      if (counter[1] == 1) begin
      	tx[31:16] <= (run_tx) ? 16'b1010101010101010 : tx_idle[31:16];
      	tx[15:0] <= (run_tx) ? 16'b1010101010101010 : tx_idle[15:0];
	end 
      else begin
      	tx[31:16] <= (run_tx) ? 16'b0000000000000000 : tx_idle[31:16];
      	tx[15:0] <= (run_tx) ? 16'b0000000000000000 : tx_idle[15:0];
	end
   end

