//全局
`define RstEnable 1'b1
`define RstDisable 1'b0
`define ZeroWord 32'h00000000
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define AluOpBus 7:0    //
`define AluSelBus 2:0   //
`define InstValid 1'b0
`define InstInvalid 1'b1
`define True_v 1'b1
`define False_v 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0


//指令
`define EXE_ORI  3'b110   //I
`define EXE_AND_REMU  3'b111		//R		
`define EXE_OR_REM   3'b110		//R		
`define EXE_XOR_DIV 3'b100		//R		
`define EXE_ANDI 3'b111   //I
`define EXE_XORI 3'b100   //I
`define EXE_LUI 7'b0110111

`define EXE_SLL_MULB  3'b001		//R		
`define EXE_SLLI  3'b001   //I
`define EXE_SRL_SRA_DIVU  3'b101		//R		
`define EXE_SRLI_SRAI  3'b101   //I	

`define EXE_R_INST 7'b0110011
`define EXE_I_INST 7'b0010011

`define EXE_NOP 7'b0000000


//AluOp
`define EXE_AND_OP   8'b00100100
`define EXE_OR_OP    8'b00100101
`define EXE_XOR_OP  8'b00100110
`define EXE_ANDI_OP  8'b01011001
`define EXE_ORI_OP  8'b01011010
`define EXE_XORI_OP  8'b01011011
`define EXE_LUI_OP  8'b01011100   

`define EXE_SLL_OP  8'b01111100
`define EXE_SLLI_OP  8'b00000100
`define EXE_SRL_OP  8'b00000010
`define EXE_SRLI_OP  8'b00000110
`define EXE_SRA_OP  8'b00000011
`define EXE_SRAI_OP  8'b00000111

`define EXE_NOP_OP    8'b00000000

//AluSel
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_SHIFT 3'b010

`define EXE_RES_NOP 3'b000


//指令存储器inst_rom
`define InstAddrBus 31:0
`define InstBus 31:0
`define InstMemNum 131071
`define InstMemNumLog2 17


//通用寄存器regfile
`define RegAddrBus 4:0
`define RegBus 31:0
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b00000
