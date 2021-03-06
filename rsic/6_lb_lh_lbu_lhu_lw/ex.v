`include "defines.v"

module ex(

	input wire										rst,
	
	//送到执行阶段的信息
	input wire[`AluOpBus]         aluop_i,
	input wire[`AluSelBus]        alusel_i,
	input wire[`RegBus]           reg1_i,
	input wire[`RegBus]           reg2_i,
	input wire[`RegAddrBus]       wd_i,
	input wire                    wreg_i,
	input wire[`RegBus]				link_address_i,
	
	input wire[`RegBus]				inst_i,

	//与除法模块相连
	input wire[`DoubleRegBus]     div_result_i,
	input wire                    div_ready_i,
	
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o,
	output reg[`RegBus]				wdata_o,

	output reg[`RegBus]           div_opdata1_o,
	output reg[`RegBus]           div_opdata2_o,
	output reg                    div_start_o,
	output reg                    signed_div_o,

	output reg							stallreq,
	
	output wire[`AluOpBus]			aluop_o,
	output wire[`RegBus]				mem_addr_o,
	output wire[`RegBus]				reg2_o
);

	reg[`RegBus] logicout;
	reg[`RegBus] shiftres;
	reg[`RegBus] arithmeticres;
	reg[`RegBus] moveres;
	
	wire[`RegBus] reg2_i_mux;
	wire[`RegBus] reg1_i_not;	
	wire[`RegBus] result_sum;
	wire ov_sum;
	wire reg1_eq_reg2;
	wire reg1_lt_reg2;
	wire[`RegBus] opdata1_mult;		//补码：用于减法/有符号运算
	wire[`RegBus] opdata2_mult;		//取反值，
	wire[`DoubleRegBus] hilo_temp;
	reg[`DoubleRegBus] mulres;

	reg stallreq_for_div;
	
	assign aluop_o = aluop_i; //传递到访存阶段，用于确定加载、存储类型
	
	assign mem_addr_o = (inst_i[6:0] == 7'b0100011) ?
								(reg1_i + {{20{inst_i[31]}},inst_i[31:25],inst_i[11:7]}) :
								(reg1_i + {{20{inst_i[31]}},inst_i[31:20]});
	
	assign reg2_o = reg2_i;

	assign reg2_i_mux = ((aluop_i == `EXE_SUB_OP) || (aluop_i == `EXE_SLT_OP)) ? ((~reg2_i)+1) : reg2_i;

	assign result_sum = reg1_i + reg2_i_mux;

	assign ov_sum = ((!reg1_i[31] && !reg2_i_mux[31]) && result_sum[31]) || ((reg1_i[31] && reg2_i_mux[31]) && (!result_sum[31]));
	
	assign reg1_lt_reg2 = ((aluop_i == `EXE_SLT_OP)) ?
												 ((reg1_i[31] && !reg2_i[31]) || 
												 (!reg1_i[31] && !reg2_i[31] && result_sum[31])||
			                   (reg1_i[31] && reg2_i[31] && result_sum[31]))
			                   :	(reg1_i < reg2_i);
	
  assign reg1_i_not = ~reg1_i;
  
  //取得乘法操作的操作数，如果是有符号除法且操作数是负数，那么取反加一
	assign opdata1_mult = (((aluop_i == `EXE_MUL_OP) || (aluop_i == `EXE_MULH_OP) || (aluop_i == `EXE_MULHSU_OP))
													&& (reg1_i[31] == 1'b1)) ? (~reg1_i + 1) : reg1_i;

  assign opdata2_mult = (((aluop_i == `EXE_MUL_OP) || (aluop_i == `EXE_MULH_OP))
													&& (reg2_i[31] == 1'b1)) ? (~reg2_i + 1) : reg2_i;		

  assign hilo_temp = opdata1_mult * opdata2_mult;
  
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
			arithmeticres <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_OR_OP:			begin
					logicout <= reg1_i | reg2_i;
				end
				`EXE_AND_OP:		begin
					logicout <= reg1_i & reg2_i;
				end
				`EXE_XOR_OP:		begin
					logicout <= reg1_i ^ reg2_i;
				end
				`EXE_SLT_OP, `EXE_SLTU_OP:		begin
					arithmeticres <= reg1_lt_reg2;
				end
				`EXE_ADD_OP, `EXE_ADDI_OP, `EXE_SUB_OP:		begin
					arithmeticres <= result_sum;
				end
				default:				begin
					logicout <= `ZeroWord;
					arithmeticres <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always

	always @ (*) begin
		if(rst == `RstEnable) begin
			shiftres <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_SLL_OP:			begin
					shiftres <= reg1_i << reg2_i[4:0] ;
				end
				`EXE_SRL_OP:		begin
					shiftres <= reg1_i >> reg2_i[4:0];
				end
				`EXE_SRA_OP:		begin
					shiftres <= ({32{reg1_i[31]}} << (6'd32-{1'b0, reg2_i[4:0]})) | reg1_i >> reg2_i[4:0];
				end
				default:				begin
					shiftres <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always

	always @ (*) begin
		if(rst == `RstEnable) begin
			mulres <= {`ZeroWord,`ZeroWord};
		end else if ((aluop_i == `EXE_MUL_OP) || (aluop_i == `EXE_MULH_OP) || (aluop_i == `EXE_MULHSU_OP))begin
			if(reg1_i[31] ^ reg2_i[31] == 1'b1) begin
				mulres <= ~hilo_temp + 1;
			end else begin
			  mulres <= hilo_temp;
			end
		end else begin
				mulres <= hilo_temp;
		end
	end
	
  always @ (*) begin
    stallreq = stallreq_for_div;
  end

  //DIV、DIVU指令	
	always @ (*) begin
		if(rst == `RstEnable) begin
			stallreq_for_div <= `NoStop;
			div_opdata1_o <= `ZeroWord;
			div_opdata2_o <= `ZeroWord;
			div_start_o <= `DivStop;
			signed_div_o <= 1'b0;
		end else begin
			stallreq_for_div <= `NoStop;
			div_opdata1_o <= `ZeroWord;
			div_opdata2_o <= `ZeroWord;
			div_start_o <= `DivStop;
			signed_div_o <= 1'b0;	
			case (aluop_i) 
				`EXE_DIV_OP, `EXE_REM_OP:		begin
					if(div_ready_i == `DivResultNotReady) begin
						div_opdata1_o <= reg1_i;
						div_opdata2_o <= reg2_i;
						div_start_o <= `DivStart;
						signed_div_o <= 1'b1;						//有符号除法
						stallreq_for_div <= `Stop;
					end else if(div_ready_i == `DivResultReady) begin
						div_opdata1_o <= reg1_i;
						div_opdata2_o <= reg2_i;
						div_start_o <= `DivStop;
						signed_div_o <= 1'b1;						//有符号除法
						stallreq_for_div <= `NoStop;
					end else begin						
						div_opdata1_o <= `ZeroWord;
						div_opdata2_o <= `ZeroWord;
						div_start_o <= `DivStop;
						signed_div_o <= 1'b0;						//无符号除法
						stallreq_for_div <= `NoStop;
					end					
				end
				`EXE_DIVU_OP, `EXE_REMU_OP:		begin
					if(div_ready_i == `DivResultNotReady) begin
						div_opdata1_o <= reg1_i;
						div_opdata2_o <= reg2_i;
						div_start_o <= `DivStart;
						signed_div_o <= 1'b0;
						stallreq_for_div <= `Stop;
					end else if(div_ready_i == `DivResultReady) begin
						div_opdata1_o <= reg1_i;
						div_opdata2_o <= reg2_i;
						div_start_o <= `DivStop;
						signed_div_o <= 1'b0;
						stallreq_for_div <= `NoStop;
					end else begin						
						div_opdata1_o <= `ZeroWord;
						div_opdata2_o <= `ZeroWord;
						div_start_o <= `DivStop;
						signed_div_o <= 1'b0;
						stallreq_for_div <= `NoStop;
					end					
				end
				default: begin
				end
			endcase
		end
	end	

 always @ (*) begin
	 wd_o <= wd_i;	 	 	
	 wreg_o <= wreg_i;
	 case ( alusel_i ) 
	 	`EXE_RES_LOGIC:		begin
	 		wdata_o <= logicout;
	 	end
	 	`EXE_RES_SHIFT:		begin
	 		wdata_o <= shiftres;
	 	end
		`EXE_RES_ARITHMETIC:	begin
			wdata_o <= arithmeticres;
		end
		`EXE_RES_MUL:		begin
			case(aluop_i)
				`EXE_MUL_OP:		begin
					wdata_o <= mulres[31:0];
				end
				`EXE_MULH_OP, `EXE_MULHU_OP, `EXE_MULHSU_OP:		begin
					wdata_o <= mulres[63:32];
				end
			endcase
		end
		`EXE_RES_DIV:		begin
			case(aluop_i)
				`EXE_DIV_OP, `EXE_DIVU_OP:		begin
					wdata_o <= div_result_i[31:0];
				end
				`EXE_REM_OP, `EXE_REMU_OP:		begin
					wdata_o <= div_result_i[63:32];
				end
			endcase
		end
		`EXE_RES_JUMP_BRANCH:	begin
			wdata_o <= link_address_i;
		end
	 	default:					begin
	 		wdata_o <= `ZeroWord;
	 	end
	 endcase
 end	

endmodule
