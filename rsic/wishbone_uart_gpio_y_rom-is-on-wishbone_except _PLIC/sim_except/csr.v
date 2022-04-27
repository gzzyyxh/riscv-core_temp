`include "defines.v"

module csr(

	input	wire										clk,
	input wire										rst,
	
	
	input wire                    we_i,
	input wire[11:0]              waddr_i,
	input wire[11:0]              raddr_i,
	input wire[`RegBus]           data_i,
	
	input wire[31:0]              excepttype_i,
	input wire		               int_i,
	input wire[`RegBus]           current_inst_addr_i,
	
	output reg[`RegBus]           data_o,
//	output reg[`RegBus]           count_o,
//	output reg[`RegBus]           compare_o,
//	output reg[`RegBus]           status_o,
//	output reg[`RegBus]           cause_o,
//	output reg[`RegBus]           epc_o,
//	output reg[`RegBus]           config_o,
//	output reg[`RegBus]           prid_o,
	
	output reg                   timer_int_o,
	
	output wire[`RegBus]				mstatus_o,
	output wire[`RegBus]				mepc_o,
	output wire[`RegBus]				mie_o,
	output wire[`RegBus]				mip_o,
	output wire[`RegBus]				mtvec_o
);

	reg[`RegBus]				fflags;	//浮点累计异常					//
	reg[`RegBus]				frm;		//浮点动态舍入模式					//
	reg[`RegBus]				fcsr;		//浮点控制和状态寄存器					//
	reg[`RegBus]				mstatus;	//机器模式状态寄存器*
	reg[`RegBus]				misa;		//机器模式指令集架构寄存器					//
	reg[`RegBus]				mie;		//机器模式终端使能寄存器*
	reg[`RegBus]				mtvec;		//机器模式异常入口基地址寄存器*
	reg[`RegBus]				mscratch;	//机器模式擦写寄存器*
	reg[`RegBus]				mepc;		//机器模式异常PC寄存器*
	reg[`RegBus]				mcause;	//机器模式异常原因寄存器*
	reg[`RegBus]				mtval;		//机器模式异常值寄存器*
	reg[`RegBus]				mip;		//机器模式中断等待寄存器*
	reg[`RegBus]				mcycle;	//周期计数低32位*
	reg[`RegBus]				mcycleh;	//周期计数高32位*
	reg[`RegBus]				minstret;	//退休指令计数器的低32位*
	reg[`RegBus]				minstreth;	//退休指令计数器的高32位*
	reg[`RegBus]				mvendorid;	//机器模式供应商编号寄存器					//
	reg[`RegBus]				marchid;	//机器模式架构编号寄存器					//
	reg[`RegBus]				mimpid;	//机器模式硬件实现编号寄存器					//
	reg[`RegBus]				mhartid;	//Hart编号寄存器
	reg[`RegBus]				mtime;		//机器模式计时器寄存器					//
	reg[`RegBus]				mtimecmp;	//机器模式计时器比较寄存器					//
	reg[`RegBus]				msip;		//机器模式软件中断等待寄存器					//	
	
	
	
	initial begin
		misa <= 32'h40001100;
		mvendorid <= 32'h00000000;
		marchid <= 32'h00000000;
		mimpid <= 32'h00000000;
		mhartid <= 32'h00000000;
	end
	
	assign mstatus_o = mstatus;
	assign mepc_o = mepc;
	assign mie_o = mie;
	assign mip_o = mip;
	assign mtvec_o = mtvec;


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			mstatus <= 32'h00000008;
			mie <= `ZeroWord;
			mtvec <= `ZeroWord;
			mscratch <= `ZeroWord;
			mepc <= `ZeroWord;
			mcause <= `ZeroWord;
			mtval <= `ZeroWord;
			mip <= `ZeroWord;
			mcycle <= `ZeroWord;
			mcycleh <= `ZeroWord;
			minstret <= `ZeroWord;
			minstreth <= `ZeroWord;
			marchid <= `ZeroWord;
			mtime <= `ZeroWord;
			mtimecmp <= `ZeroWord;
			msip <= `ZeroWord;
			mhartid <= `ZeroWord;
			timer_int_o <= `InterruptNotAssert;
		end else begin
			if(mcycle == 32'hffffffff) begin
				mcycle <= 32'h00000000;
				mcycleh <= mcycleh + 1;
			end else if(mcycle != 32'hffffffff) begin
				mcycle <= mcycle + 1;
			end
			if((mtimecmp < mtime) | (mtimecmp == mtime)) begin
				timer_int_o <= `InterruptAssert;
			end
			if(we_i == `WriteEnable) begin
				case (waddr_i) 
					`CSR_REG_FFLAGS:		begin
						fflags <= data_i ;
					end
					`CSR_REG_FRM:	begin
						frm <= data_i ;
					end
					`CSR_REG_FCSR:	begin
						fcsr <= data_i ;
					end
					`CSR_REG_MSTATUS:	begin
						mstatus <= data_i ;
					end
					`CSR_REG_MISA:	begin
						misa <= data_i ;
					end
					`CSR_REG_MIE:	begin
						mie <= data_i ;
					end
					`CSR_REG_MTVEC:	begin
						mtvec <= data_i ;
					end
					`CSR_REG_MSCRATCH:	begin
						mscratch <= data_i ;
					end
					`CSR_REG_MEPC:	begin
						mepc <= data_i ;
					end
					`CSR_REG_MCAUSE:	begin
						mcause <= data_i ;
					end
					`CSR_REG_MTVAL:	begin
						mtval <= data_i ;
					end
					`CSR_REG_MIP:	begin
						mip <= data_i ;
					end
					`CSR_REG_MCYCLE:	begin
						mcycle <= data_i ;
					end
					`CSR_REG_MCYCLEH:	begin
						mcycleh <= data_i ;
					end
					`CSR_REG_MINSTRET:	begin
						minstret <= data_i ;
					end
					`CSR_REG_MINSTRETH:	begin
						minstreth <= data_i ;
					end
					`CSR_REG_MVENDORID:	begin
						mvendorid <= data_i ;
					end
					`CSR_REG_MARCHID:	begin
						marchid <= data_i ;
					end
					`CSR_REG_MIMPID:	begin
						mimpid <= data_i ;
					end
					`CSR_REG_MHARTID:	begin
						mhartid <= data_i ;
					end
					`CSR_REG_MTINME:	begin
						mtime <= data_i ;
					end
					`CSR_REG_MTIMECMP:	begin
						mtimecmp <= data_i ;
						if(mtimecmp > mtime) begin
							timer_int_o <= `InterruptNotAssert;
						end
					end
					`CSR_REG_MSIP:	begin
						msip <= data_i ;
					end
					default: 	begin
					end			
				endcase  //case addr_i	
			end    //if
			
			if(excepttype_i[31] == 1'b1) begin						// Interrupt
				case (excepttype_i[3:0])
					4'd11:		begin										//external interrupt
							mcause <= excepttype_i;
							mepc <= current_inst_addr_i + 4;
							mstatus[7] <= mstatus[3];			//MPIE <= MIE
							mstatus[3] <= 1'b0;					//关中断
							mstatus[12:11] <= 2'b11;			//Machine-mode
//							mtvec <= 32'h00000020;
//							mip[11] <= 1'b1;
					end
				endcase
			end else if(excepttype_i[31] == 1'b0) begin			// Not Interrupt
				case (excepttype_i[30:0])		
					{3'b0, 28'h000000b}:		begin				//ecall
						mcause <= {3'b0, 28'h000000b};
						mepc <= current_inst_addr_i + 4'h4;
						mstatus[7] <= mstatus[3];			//MPIE <= MIE
						mstatus[3] <= 1'b0;					//关中断
						mstatus[12:11] <= 2'b11;			//Machine-mode
//						mtvec <= 32'h00000040;
					end
					{3'b0, 28'h0000002}:		begin				//inst invalid
						mcause <= {3'b0, 28'h0000002};
						mepc <= current_inst_addr_i;
						mstatus[7] <= mstatus[3];			//MPIE <= MIE
						mstatus[3] <= 1'b0;					//关中断
						mstatus[12:11] <= 2'b11;			//Machine-mode
//						mtvec <= 32'h00000040;
						mtval <= current_inst_addr_i;
					end
					{3'b0, 28'h000000a}:		begin				//mret
						mcause <= {3'b0, 28'h000000a};
//						mepc <= current_inst_addr_i;
						mstatus[3] <= mstatus[7];			//MIE <= MPIE
						mstatus[7] <= 1'b1;					//开中断
					end
				endcase
			end
		end    //if
	end      //always
			
	always @ (*) begin
		if(rst == `RstEnable) begin
			data_o <= `ZeroWord;
		end else begin
				case (raddr_i) 
					`CSR_REG_FFLAGS:		begin
						data_o <= fflags ;
					end
					`CSR_REG_FRM:	begin
						data_o <= frm ;
					end
					`CSR_REG_FCSR:	begin
						data_o <= fcsr ;
					end
					`CSR_REG_MSTATUS:	begin
						data_o <= mstatus ;
					end
					`CSR_REG_MISA:	begin
						data_o <= misa ;
					end
					`CSR_REG_MIE:	begin
						data_o <= mie ;
					end
					`CSR_REG_MTVEC:	begin
						data_o <= mtvec ;
					end
					`CSR_REG_MSCRATCH:	begin
						data_o <= mscratch ;
					end
					`CSR_REG_MEPC:	begin
						data_o <= mepc ;
					end
					`CSR_REG_MCAUSE:	begin
						data_o <= mcause ;
					end
					`CSR_REG_MTVAL:	begin
						data_o <= mtval ;
					end
					`CSR_REG_MIP:	begin
						data_o <= mip ;
					end
					`CSR_REG_MCYCLE:	begin
						data_o <= mcycle ;
					end
					`CSR_REG_MCYCLEH:	begin
						data_o <= mcycleh ;
					end
					`CSR_REG_MINSTRET:	begin
						data_o <= minstret ;
					end
					`CSR_REG_MINSTRETH:	begin
						data_o <= minstreth ;
					end
					`CSR_REG_MVENDORID:	begin
						data_o <= mvendorid ;
					end
					`CSR_REG_MARCHID:	begin
						data_o <= marchid ;
					end
					`CSR_REG_MIMPID:	begin
						data_o <= mimpid ;
					end
					`CSR_REG_MHARTID:	begin
						data_o <= mhartid ;
					end
					`CSR_REG_MTINME:	begin
						data_o <= mtime ;
					end
					`CSR_REG_MTIMECMP:	begin
						data_o <= mtimecmp ;
					end
					`CSR_REG_MSIP:	begin
						data_o <= msip ;
					end
					default: 	begin
					end			
				endcase  //case addr_i			
		end    //if
	end      //always

endmodule
