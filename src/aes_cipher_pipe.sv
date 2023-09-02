

`timescale 1ns / 1ps

module aes_cipher_pipe(clk, rst, key, data_in_valid, data_in, data_out,data_out_valid);
input		clk, rst;
input	[127:0]	key;
input 	data_in_valid;
input	[127:0]	data_in;
output reg[127:0]	data_out;
output reg 			data_out_valid;

////////////////////////////////////////////////////////////////////

reg[11:0]			ld_r;
reg [11:0]			ld;
wire [11:0][127:0]	data_out_l0;
reg [5:0][127:0]	data_out_l1;
reg [1:0][127:0]	data_out_l2;
wire [11:0]			done_l0;
reg [5:0]			done_l1;
reg [1:0]			done_l2;

always@(posedge clk)begin
	if(rst)begin
		ld		<= 0;
		ld_r	<= 0;
	end
	else if(data_in_valid & (ld_r==0))begin
		ld_r<= 12'b0000_0000_0001;
		ld	<= 12'b0000_0000_0001;		
	end
	else if(data_in_valid & (ld_r[0]==1))begin
		ld	<= 12'b0000_0000_0010;	
		ld_r<= 12'b0000_0000_0010;	
	end
	else if(data_in_valid & (ld_r[1]==1))begin
		ld	<= 12'b0000_0000_0100;
		ld_r<= 12'b0000_0000_0100;		
	end
	else if(data_in_valid & (ld_r[2]==1))begin
		ld	<= 12'b0000_0000_1000;
		ld_r<= 12'b0000_0000_1000;		
	end
	else if(data_in_valid & (ld_r[3]==1))begin
		ld	<= 12'b0000_0001_0000;
		ld_r<= 12'b0000_0001_0000;		
	end
	else if(data_in_valid & (ld_r[4]==1))begin
		ld	<= 12'b0000_0010_0000;	
		ld_r<= 12'b0000_0010_0000;	
	end
	else if(data_in_valid & (ld_r[5]==1))begin
		ld	<= 12'b0000_0100_0000;
		ld_r<= 12'b0000_0100_0000;		
	end
	else if(data_in_valid & (ld_r[6]==1))begin
		ld	<= 12'b0000_1000_0000;
		ld_r<= 12'b0000_1000_0000;		
	end
	else if(data_in_valid & (ld_r[7]==1))begin
		ld	<= 12'b0001_0000_0000;
		ld_r<= 12'b0001_0000_0000;		
	end
	else if(data_in_valid & (ld_r[8]==1))begin
		ld	<= 12'b0010_0000_0000;
		ld_r<= 12'b0010_0000_0000;		
	end
	else if(data_in_valid & (ld_r[9]==1))begin
		ld	<= 12'b0100_0000_0000;
		ld_r<= 12'b0100_0000_0000;		
	end
	else if(data_in_valid & (ld_r[10]==1))begin
		ld	<= 12'b1000_0000_0000;
		ld_r<= 12'b1000_0000_0000;		
	end
	else if(data_in_valid & (ld_r[11]==1))begin
		ld	<= 12'b0000_0000_0001;
		ld_r<= 12'b0000_0000_0001;		
	end		
	else begin
		ld	<= 0;
		ld_r<= ld_r;		
	end
end



genvar i;
generate
	for(i = 0; i < 12; i = i + 1) begin

// Instantiate the Unit Under Test (UUT)
		aes_cipher uut (
			.clk(clk), 
			.rst(rst), 
			.ld(ld[i]), 
			.done(done_l0[i]), 
			.key(key), 
			.text_in(data_in), 
			.text_out(data_out_l0[i])
		);


	end
endgenerate

genvar j;
generate
	for(j = 0; j < 6; j = j + 1) begin
		always@(posedge clk)begin
			data_out_l1[j]	<= done_l0[j*2] ? data_out_l0[j*2] : data_out_l0[j*2+1];
			done_l1[j]		<= done_l0[j*2] | done_l0[j*2+1];
		end
	end
endgenerate

always@(posedge clk)begin
	data_out_l2[0]	<= done_l1[0] ? data_out_l1[0] :  (done_l1[1] ? data_out_l1[1] : data_out_l1[2]);
	done_l2[0]		<= done_l1[0] | done_l1[1] | done_l1[2];
end

always@(posedge clk)begin
	data_out_l2[1]	<= done_l1[3] ? data_out_l1[3] : (done_l1[4] ? data_out_l1[4] : data_out_l1[5]);
	done_l2[1]		<= done_l1[3] | done_l1[4] | done_l1[5];
end

always@(posedge clk)begin
	data_out	<= done_l2[0] ? data_out_l2[0] : data_out_l2[1];
	data_out_valid	<= done_l2[0] | done_l2[1];
end
endmodule


