`timescale 1ns / 10ps

////////////////////////////////////////////////////////////////////////////////
// 
// encrypt test
// 
// test data 1: (128bit)
// key:    0x00000000000000000000000000000000
// input:  0x00000000000000000000000000000000
// output: 0x66e94bd4ef8a2c3b884cfa59ca342b2e
//
// test data 2: (128bit)
// key:    0x00000000000000000000000000000000
// input:  0x66e94bd4ef8a2c3b884cfa59ca342b2e
// output: 0xf795bd4a52e29ed713d313fa20e98dbc
// 
////////////////////////////////////////////////////////////////////////////////

module aes512_test;

	// Inputs
	reg clk;
	reg rst;
	reg ld;
	reg [127:0] key;
	reg [511:0] text_in;

	// Outputs
	wire done;
	wire [511:0] text_out;
	reg  data_in_valid;
	wire data_out_valid;
	
	// Instantiate the Unit Under Test (UUT)
	aes_cipher_512 uut (
		.clk(clk), 
		.rst(rst), 
		.key(key), 
		.data_in_valid(data_in_valid), 
		.data_in(text_in),
		.data_out(text_out), 
		.data_out_valid(data_out_valid)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		rst = 1;
		ld = 0;
		key = 0;
		//text_in = 0;
		text_in = 128'h66e94bd4ef8a2c3b884cfa59ca342b2e;
		data_in_valid <= 0;
		#10		
		rst = 0;
		#100

		data_in_valid <= 1;

		#500

		data_in_valid <= 0;
		
		$monitor("text_out = %h", text_out);
	
		#100;
        
	end
	
	always clk = #5 ~clk;
	// stop simulating
	// always @(posedge clk)
	// 	if (done) #1 $stop;
      
endmodule

