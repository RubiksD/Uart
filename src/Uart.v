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

wire [4:0]word_length;
wire Num_stop_bits;
wire oversample_by_3;
wire enable_uart;
   
wire fifo_status;
wire data_valid;
wire intr;

   
   Reg_file(
   	.clk(clk),
  .reset_n(reset_n),
  
  .cs(cs),
  .wen(wen),
  .addr (addr ) ,
  .wdata(wdata) ,
  .rdata(rdata) ,
  
  .word_length    (word_length    ) ,
  .Num_stop_bits  (Num_stop_bits  ) ,
  .oversample_by_3(oversample_by_3) ,
  .enable_uart    (enable_uart    ) ,
  
  .fifo_status    (fifo_status) ,
  .data_valid     (data_valid ) ,
  .intr           (intr       )
         );
   


endmodule
