module Uart
(
	clk,
	reset_n,

	TX,
	RX,

	cs,
	wen,
	wdata,
	rdata
);

input wire clk;
input wire reset_n;

output TX;

input wire RX;

input wire cs;
input wire wen;
input wire wdata;
output rdata;



endmodule
