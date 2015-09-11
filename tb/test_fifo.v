`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:50:35 06/30/2015
// Design Name:   Fif0_8depth
// Module Name:   F:/Xilinx/Fifi_8depth/test.v
// Project Name:  Fifi_8depth
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Fif0_8depth
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg Clk;
	reg Reset;
	reg [7:0] Data_In;
	reg Read;
	reg Write;

	// Outputs
	wire [7:0] Data_Out;
	wire [3:0] Fifo_Status;

	// Instantiate the Unit Under Test (UUT)
	Fifo_variable uut (
		.Clk(Clk), 
		.Reset(Reset), 
		.Data_In(Data_In), 
		.Data_Out(Data_Out), 
		.Read(Read), 
		.Write(Write), 
		.Fifo_Status(Fifo_Status)
	);
	
	
	always
	begin
	//	initial begin
	//	Clk = 0;
	//	#100;
		//end
	#5;
//	if(Reset == 1)
	begin
		Clk = 0;
		#5
		Clk = 1;
	end
	end
	initial begin
		// Initialize Inputs
		Clk = 0;
		Reset = 0;
		Data_In = 0;
		Read = 0;
		Write = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		
		#5
		Reset = 1;
		#10
		Write = 1;
		Data_In = 8'h5A;
		#10
		Data_In = 8'hA5;
		#10
		Write = 0;
		Read = 1;
		#10
		Write = 1;
		Data_In = 8'hDB;
		#10
		Data_In = 8'hF0;
		#10
		Data_In = 8'h0F;
		#10
		Read = 0;
		#10
		Data_In = 8'hC3;
		#10
		Data_In = 8'h3C;
		#40
		Write = 0;
		Read = 1;
		#100
		Write = 1;
		Data_In = 8'h87;
		#10
		Write = 0;
		Read = 0;

	end
      
endmodule

