module Uart
(
	clk,
	reset_n,

	TX,
	RX,

	cs,
	wen,
	addr,
	wdata,
	rdata
);

input wire clk;
input wire reset_n;

output TX;

input wire RX;

input wire cs;
input wire wen;
input wire [31:0] addr;
input wire [31:0] wdata;
output wire	[31:0]rdata;



endmodule
