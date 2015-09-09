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
`define Fifo_Empty		1
`define Fifo_Full 		2
`define Fifo_AFull	 	4
`define Fifo_AEmpty		8

module Data_ram (Clk, Reset, Data_In , Data_Out, Read, Write, Write_Ptr, Read_Ptr );
	parameter Addr_Width = 4;
	parameter fifo_depth = 1 << Addr_Width;
	integer i;

	input Clk;
	input Reset;
	input [7:0]Data_In;
	input Read;
	input Write;
	input [(Addr_Width-1):0]Read_Ptr;
	input [(Addr_Width-1):0]Write_Ptr;

	output reg [7:0]Data_Out;
	
	reg [7:0]mem[0:(fifo_depth-1)];
	
	always @(negedge Clk )
	begin
		if (Reset == 0)begin
			for( i = 0;i< fifo_depth; i=i+1)
			mem[i] = 0;
		end
		else if(Write == 1)
			mem[Write_Ptr] = Data_In;
	end
	
	always @(Read or mem or Reset)
	begin
		if (Reset == 0)
			Data_Out = 0;
		if(Read == 1)
			Data_Out = mem[Read_Ptr];
	end
	
	
endmodule

module Fifo_variable( Clk, Reset, Data_In , Data_Out, Read, Write, Fifo_Status
    );
	input Clk;
	input Reset;
	input [7:0]Data_In;
	input Read;
	input Write;

	output reg [3:0]Fifo_Status;
	output reg [7:0]Data_Out;

	parameter Addr_Width = 4;
	parameter Fifo_Depth = (1 << Addr_Width) - 1 ;
	reg [(Addr_Width-1):0]Read_Ptr;
	reg [(Addr_Width-1):0]Write_Ptr;
	reg Write_Shift;
	reg Read_Shift;
	reg Read_En;
	reg [3:0]Fifo_Status_In;
	wire [7:0]Data_Out_in;
	wire [(Addr_Width-1):0]Diff;
	
	Data_ram D1(Clk, Reset, Data_In, Data_Out_in, Read & Read_En, Write, Write_Ptr, Read_Ptr);
	assign Diff = Write_Ptr - Read_Ptr;
	
	 always @(negedge Clk )
	 begin
		 if( Reset == 0)
		 begin
			 Write_Ptr <= 0;
		 end
		 else if( Write == 1)
		 begin
			 Write_Ptr <= Write_Ptr+1;
		 end
	 end
	
	 always @(negedge Clk )
		 if( Reset == 0) begin
			 Read_Ptr <= 0;
			 Read_En = 0;
		 end
		 else begin
			 if( Read == 1)	 begin
				 if( !(Fifo_Status_In & `Fifo_Empty)) begin
					 Read_En = 1;
					 Read_Ptr <= Read_Ptr + 1;
				 end else	 begin
					 if(Write == 1) begin
						 Read_En = 1;
						 Read_Ptr <= Read_Ptr + 1;
					 end
				 end
			 end
			 else
				 Read_En = 0;
		 end
	always @(Read_En or Reset or Data_Out_in)begin
		if(Reset == 0)
			Data_Out = 0;
		else begin
			if(Read_En)begin
				Data_Out = Data_Out_in;
			end
		end

	end	
	 always @(Diff or Reset)
	 begin
		if (Reset == 0)
			Fifo_Status_In = `Fifo_Empty;
		else 
		case(Diff)
			0: Fifo_Status_In = `Fifo_Empty | `Fifo_AEmpty;
			1: Fifo_Status_In = `Fifo_AEmpty;
			(Fifo_Depth-1): Fifo_Status_In = `Fifo_AFull;
			Fifo_Depth: Fifo_Status_In = `Fifo_Full;
			default: Fifo_Status_In = 0;
		endcase
	 end
	 
	 always @(negedge Clk)
	 begin
		if(Reset == 0)
			Fifo_Status <= 0;
		else begin
			case(Diff)
				0: begin
					if((Read == 0) && (Write == 1))
						Fifo_Status <= `Fifo_AEmpty;
					else
						Fifo_Status <= `Fifo_Empty | `Fifo_AEmpty;
				end
				1: begin
					if((Read == 0) && (Write == 1))
						Fifo_Status <= 0;
					else if((Read == 1) && (Write == 0))
						Fifo_Status <= `Fifo_Empty | `Fifo_AEmpty;
					else
						Fifo_Status <= `Fifo_AEmpty;
				end
				2: begin
					if((Read == 1) && (Write == 0))
						Fifo_Status <= `Fifo_AEmpty;
					else
						Fifo_Status <= 0;
				end
				(Fifo_Depth-2): begin
					if((Read == 0) && (Write == 1))
						Fifo_Status <= `Fifo_AFull ;
					else
						Fifo_Status <= 0;
				end
				(Fifo_Depth-1): begin
					if((Read == 0) && (Write == 1))
						Fifo_Status <= `Fifo_AFull | `Fifo_Full;
					else if((Read == 1) && (Write == 0))
						Fifo_Status <= 0;
					else
						Fifo_Status <= `Fifo_AFull;
				end
				Fifo_Depth:  begin
					if((Read == 1) && (Write == 0))
						Fifo_Status <= `Fifo_AFull;
					else
						Fifo_Status <= `Fifo_AFull | `Fifo_Full;
				end
			default: Fifo_Status <= 0;
		endcase
		end
	 end
endmodule
