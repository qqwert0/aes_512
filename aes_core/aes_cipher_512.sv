

`include "timescale.v"

module aes_cipher_512(clk, rst,  key, data_in_valid, data_in, data_out, data_out_valid );
	input		clk, rst;
	input	[127:0]	key;
	input 	data_in_valid;
	input	[511:0]	data_in;
	output [511:0]	data_out;
	output  		data_out_valid;

////////////////////////////////////////////////////////////////////
	wire [3:0] data_out_pre;

	assign data_out_valid = data_out_pre[0];


genvar i;
generate
	for(i = 0; i < 4; i = i + 1) begin

// Instantiate the Unit Under Test (UUT)
		aes_cipher_pipe uut (
			.clk(clk), 
			.rst(rst), 
			.key(key), 
			.data_in_valid(data_in_valid), 
			.data_in(data_in[i*128+127:i*128]),
			.data_out(data_out[i*128+127:i*128]), 
			.data_out_valid(data_out_pre[i])
		);


	end
endgenerate



endmodule


