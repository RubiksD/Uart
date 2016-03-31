	`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:36:03 07/23/2015 
// Design Name: 
// Module Name:    Fifo_variable 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "uart_defines.v"

module Data_ram (Clk, Reset, Data_In , Data_Out, Read, Write, Write_Ptr, Read_Ptr );
	parameter ADDR_WIDTH = 4;
	parameter DATA_WIDTH = 8;
	parameter fifo_depth = 1 << ADDR_WIDTH;
	integer i;

	input Clk;
	input Reset;
	input [(DATA_WIDTH-1):0]Data_In;
	input Read;
	input Write;
	input [(ADDR_WIDTH-1):0]Read_Ptr;
	input [(ADDR_WIDTH-1):0]Write_Ptr;

	output reg [(DATA_WIDTH-1):0]Data_Out;
	
	reg [(DATA_WIDTH-1):0]mem[0:(fifo_depth-1)];
	
	always @(posedge Clk or negedge Reset)
	begin
		if(Write == 1)
			mem[Write_Ptr] <= Data_In;
	end
	
	always @(posedge Clk or negedge Reset)
	begin
	if(~Reset) begin
		Data_Out <= {(DATA_WIDTH){1'd0}};
	end
		if(Read)
			Data_Out <= mem[Read_Ptr];
	end
	
	
endmodule

module Fifo_variable( Clk, Reset, Data_In , Data_Out, Read, Write, Fifo_Status
    );
	input Clk;
	input Reset;
	input [7:0]Data_In;
	input Read;
	input Write;

	output wire [3:0]Fifo_Status;
	output wire [(DATA_WIDTH-1):0]Data_Out;

	parameter ADDR_WIDTH = 4;
	parameter Fifo_Depth = (1 << ADDR_WIDTH) - 1 ;
	parameter DATA_WIDTH = 8;
	parameter THRESHOLD  = 3;

	reg [(ADDR_WIDTH-1):0]Read_Ptr;
	reg [(ADDR_WIDTH-1):0]Write_Ptr;
	reg Write_Shift;
	reg Read_Shift;
	wire [ADDR_WIDTH-1:0]Diff;

	wire Fifo_AEmpty_St;
	wire Fifo_Empty_St;
	wire Fifo_AFull_St;
	wire Fifo_Full_St;

	assign Fifo_AEmpty_St = (Diff < THRESHOLD);
	assign Fifo_Empty_St  = (Diff == {(DATA_WIDTH+1){1'd0}});
	assign Fifo_AFull_St = (Diff > THRESHOLD);
	assign Fifo_Full_St = (Diff == {(DATA_WIDTH){1'd1}});
	assign Diff = (Write_Ptr - Read_Ptr);
	assign Fifo_Status = {Fifo_AEmpty_St,Fifo_AFull_St,Fifo_Full_St,Fifo_Empty_St};

	
	Data_ram D1(Clk, Reset, Data_In, Data_Out, Read , Write, Write_Ptr, Read_Ptr);
	
	 always @(posedge Clk or negedge Reset)
	 begin
		 if(~Reset)
		 begin
			 Write_Ptr <= 0;
		 end
		 else if( Write == 1)
		 begin
			 Write_Ptr <= Write_Ptr+1;
		 end
	 end
	
	 always @(posedge Clk or negedge Reset)
	 begin
		 if(~Reset) begin
			 Read_Ptr <= 0;
		 end
		 else begin
			 if( Read == 1)	 begin
				 if( (~(Fifo_Status & `Fifo_Empty)) ) begin
					 Read_Ptr <= Read_Ptr + 1;
				 end 
				 else	 begin
					 if(Write == 1) begin
						 Read_Ptr <= Read_Ptr + 1;
					 end
				 end
			 end
		 end
	 end

endmodule
