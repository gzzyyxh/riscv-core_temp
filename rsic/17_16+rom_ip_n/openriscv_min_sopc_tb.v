`include "defines.v"
`timescale 1ns/1ps

module openriscv_min_sopc_tb();

  reg     CLOCK_50;
  reg     rst;
  
       
  initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end
      
  initial begin
    rst = `RstEnable;
    #195 rst= `RstDisable;
    #5000 $stop;
  end
       
  openriscv_min_sopc openriscv_min_sopc0(
		.clk(CLOCK_50),
		.rst(~rst)	
	);

endmodule