`include "defines.v"

module id(

	input wire							rst,
	input wire[`InstAddrBus]		pc_i,
	input wire[`InstBus]          inst_i,
	
	//处于执行阶段的指令要写入的目的寄存器信息
	input wire							ex_wreg_i,
	input wire[`RegBus]				ex_wdata_i,
	input wire[`RegAddrBus]       ex_wd_i,
	
	//处于访存阶段的指令要写入的目的寄存器信息
	input wire							mem_wreg_i,
	input wire[`RegBus]				mem_wdata_i,
	input wire[`RegAddrBus]       mem_wd_i,

	input wire[`RegBus]           reg1_data_i,
	input wire[`RegBus]           reg2_data_i,

	//送到regfile的信息
	output reg                    reg1_read_o,
	output reg                    reg2_read_o,     
	output reg[`RegAddrBus]       reg1_addr_o,
	output reg[`RegAddrBus]       reg2_addr_o, 	      
	
	//送到执行阶段的信息
	output reg[`AluOpBus]         aluop_o,
	output reg[`AluSelBus]        alusel_o,
	output reg[`RegBus]           reg1_o,
	output reg[`RegBus]           reg2_o,
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o
);

  wire[6:0] op = inst_i[6:0];
  wire[2:0] op2 = inst_i[14:12];
  wire[6:0] op3 = inst_i[31:25];
  wire[5:0] op3_i = inst_i[31:26];
  reg[`RegBus]	imm;
  reg instvalid;
  
 
	always @ (*) begin	
		if (rst == `RstEnable) begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			instvalid <= `InstValid;
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm <= 32'h0;			
	  end else begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= inst_i[11:7];
			wreg_o <= `WriteDisable;
			instvalid <= `InstInvalid;	   
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[19:15];    // rs1
			reg2_addr_o <= inst_i[24:20];		// rs1 | imm
			imm <= `ZeroWord;			
		  case (op)
			 `EXE_I_INST:	begin
					case(op2) 
						   `EXE_ORI:			begin                        //ORI指令
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_OR_OP;
								alusel_o <= `EXE_RES_LOGIC;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b0;	  	
								imm <= {{20{inst_i[31]}},inst_i[31:20]};
								wd_o <= inst_i[11:7];
								instvalid <= `InstValid;	
							end
							`EXE_ANDI:		begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_AND_OP;
								alusel_o <= `EXE_RES_LOGIC;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b0;	  	
								imm <= {{20{inst_i[31]}},inst_i[31:20]};
								wd_o <= inst_i[11:7];	  	
								instvalid <= `InstValid;
							end
							`EXE_XORI:		begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_XOR_OP;
								alusel_o <= `EXE_RES_LOGIC;
								reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;	  	
								imm <= {{20{inst_i[31]}},inst_i[31:20]};
								wd_o <= inst_i[11:7];			  	
								instvalid <= `InstValid;
							end
							`EXE_SLLI:		begin
								if(op3_i == 6'b000000 & inst_i[25] == 0) begin
									wreg_o <= `WriteEnable;
									aluop_o <= `EXE_SLL_OP;
									alusel_o <= `EXE_RES_SHIFT;
									reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;	  	
									imm[4:0] <= inst_i[25:20];
									wd_o <= inst_i[11:7];	
									instvalid <= `InstValid;
								end
							end
							`EXE_SRLI_SRAI:		begin
								if(op3_i == 6'b000000 & inst_i[25] == 0) begin		//SRLI
									wreg_o <= `WriteEnable;
									aluop_o <= `EXE_SRL_OP;
									alusel_o <= `EXE_RES_SHIFT;
									reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;	  	
									imm[4:0] <= inst_i[25:20];
									wd_o <= inst_i[11:7];
									instvalid <= `InstValid;
								end
								if(op3_i == 6'b010000 & inst_i[25] == 0) begin		//SRAI
									wreg_o <= `WriteEnable;
									aluop_o <= `EXE_SRA_OP;
									alusel_o <= `EXE_RES_SHIFT;
									reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;	  	
									imm[4:0] <= inst_i[25:20];
									wd_o <= inst_i[11:7];
									instvalid <= `InstValid;
								end
							end
							default:		begin
							end
					endcase
				end
				`EXE_R_INST:		begin
					case(op2)
						`EXE_AND_REMU:		begin
							if(op3 == 7'b0000000) begin			//AND
		    					wreg_o <= `WriteEnable;
								aluop_o <= `EXE_AND_OP;
		  						alusel_o <= `EXE_RES_LOGIC;
								reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;	
		  						instvalid <= `InstValid;
							end
						end
						`EXE_OR_REM:		begin
							if(op3 == 7'b0000000) begin			//OR
		    					wreg_o <= `WriteEnable;
								aluop_o <= `EXE_OR_OP;
		  						alusel_o <= `EXE_RES_LOGIC;
								reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  						instvalid <= `InstValid;
							end
						end
						`EXE_XOR_DIV:		begin
							if(op3 == 7'b0000000) begin
		    					wreg_o <= `WriteEnable;
								aluop_o <= `EXE_XOR_OP;
		  						alusel_o <= `EXE_RES_LOGIC;
								reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;	
		  						instvalid <= `InstValid;
							end
						end
						`EXE_SLL_MULB:		begin
							if(op3 == 7'b0000000) begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_SLL_OP;
		  						alusel_o <= `EXE_RES_SHIFT;
								reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  						instvalid <= `InstValid;
							end
						end
						`EXE_SRL_SRA_DIVU:		begin
							if(op3 == 7'b0000000) begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_SRL_OP;
		  						alusel_o <= `EXE_RES_SHIFT;
								reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  						instvalid <= `InstValid;
							end
							if(op3 == 7'b0100000) begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_SRA_OP;
		  						alusel_o <= `EXE_RES_SHIFT;
								reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  						instvalid <= `InstValid;	
							end
						end
						default:		begin
						end
					endcase
				end
				`EXE_LUI:		begin
					wreg_o <= `WriteEnable;
					aluop_o <= `EXE_OR_OP;
					alusel_o <= `EXE_RES_LOGIC;
					reg1_read_o <= 1'b1;
					reg1_addr_o <= 5'b00000;		// zero
					reg2_read_o <= 1'b0;
//					imm <= {inst_i[31:12],12'b0};
					imm <= (inst_i >> 12)<<12;
					wd_o <= inst_i[11:7];  	
					instvalid <= `InstValid;	
				end
		    default:			begin
		    end
		  endcase		  //case op			
		end       //if
	end         //always
	

	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
		end else if(reg1_read_o == 1'b0) begin
			reg1_o <= imm;			
		end else if(reg1_read_o == 1'b1) begin
			if((ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o)) begin
				reg1_o <= ex_wdata_i;
			end else if((mem_wreg_i == 1'b1)&& (mem_wd_i == reg1_addr_o)) begin
				reg1_o <= mem_wdata_i;
			end
			else begin
				reg1_o <= reg1_data_i;
			end
		end else begin
	    reg1_o <= `ZeroWord;
	  end
	end
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
		end else if(reg2_read_o == 1'b0) begin
			reg2_o <= imm;			
		end else if(reg2_read_o == 1'b1) begin
			if((ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o)) begin
				reg2_o <= ex_wdata_i;
			end else if((mem_wreg_i == 1'b1)&& (mem_wd_i == reg2_addr_o)) begin
				reg2_o <= mem_wdata_i;
			end
			else begin
				reg2_o <= reg2_data_i;
			end
		end else begin
	    reg2_o <= `ZeroWord;
	  end
	end
	
//	always @ (*) begin
//		if(rst == `RstEnable) begin
//			reg2_o <= `ZeroWord;
//		end else if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) 
//								&& (ex_wd_i == reg2_addr_o)) begin
//			reg2_o <= ex_wdata_i; 
//		end else if((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) 
//								&& (mem_wd_i == reg2_addr_o)) begin
//			reg2_o <= mem_wdata_i;	
//	  end else if(reg2_read_o == 1'b1) begin
//	  	reg2_o <= reg2_data_i;
//	  end else if(reg2_read_o == 1'b0) begin
//	  	reg2_o <= imm;
//	  end else begin
//	    reg2_o <= `ZeroWord;
//	  end
//	end

endmodule
