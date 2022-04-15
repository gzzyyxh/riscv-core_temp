`include "defines.v"

module csr(

	input	wire										clk,
	input wire										rst,
	
	
	input wire                    we_i,
	input wire[11:0]               waddr_i,
	input wire[11:0]               raddr_i,
	input wire[`RegBus]           data_i,
	
//	input wire[31:0]              excepttype_i,
//	input wire[5:0]               int_i,
//	input wire[`RegBus]           current_inst_addr_i,
//	input wire                    is_in_delayslot_i,
	
	output reg[`RegBus]           data_o
//	output reg[`RegBus]           count_o,
//	output reg[`RegBus]           compare_o,
//	output reg[`RegBus]           status_o,
//	output reg[`RegBus]           cause_o,
//	output reg[`RegBus]           epc_o,
//	output reg[`RegBus]           config_o,
//	output reg[`RegBus]           prid_o,
	
//	output reg                   timer_int_o    

);

	reg[`RegBus]				fflags_o;
	reg[`RegBus]				frm_o;
	reg[`RegBus]				fcsr_o;
	reg[`RegBus]				mstatus_o;
	reg[`RegBus]				misa_o;
	reg[`RegBus]				mie_o;
	reg[`RegBus]				mtvec_o;
	reg[`RegBus]				mscratch_o;
	reg[`RegBus]				mepc_o;
	reg[`RegBus]				mcause_o;
	reg[`RegBus]				mtval_o;
	reg[`RegBus]				mip_o;
	reg[`RegBus]				mcycle_o;
	reg[`RegBus]				mcycleh_o;
	reg[`RegBus]				minstret_o;
	reg[`RegBus]				minstreth_o;
	reg[`RegBus]				mvendorid_o;
	reg[`RegBus]				marchid_o;
	reg[`RegBus]				mimpid_o;
	reg[`RegBus]				mhartid_o;
	reg[`RegBus]				mtime_o;
	reg[`RegBus]				mtimecmp_o;
	reg[`RegBus]				msip_o;


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			fflags_o <= `ZeroWord;
			frm_o <= `ZeroWord;
			fcsr_o <= `ZeroWord;
			mstatus_o <= `ZeroWord;
			misa_o <= `ZeroWord;
			mie_o <= `ZeroWord;
			mtvec_o <= `ZeroWord;
			mscratch_o <= `ZeroWord;
			mepc_o <= `ZeroWord;
			mcause_o <= `ZeroWord;
			mtval_o <= `ZeroWord;
			mip_o <= `ZeroWord;
			mcycle_o <= `ZeroWord;
			mcycleh_o <= `ZeroWord;
			minstret_o <= `ZeroWord;
			minstreth_o <= `ZeroWord;
			mvendorid_o <= `ZeroWord;
			marchid_o <= `ZeroWord;
			mimpid_o <= `ZeroWord;
			mhartid_o <= `ZeroWord;
			mtime_o <= `ZeroWord;
			mtimecmp_o <= `ZeroWord;
			msip_o <= `ZeroWord;
		end else begin
			if(we_i == `WriteEnable) begin
				case (waddr_i) 
					`CSR_REG_FFLAGS:		begin
						fflags_o <= data_i ;
					end
					`CSR_REG_FRM:	begin
						frm_o <= data_i ;
					end
					`CSR_REG_FCSR:	begin
						fcsr_o <= data_i ;
					end
					`CSR_REG_MSTATUS:	begin
						mstatus_o <= data_i ;
					end
					`CSR_REG_MISA:	begin
						misa_o <= data_i ;
					end
					`CSR_REG_MIE:	begin
						mie_o <= data_i ;
					end
					`CSR_REG_MTVEC:	begin
						mtvec_o <= data_i ;
					end
					`CSR_REG_MSCRATCH:	begin
						mscratch_o <= data_i ;
					end
					`CSR_REG_MEPC:	begin
						mepc_o <= data_i ;
					end
					`CSR_REG_MCAUSE:	begin
						mcause_o <= data_i ;
					end
					`CSR_REG_MTVAL:	begin
						mtval_o <= data_i ;
					end
					`CSR_REG_MIP:	begin
						mip_o <= data_i ;
					end
					`CSR_REG_MCYCLE:	begin
						mcycle_o <= data_i ;
					end
					`CSR_REG_MCYCLEH:	begin
						mcycleh_o <= data_i ;
					end
					`CSR_REG_MINSTRET:	begin
						minstret_o <= data_i ;
					end
					`CSR_REG_MINSTRETH:	begin
						minstreth_o <= data_i ;
					end
					`CSR_REG_MVENDORID:	begin
						mvendorid_o <= data_i ;
					end
					`CSR_REG_MARCHID:	begin
						marchid_o <= data_i ;
					end
					`CSR_REG_MIMPID:	begin
						mimpid_o <= data_i ;
					end
					`CSR_REG_MHARTID:	begin
						mhartid_o <= data_i ;
					end
					`CSR_REG_MTINME:	begin
						mtime_o <= data_i ;
					end
					`CSR_REG_MTIMECMP:	begin
						mtimecmp_o <= data_i ;
					end
					`CSR_REG_MSIP:	begin
						msip_o <= data_i ;
					end
					default: 	begin
					end			
				endcase  //case addr_i			
			end    //if
		end    //if
	end      //always
			
	always @ (*) begin
		if(rst == `RstEnable) begin
			data_o <= `ZeroWord;
		end else begin
				case (raddr_i) 
					`CSR_REG_FFLAGS:		begin
						data_o <= fflags_o ;
					end
					`CSR_REG_FRM:	begin
						data_o <= frm_o ;
					end
					`CSR_REG_FCSR:	begin
						data_o <= fcsr_o ;
					end
					`CSR_REG_MSTATUS:	begin
						data_o <= mstatus_o ;
					end
					`CSR_REG_MISA:	begin
						data_o <= misa_o ;
					end
					`CSR_REG_MIE:	begin
						data_o <= mie_o ;
					end
					`CSR_REG_MTVEC:	begin
						data_o <= mtvec_o ;
					end
					`CSR_REG_MSCRATCH:	begin
						data_o <= mscratch_o ;
					end
					`CSR_REG_MEPC:	begin
						data_o <= mepc_o ;
					end
					`CSR_REG_MCAUSE:	begin
						data_o <= mcause_o ;
					end
					`CSR_REG_MTVAL:	begin
						data_o <= mtval_o ;
					end
					`CSR_REG_MIP:	begin
						data_o <= mip_o ;
					end
					`CSR_REG_MCYCLE:	begin
						data_o <= mcycle_o ;
					end
					`CSR_REG_MCYCLEH:	begin
						data_o <= mcycleh_o ;
					end
					`CSR_REG_MINSTRET:	begin
						data_o <= minstret_o ;
					end
					`CSR_REG_MINSTRETH:	begin
						data_o <= minstreth_o ;
					end
					`CSR_REG_MVENDORID:	begin
						data_o <= mvendorid_o ;
					end
					`CSR_REG_MARCHID:	begin
						data_o <= marchid_o ;
					end
					`CSR_REG_MIMPID:	begin
						data_o <= mimpid_o ;
					end
					`CSR_REG_MHARTID:	begin
						data_o <= mhartid_o ;
					end
					`CSR_REG_MTINME:	begin
						data_o <= mtime_o ;
					end
					`CSR_REG_MTIMECMP:	begin
						data_o <= mtimecmp_o ;
					end
					`CSR_REG_MSIP:	begin
						data_o <= msip_o ;
					end
					default: 	begin
					end			
				endcase  //case addr_i			
		end    //if
	end      //always

endmodule
