`include "defines.v"

module mem(

	input wire										rst,
	
	//来自执行阶段的信息	
	input wire[`RegAddrBus]       			wd_i,
	input wire                    			wreg_i,
	input wire[`RegBus]					 	 	wdata_i,
	
	input wire[`AluOpBus]						aluop_i,
	input wire[`RegBus]							mem_addr_i,
	input wire[`RegBus]							reg2_i,
	
	input wire[`RegBus]							mem_data_i, // 来自外部数据存储器的信息
	
	input wire										csr_reg_we_i,
	input wire[11:0]								csr_reg_write_addr_i,
	input wire[`RegBus]							csr_reg_data_i,
	
	input wire[31:0]             				excepttype_i,
	input wire[`RegBus]          				current_inst_address_i,
	
	input wire[`RegBus]          				csr_mstatus_i,
	input wire[`RegBus]          				csr_mepc_i,
	input wire[`RegBus]							csr_mie_i,
	input wire[`RegBus]							csr_mip_i,
	
	input wire                    			wb_csr_reg_we,
	input wire[11:0]               			wb_csr_reg_write_addr,
	input wire[`RegBus]           			wb_csr_reg_data,
	
	//送到回写阶段的信息
	output reg[`RegAddrBus]      				wd_o,
	output reg                   				wreg_o,
	output reg[`RegBus]					 		wdata_o,
	
	output reg[`RegBus]							mem_addr_o,
	output wire										mem_we_o,
	output reg[3:0]								mem_sel_o,
	output reg[`RegBus]							mem_data_o,
	output reg										mem_ce_o,
	
	output reg										csr_reg_we_o,
	output reg[11:0]								csr_reg_write_addr_o,
	output reg[`RegBus]							csr_reg_data_o,
	
	output reg[31:0]             				excepttype_o,
	output wire[`RegBus]          			csr_mepc_o,
	
	output wire[`RegBus]        	 			current_inst_address_o	
);

	wire[`RegBus] zero32;
	reg[`RegBus]  csr_mstatus;
//	reg[`RegBus]  csr_mcause;
	reg[`RegBus]  csr_mepc;
	reg[`RegBus]  csr_mie;
	reg[`RegBus]  csr_mip;
	reg			mem_we;

//	assign mem_we_o = mem_we;  //外部数据存储器的读写信号
	assign mem_we_o = mem_we & (~(|excepttype_o));
	assign zero32 = `ZeroWord;
	
	assign current_inst_address_o = current_inst_address_i;
	assign csr_mepc_o = csr_mepc;
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			wdata_o <= `ZeroWord;
			mem_addr_o <= `ZeroWord;
			mem_we <= `WriteDisable;
			mem_sel_o <= 4'b0000;
			mem_data_o <= `ZeroWord;
			mem_ce_o <= `ChipDisable;
			
			csr_reg_we_o <= `WriteDisable;
			csr_reg_write_addr_o <= 12'b000000000000;
			csr_reg_data_o <= `ZeroWord;
		end else begin
			wd_o <= wd_i;
			wreg_o <= wreg_i;
			wdata_o <= wdata_i;
			mem_addr_o <= `ZeroWord;
			mem_we <= `WriteDisable;
			mem_sel_o <= 4'b1111;
			mem_ce_o <= `ChipDisable;
			
			csr_reg_we_o <= csr_reg_we_i;
			csr_reg_write_addr_o <= csr_reg_write_addr_i;
			csr_reg_data_o <= csr_reg_data_i;
			
			case(aluop_i)
				`EXE_LB_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteDisable;
					mem_ce_o <= `ChipEnable;
					case (mem_addr_i[1:0])
						2'b00:	begin
							wdata_o <= {{24{mem_data_i[31]}},mem_data_i[31:24]};
							mem_sel_o <= 4'b1000;
						end
						2'b01:	begin
							wdata_o <= {{24{mem_data_i[23]}},mem_data_i[23:16]};
							mem_sel_o <= 4'b0100;
						end
						2'b10:	begin
							wdata_o <= {{24{mem_data_i[15]}},mem_data_i[15:8]};
							mem_sel_o <= 4'b0010;
						end
						2'b11:	begin
							wdata_o <= {{24{mem_data_i[7]}},mem_data_i[7:0]};
							mem_sel_o <= 4'b0001;
						end
						default:	begin
							wdata_o <= `ZeroWord;
						end
					endcase
				end
				`EXE_LBU_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteDisable;
					mem_ce_o <= `ChipEnable;
					case (mem_addr_i[1:0])
						2'b00:	begin
							wdata_o <= {{24{1'b0}},mem_data_i[31:24]};
							mem_sel_o <= 4'b1000;
						end
						2'b01:	begin
							wdata_o <= {{24{1'b0}},mem_data_i[23:16]};
							mem_sel_o <= 4'b0100;
						end
						2'b10:	begin
							wdata_o <= {{24{1'b0}},mem_data_i[15:8]};
							mem_sel_o <= 4'b0010;
						end
						2'b11:	begin
							wdata_o <= {{24{1'b0}},mem_data_i[7:0]};
							mem_sel_o <= 4'b0001;
						end
						default:	begin
							wdata_o <= `ZeroWord;
						end
					endcase				
				end
				`EXE_LH_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteDisable;
					mem_ce_o <= `ChipEnable;
					case (mem_addr_i[1:0])
						2'b00:	begin
							wdata_o <= {{16{mem_data_i[31]}},mem_data_i[31:16]};
							mem_sel_o <= 4'b1100;
						end
						2'b10:	begin
							wdata_o <= {{16{mem_data_i[15]}},mem_data_i[15:0]};
							mem_sel_o <= 4'b0011;
						end
						default:	begin
							wdata_o <= `ZeroWord;
						end
					endcase					
				end
				`EXE_LHU_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteDisable;
					mem_ce_o <= `ChipEnable;
					case (mem_addr_i[1:0])
						2'b00:	begin
							wdata_o <= {{16{1'b0}},mem_data_i[31:16]};
							mem_sel_o <= 4'b1100;
						end
						2'b10:	begin
							wdata_o <= {{16{1'b0}},mem_data_i[15:0]};
							mem_sel_o <= 4'b0011;
						end
						default:	begin
							wdata_o <= `ZeroWord;
						end
					endcase				
				end
				`EXE_LW_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteDisable;
					wdata_o <= mem_data_i;
					mem_sel_o <= 4'b1111;
					mem_ce_o <= `ChipEnable;		
				end
				`EXE_LWU_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteDisable;
					wdata_o <= mem_data_i;
					mem_sel_o <= 4'b1111;
					mem_ce_o <= `ChipEnable;				
				end
				`EXE_LD_OP:		begin
				
				end
				`EXE_SB_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteEnable;
					mem_data_o <= {reg2_i[7:0],reg2_i[7:0],reg2_i[7:0],reg2_i[7:0]};
					mem_ce_o <= `ChipEnable;
					case (mem_addr_i[1:0])
						2'b00:	begin
							mem_sel_o <= 4'b1000;
						end
						2'b01:	begin
							mem_sel_o <= 4'b0100;
						end
						2'b10:	begin
							mem_sel_o <= 4'b0010;
						end
						2'b11:	begin
							mem_sel_o <= 4'b0001;	
						end
						default:	begin
							mem_sel_o <= 4'b0000;
						end
					endcase				
				end
				`EXE_SH_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteEnable;
					mem_data_o <= {reg2_i[15:0],reg2_i[15:0]};
					mem_ce_o <= `ChipEnable;
					case (mem_addr_i[1:0])
						2'b00:	begin
							mem_sel_o <= 4'b1100;
						end
						2'b10:	begin
							mem_sel_o <= 4'b0011;
						end
						default:	begin
							mem_sel_o <= 4'b0000;
						end
					endcase						
				end
				`EXE_SW_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteEnable;
					mem_data_o <= reg2_i;
					mem_sel_o <= 4'b1111;	
					mem_ce_o <= `ChipEnable;		
				end
				`EXE_SD_OP:		begin
						
				end
			endcase
		end    //if
	end      //always
	
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			csr_mstatus <= `ZeroWord;
		end else if((wb_csr_reg_we == `WriteEnable) && 
								(wb_csr_reg_write_addr == `CSR_REG_MSTATUS ))begin
			csr_mstatus <= wb_csr_reg_data;
		end else begin
		  csr_mstatus <= csr_mstatus_i;
		end
	end
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			csr_mepc <= `ZeroWord;
		end else if((wb_csr_reg_we == `WriteEnable) && 
								(wb_csr_reg_write_addr == `CSR_REG_MEPC ))begin
			csr_mepc <= wb_csr_reg_data;
		end else begin
		  csr_mepc <= csr_mepc_i;
		end
	end
	
  always @ (*) begin
		if(rst == `RstEnable) begin
			csr_mip <= `ZeroWord;
		end else if((wb_csr_reg_we == `WriteEnable) && 
								(wb_csr_reg_write_addr == `CSR_REG_MIP ))begin
			csr_mip <= wb_csr_reg_data;
		end else begin
		  csr_mip <= csr_mip_i;
		end
	end
	
  always @ (*) begin
		if(rst == `RstEnable) begin
			csr_mie <= `ZeroWord;
		end else if((wb_csr_reg_we == `WriteEnable) && 
								(wb_csr_reg_write_addr == `CSR_REG_MIE ))begin
			csr_mie <= wb_csr_reg_data;
		end else begin
		  csr_mie <= csr_mie_i;
		end
	end

	always @ (*) begin
		if(rst == `RstEnable) begin
			excepttype_o <= `ZeroWord;
		end else begin
			excepttype_o <= `ZeroWord;
			
			if(current_inst_address_i != `ZeroWord) begin
				if((csr_mstatus[3] == 1'b1) && (csr_mie[11] == 1'b1)) begin					//全局中断MIE打开，未屏蔽MEIE
					excepttype_o <= 32'h00000001;        //interrupt
				end else if(excepttype_i[8] == 1'b1) begin
					excepttype_o <= 32'h00000008;        //ecall
				end else if(excepttype_i[9] == 1'b1) begin
					excepttype_o <= 32'h0000000a;        //inst_invalid
				end else if(excepttype_i[10] ==1'b1) begin
					excepttype_o <= 32'h0000000d;        //trap
				end else if(excepttype_i[12] == 1'b1) begin  //返回指令
					excepttype_o <= 32'h0000000e;
				end
			end
				
		end
	end	

endmodule
