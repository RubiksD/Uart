`include "uart_defines.v"

`define TX_STATE_IDLE		  3'd0
`define TX_WAIT_FOR_READ  3'd1
`define TX_LOAD_DATA      3'd2
`define TX_TRANSMIT       3'd3

module Uart_core(
	clk,
	reset_n,

	TX,
	RX,

	enable_uart,

	fwdata,
	frdata,
	frstatus,
	fwstatus,
	fwrite,
	fread
);

parameter DATA_WIDTH = 8;

input wire clk;
input wire reset_n;

input wire enable_uart;

output TX;
input wire RX;

output [DATA_WIDTH-1:0]fwdata;
input wire  [DATA_WIDTH-1:0]frdata;
input [3:0] frstatus;
input [3:0] fwstatus;
output     fwrite;
output reg fread;

reg [2:0]tx_state;
reg [2:0]rx_state;

reg [DATA_WIDTH+1+1+1-1:0] TX_Data;
reg [2:0]                  TX_Counter;
reg [3:0]                  TX_Bit_Count;

assign TX = TX_Data[0];

always@(posedge clk or negedge reset_n)
begin
	if(~reset_n)
	begin
		tx_state <= `TX_STATE_IDLE;
		fread    <= 1'b0;
		TX_Data  <= {{(DATA_WIDTH+3){1'd1}}};
		TX_Counter <= 3'd0;
		TX_Bit_Count <= 4'd0;
	end
	else
	begin
		case(tx_state)
			`TX_STATE_IDLE: begin
												if((frstatus & `Fifo_AEmpty) == 4'd0) begin
													fread <= 1'b1;
													tx_state <= `TX_WAIT_FOR_READ;
													TX_Data[0] <= 1'd0;
												end
											end
			`TX_WAIT_FOR_READ: begin
												fread <= 1'b0;
												tx_state <= `TX_LOAD_DATA;
											end
			`TX_LOAD_DATA : begin
												TX_Data[DATA_WIDTH+2:1] <= {1'd1,^frdata,frdata};
												TX_Counter <= 3'd2;
												TX_Bit_Count <= 4'd0;
												tx_state <= `TX_TRANSMIT;
											end
			`TX_TRANSMIT  : begin
												TX_Counter <= (TX_Counter == 3'd2) ? 3'd0 : TX_Counter + 1'd1;
												TX_Bit_Count <= (TX_Counter == 3'd2) ? TX_Bit_Count + 1'd1 : TX_Bit_Count ;
												TX_Data <= (TX_Counter == 3'd2) ? {1'd1,TX_Data[DATA_WIDTH+2:1]} : TX_Data;
												if((TX_Counter == 3'd2) && (TX_Bit_Count == (DATA_WIDTH+2)))begin
													if((frstatus & `Fifo_Empty) == `Fifo_Empty) begin
														tx_state <= `TX_STATE_IDLE;
													end else begin
														fread <= 1'd1;
														tx_state <= `TX_WAIT_FOR_READ;
														TX_Data[0] <= 1'd0;
													end
												end
											end
			default : begin end
		endcase
	end
end


endmodule
