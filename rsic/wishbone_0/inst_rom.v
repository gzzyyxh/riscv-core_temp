`include "defines.v"

module inst_rom(

//	input	wire										clk,
	input wire                    ce,
	input wire[`InstAddrBus]			addr,
	output reg[`InstBus]					inst
	
);

	reg[`InstBus]	temp_inst;

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];
	reg[4:0] n;

//	initial $readmemh ( "inst_rom.data", inst_mem );

	initial begin
//		$readmemh ( "D:/Github/OpenRSIC-V/rsic/wishbone_0/inst_rom.data", inst_mem );
		$readmemh ( "inst_rom.data", inst_mem );
		for(n=0;n<=15;n=n+1)
			$display("%h",inst_mem[n]);
	end
	

	always @ (*) begin
		if (ce == `ChipDisable) begin
			temp_inst <= `ZeroWord;
			inst <= `ZeroWord;
	  end else begin
			temp_inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
		  inst <= {temp_inst[7:0], temp_inst[15:8], temp_inst[23:16], temp_inst[31:24]};
		end
	end

endmodule