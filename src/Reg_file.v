module Control_reg.v(
	clk,
	reset_n,

	cs,
	wen,
	addr,
	wdata,
	rdata,

	word_length,
	Num_stop_bits,
	oversample_by_3,
	
	fifo_status,
	data_valid,
	intr

);

parameter CNTRL0 = 4'd0;
parameter DATA_REG = 4'd8;
parameter CNTRL1 = 4'd4;

input wire clk;
input wire reset_n;

input wire cs;
input wire wen;
input wire [31:0] addr;
input wire [31:0] wdata;
output reg [31:0]rdata;

output reg [4:0]word_length;
output reg Num_stop_bits;
output reg oversample_by_3;

always@(posedge clk or negedge reset_n)
begin
	if(~reset_n)
	begin
		word_length <= 4'b0;
		Num_stop_bits <= 1'b0;
		oversample_by_3 <= 1'b0;
	end
	else
	begin
		if(cs & wen)
		begin
		case(addr[3:0])
			CNTRL0:
			begin
			word_length <= wdata[4:0];
			Num_stop_bits <= wdata[5];
			oversample_by_3 <= wdata[6];
			end

			default:
		endcase
		end
	end
end

always@(*)
begin
	if(cs & ~wen)
	begin
		case(addr[3:0])
		CNTRL1:
		begin
			rdata = {fifo_status,data_valid,intr};
		end
		default: rdata = {32{1'b0}};
		endcase
	end
	else
	begin
		rdata = {32{1'b0}};
	end
end

endmodule
