module output (radio_clk, PPS_IN_INT);

input radio_clk;
output PPS_IN_INT;

assign var_name = radio_clk;

endmodule

// Hopefully, this will assign radio_clk signal to the output (whatever it is)
// and transmit out of TXRX1. I'm not 100% sure which pin to transmit out of
// though...
//NET "PPS_IN_INT"  LOC = "A10" | IOSTANDARD = LVCMOS33 ;

