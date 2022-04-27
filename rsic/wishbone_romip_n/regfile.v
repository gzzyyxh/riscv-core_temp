`include "defines.v"

module regfile(

	input	wire										clk,
	input wire										rst,
	
	//写端口
	input wire										we,
	input wire[`RegAddrBus]				waddr,
	input wire[`RegBus]						wdata,
	
	//读端口1
	input wire										re1,
	input wire[`RegAddrBus]			  raddr1,
	output reg[`RegBus]           rdata1,
	
	//读端口2
	input wire										re2,
	input wire[`RegAddrBus]			  raddr2,
	output reg[`RegBus]           rdata2
	
);

//	(* ramstyle = "M9K" *)reg[`RegBus]  regs[0:`RegNum-1];

	reg wen;
	reg ren1;
	reg ren2;
	
	reg[`RegAddrBus]	waddr_b;
	reg[`RegAddrBus]	addr_b;
	reg[`RegAddrBus]	raddr_b;
	reg[`RegAddrBus]	addr_a;
	
	reg [`RegBus]	wrdata;
	
	wire[`RegBus]	rdata_a;
	wire[`RegBus]	rdata_b;

	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
//				regs[waddr] <= wdata;
				waddr_b <= waddr;
				wrdata <= wdata;
				wen <= `WriteEnable;
			end
		end
	end
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata1 <= `ZeroWord;
	  end else if(raddr1 == `RegNumLog2'h0) begin
	  		rdata1 <= `ZeroWord;
	  end else if((raddr1 == waddr) && (we == `WriteEnable) 
	  	            && (re1 == `ReadEnable)) begin
	  	  rdata1 <= wdata;
	  end else if(re1 == `ReadEnable) begin
//	      rdata1 <= regs[raddr1];
			ren1 <= `ReadEnable;
			addr_a <= raddr1;
			rdata1 <= rdata_a;
	  end else begin
	      rdata1 <= `ZeroWord;
	  end
	end

	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata2 <= `ZeroWord;
	  end else if(raddr2 == `RegNumLog2'h0) begin
	  		rdata2 <= `ZeroWord;
	  end else if((raddr2 == waddr) && (we == `WriteEnable) 
	  	            && (re2 == `ReadEnable)) begin
	  	  rdata2 <= wdata;
	  end else if(re2 == `ReadEnable) begin
//	      rdata2 <= regs[raddr2];
			ren2 <= `ReadEnable;
			raddr_b <= raddr2;
			rdata2 <= rdata_b;
	  end else begin
	      rdata2 <= `ZeroWord;
	  end
	end

	always @ (*) begin
		if(we == `WriteEnable) begin
			addr_b <= waddr_b;
		end else if(re2 == `ReadEnable) begin
			addr_b <= raddr_b;
		end
	end
	
reg_ram reg_ram0 (
  .address_a		(addr_a),
  .address_b		(addr_b),
  .clock       	(clk),
  .wren_a         (),
  .wren_b			(wen),
  .data_a         (),
  .data_b			(wrdata),
  .rden_a			(ren1),
  .rden_b			(ren2),
  .q_a            (rdata_a),
  .q_b				(rdata_b)
);

endmodule