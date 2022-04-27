

module ram(
	input wire clk,
	input wire rst,
	output reg[3:0] pulse
);

reg [15:0]  mem16[2047:0] ;	//所需ram

reg [14:0]  cnt;						//地址




initial begin
	$readmemh("a.data", mem16);
	cnt <= 15'd0;
end

always@(posedge clk) begin
	cnt <= cnt +1'b1;
end
		
always@(posedge clk) begin
		if(mem16[cnt[10:0]] >= 16'd50 ) begin
			pulse[0] <= 1'b1;
		end else begin
			pulse[0] <= 1'b0;
		end
			
		if(mem16[cnt[10:0]] >= 16'd100 ) begin
			pulse[1] <= 1'b1;
		end else begin
			pulse[1] <= 1'b0;
		end	
			
		if(mem16[cnt[10:0]] >= 16'd150 ) begin
			pulse[2] <= 1'b1;
		end else begin
			pulse[2] <= 1'b0;
		end
//			
//		if(mem16_s3s7[cnt_s3s7[10:0]] >= 16'd150 )
//			pulse1_out[3] <= 1'b1;
//		else
//			pulse1_out[3] <= 1'b0;				
//			
end

endmodule

