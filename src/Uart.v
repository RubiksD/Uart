module Uart
(
	clk,
	reset_n,

	TX,
	RX,

	fwdata,
	frdata,
	frstatus,
	fwstatus,
	fwrite,
	fread,

	cs,
	wen,
	addr,
	wdata,
	rdata
);

parameter FADDR_WIDTH = 4;
parameter DATA_WIDTH = 8;
parameter THRESHOLD  = 3;


input wire clk;
input wire reset_n;

output wire TX;
input  wire RX;

input  [DATA_WIDTH-1:0] fwdata;
output [DATA_WIDTH-1:0] frdata;
output [3:0] frstatus;
output [3:0] fwstatus;
input    fwrite;
input    fread;

input wire cs;
input wire wen;
input wire [31:0] addr;
input wire [31:0] wdata;
output wire	[31:0]rdata;

wire [4:0]word_length;
wire Num_stop_bits;
wire oversample_by_3;
wire enable_uart;
   
wire [7:0]fifo_status;
wire data_valid;
wire intr;

wire [DATA_WIDTH-1:0] fifo_core_wdata;
wire [DATA_WIDTH-1:0] fifo_core_rdata;
wire                  fifo_core_write;
wire                  fifo_core_read;

////////////////////////////////////
/// Logic Implementations  /////////
////////////////////////////////////
//!{{{

assign frstatus = fifo_status[3:0];
assign fwstatus = fifo_status[7:4];
//!}}}
////////////////////////////////////
/// Chilgren Modules  //////////////
////////////////////////////////////
//!{{{
Reg_file  Reg_file_inst1(
  .clk    (clk),
  .reset_n(reset_n),
  
  .cs       (cs),
  .wen      (wen),
  .addr     (addr ) ,
  .wdata    (wdata) ,
  .rdata    (rdata) ,
  
  .word_length    (word_length    ) ,
  .Num_stop_bits  (Num_stop_bits  ) ,
  .oversample_by_3(oversample_by_3) ,
  .enable_uart    (enable_uart    ) ,
  
  .fifo_status    (fifo_status) ,
  .data_valid     (1'd0) ,
  .intr           (1'd0)
         );
//! Read w.r.t outside top
Fifo Read_Fifo( 
	.Clk(clk),
	.Reset(reset_n),
	.Data_In(fifo_core_wdata) ,
	.Data_Out(frdata), 
	.Read(fread), 
	.Write(fifo_core_write), 
	.Fifo_Status(fifo_status[3:0])

);

//! Write w.r.t outside top
Fifo Write_Fifo(
	.Clk(clk),
	.Reset(reset_n),
	.Data_In(fwdata) ,
	.Data_Out(fifo_core_rdata), 
	.Read(fifo_core_read), 
	.Write(fwrite), 
	.Fifo_Status(fifo_status[7:4])

);
Uart_core Uart_core_int(
	.clk    (clk),
	.reset_n(reset_n),

	.TX(TX),
	.RX(RX),

	.enable_uart(1'd1),

	.fwdata   (fifo_core_wdata),
	.frdata   (fifo_core_rdata),
	.frstatus (fifo_status[7:4]),
	.fwstatus (fifo_status[3:0]),
	.fwrite   (fifo_core_write),
	.fread    (fifo_core_read)
);
//!}}}

endmodule
