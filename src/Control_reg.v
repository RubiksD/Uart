module Control_reg.v(
	clk,
	reset_n,

	cs,
	wen,
	addr,
	wdata,
	rdata

);
input wire clk;
input wire reset_n;

input wire cs;
input wire wen;
input wire [31:0] addr;
input wire [31:0] wdata;
output reg [31:0]rdata;

reg [4:0]bit_length;
reg oversample_by_3;

reg data_valid;

wire [3:0] fifo_staus; 


endmodule
