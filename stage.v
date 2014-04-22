/*
*	Pipeline stages
*
*	five stages include : 
*	IF/ID:		IFID
*	ID/EXE:		IDEXE
*	EXE/MEM:	EXEMEM
*	MEM/WB:		MEMWB	
*
*
*
*	Chris Cheng
*	2014-4-22
*
***/
`include "cpu_para.v"

//IF/ID stage
module IFID(
	input  clk,
    input  rst,
    input  IF_Flush,		//IF flush signal
    input  IF_Stall,		//IF stall signal 
    input  ID_Stall,		//ID stall signal
    // Control Signals
    input  [`DP_WIDTH - 1:0] IF_Instruction,	//Instruction from IF
    // Data Signals
    input  [`DP_WIDTH - 1:0] IF_PCAdd4,			//PC+4 from IF
    input  [`DP_WIDTH - 1:0] IF_PC,				//PC from IF
    input  IF_IsBDS,			
    // ------------------
    output reg [31:0] ID_Instruction,			//output Instruction
    output reg [31:0] ID_PCAdd4,				//output PC+4
    output reg [31:0] ID_RestartPC,				//
    output reg ID_IsBDS,
    output reg ID_IsFlushed
    );

	always @(posedge clk) begin
        ID_Instruction <= (rst) ? 32'b0 : ((ID_Stall) ? ID_Instruction : ((IF_Stall | IF_Flush) ? 32'b0 : IF_Instruction));
        ID_PCAdd4      <= (rst) ? 32'b0 : ((ID_Stall) ? ID_PCAdd4                                       : IF_PCAdd4);
        ID_IsBDS       <= (rst) ? 0     : ((ID_Stall) ? ID_IsBDS                                        : IF_IsBDS);
        ID_RestartPC   <= (rst) ? 32'b0 : ((ID_Stall | IF_IsBDS) ? ID_RestartPC                         : IF_PC);
        ID_IsFlushed   <= (rst) ? 0     : ((ID_Stall) ? ID_IsFlushed                                    : IF_Flush);
    end

endmodule


//ID/EXE stage
module IDEXE(
	input  clk,
    input  rst,
    input  ID_Flush,
    input  ID_Stall,
    input  EX_Stall,
    // Control Signals
    input  ID_Link,
    input  ID_RegDst,
    input  ID_ALUSrcImm,
    input  [`ALUOP_WIDTH - 1:0] ID_ALUOp,
    //input  ID_Movn,
    //input  ID_Movz,
    input  ID_LLSC,
    input  ID_MemRead,
    input  ID_MemWrite,
    input  ID_MemByte,
    input  ID_MemHalf,
    input  ID_MemSignExtend,
    input  ID_Left,
    input  ID_Right,
    input  ID_RegWrite,
    input  ID_MemtoReg,
    input  ID_ReverseEndian,
    // Hazard & Forwarding
    input  [`REG_WIDTH - 1:0] ID_Rs,
    input  [`REG_WIDTH - 1:0] ID_Rt,
    input  ID_WantRsByEX,
    input  ID_NeedRsByEX,
    input  ID_WantRtByEX,
    input  ID_NeedRtByEX,
    // Exception Control/Info
    /*
    input  ID_KernelMode,
    input  [31:0] ID_RestartPC,
    input  ID_IsBDS,
    input  ID_Trap,
    input  ID_TrapCond,
    input  ID_EX_CanErr,
    input  ID_M_CanErr,
    */
    // Data Signals
    input  [`DP_WIDTH - 1:0] ID_ReadData1,
    input  [`DP_WIDTH - 1:0] ID_ReadData2,
    input  [`HALF_DP_WIDTH - 1:0] ID_SignExtImm, // ID_Rd, ID_Shamt included here
    // ----------------
    output reg EX_Link,
    output [1:0] EX_LinkRegDst,
    output reg EX_ALUSrcImm,
    output reg [`ALUOP_WIDTH - 1:0] EX_ALUOp,
    output reg EX_Movn,
    output reg EX_Movz,
    output reg EX_LLSC,
    output reg EX_MemRead,
    output reg EX_MemWrite,
    output reg EX_MemByte,
    output reg EX_MemHalf,
    output reg EX_MemSignExtend,
    output reg EX_Left,
    output reg EX_Right,
    output reg EX_RegWrite,
    output reg EX_MemtoReg,
    output reg EX_ReverseEndian,
    output reg [`REG_WIDTH - 1:0]  EX_Rs,
    output reg [`REG_WIDTH - 1:0]  EX_Rt,
    output reg EX_WantRsByEX,
    output reg EX_NeedRsByEX,
    output reg EX_WantRtByEX,
    output reg EX_NeedRtByEX,
    output reg EX_KernelMode,
    output reg [`DP_WIDTH - 1:0] EX_RestartPC,
    output reg EX_IsBDS,
    output reg EX_Trap,
    output reg EX_TrapCond,
    output reg EX_EX_CanErr,
    output reg EX_M_CanErr,
    output reg [`DP_WIDTH - 1:0] EX_ReadData1,
    output reg [`DP_WIDTH - 1:0] EX_ReadData2,
    output [`HALF_DP_WIDTH - 1:0] EX_SignExtImm,
    output [`REG_WIDTH - 1:0]      EX_Rd,
    output [`REG_WIDTH - 1:0]      EX_Shamt
    );


    
    reg [16:0] EX_SignExtImm_pre;
    reg EX_RegDst;
    assign EX_LinkRegDst = (EX_Link) ? 2'b10 : ((EX_RegDst) ? 2'b01 : 2'b00);   
    assign EX_Rd = EX_SignExtImm[15:11];
    assign EX_Shamt = EX_SignExtImm[10:6];
    assign EX_SignExtImm = (EX_SignExtImm_pre[16]) ? {15'h7fff, EX_SignExtImm_pre[16:0]} : {15'h0000, EX_SignExtImm_pre[16:0]};
    
    always @(posedge clk) begin
        EX_Link           <= (rst) ? 0     : ((EX_Stall) ? EX_Link                                       : ID_Link);
        EX_RegDst         <= (rst) ? 0     : ((EX_Stall) ? EX_RegDst                                     : ID_RegDst);
        EX_ALUSrcImm      <= (rst) ? 0     : ((EX_Stall) ? EX_ALUSrcImm                                  : ID_ALUSrcImm);
        EX_ALUOp          <= (rst) ? 5'b0  : ((EX_Stall) ? EX_ALUOp         : ((ID_Stall | ID_Flush) ? 5'b0 : ID_ALUOp));
        EX_Movn           <= (rst) ? 0     : ((EX_Stall) ? EX_Movn                                       : ID_Movn);
        EX_Movz           <= (rst) ? 0     : ((EX_Stall) ? EX_Movz                                       : ID_Movz);
        EX_LLSC           <= (rst) ? 0     : ((EX_Stall) ? EX_LLSC                                       : ID_LLSC);
        EX_MemRead        <= (rst) ? 0     : ((EX_Stall) ? EX_MemRead       : ((ID_Stall | ID_Flush) ? 0 : ID_MemRead));
        EX_MemWrite       <= (rst) ? 0     : ((EX_Stall) ? EX_MemWrite      : ((ID_Stall | ID_Flush) ? 0 : ID_MemWrite));
        EX_MemByte        <= (rst) ? 0     : ((EX_Stall) ? EX_MemByte                                    : ID_MemByte);
        EX_MemHalf        <= (rst) ? 0     : ((EX_Stall) ? EX_MemHalf                                    : ID_MemHalf);
        EX_MemSignExtend  <= (rst) ? 0     : ((EX_Stall) ? EX_MemSignExtend                              : ID_MemSignExtend);
        EX_Left           <= (rst) ? 0     : ((EX_Stall) ? EX_Left                                       : ID_Left);
        EX_Right          <= (rst) ? 0     : ((EX_Stall) ? EX_Right                                      : ID_Right);
        EX_RegWrite       <= (rst) ? 0     : ((EX_Stall) ? EX_RegWrite      : ((ID_Stall | ID_Flush) ? 0 : ID_RegWrite));
        EX_MemtoReg       <= (rst) ? 0     : ((EX_Stall) ? EX_MemtoReg                                   : ID_MemtoReg);
        EX_ReverseEndian  <= (rst) ? 0     : ((EX_Stall) ? EX_ReverseEndian                              : ID_ReverseEndian);
        EX_RestartPC      <= (rst) ? 32'b0 : ((EX_Stall) ? EX_RestartPC                                  : ID_RestartPC);
        EX_IsBDS          <= (rst) ? 0     : ((EX_Stall) ? EX_IsBDS                                      : ID_IsBDS);
        EX_Trap           <= (rst) ? 0     : ((EX_Stall) ? EX_Trap          : ((ID_Stall | ID_Flush) ? 0 : ID_Trap));
        EX_TrapCond       <= (rst) ? 0     : ((EX_Stall) ? EX_TrapCond                                   : ID_TrapCond);
        EX_EX_CanErr      <= (rst) ? 0     : ((EX_Stall) ? EX_EX_CanErr     : ((ID_Stall | ID_Flush) ? 0 : ID_EX_CanErr));
        EX_M_CanErr       <= (rst) ? 0     : ((EX_Stall) ? EX_M_CanErr      : ((ID_Stall | ID_Flush) ? 0 : ID_M_CanErr));
        EX_ReadData1      <= (rst) ? 32'b0 : ((EX_Stall) ? EX_ReadData1                                  : ID_ReadData1);
        EX_ReadData2      <= (rst) ? 32'b0 : ((EX_Stall) ? EX_ReadData2                                  : ID_ReadData2);
        EX_SignExtImm_pre <= (rst) ? 17'b0 : ((EX_Stall) ? EX_SignExtImm_pre                             : ID_SignExtImm);
        EX_Rs             <= (rst) ? 5'b0  : ((EX_Stall) ? EX_Rs                                         : ID_Rs);
        EX_Rt             <= (rst) ? 5'b0  : ((EX_Stall) ? EX_Rt                                         : ID_Rt);
        EX_WantRsByEX     <= (rst) ? 0     : ((EX_Stall) ? EX_WantRsByEX    : ((ID_Stall | ID_Flush) ? 0 : ID_WantRsByEX));
        EX_NeedRsByEX     <= (rst) ? 0     : ((EX_Stall) ? EX_NeedRsByEX    : ((ID_Stall | ID_Flush) ? 0 : ID_NeedRsByEX));
        EX_WantRtByEX     <= (rst) ? 0     : ((EX_Stall) ? EX_WantRtByEX    : ((ID_Stall | ID_Flush) ? 0 : ID_WantRtByEX));
        EX_NeedRtByEX     <= (rst) ? 0     : ((EX_Stall) ? EX_NeedRtByEX    : ((ID_Stall | ID_Flush) ? 0 : ID_NeedRtByEX));
        EX_KernelMode     <= (rst) ? 0     : ((EX_Stall) ? EX_KernelMode                                 : ID_KernelMode);
    end

endmodule

//EXE/MEM stage
module EXEMEM(
    input  clk,
    input  rst,
    input  EX_Flush,
    input  EX_Stall,
    input  M_Stall,
    // Control Signals
    input  EX_Movn,
    input  EX_Movz,
    input  EX_BZero,
    input  EX_RegWrite,  // Future Control to WB
    input  EX_MemtoReg,  // Future Control to WB
    input  EX_ReverseEndian,
    input  EX_LLSC,
    input  EX_MemRead,
    input  EX_MemWrite,
    input  EX_MemByte,
    input  EX_MemHalf,
    input  EX_MemSignExtend,
    input  EX_Left,
    input  EX_Right,
    // Exception Control/Info	
    input  EX_KernelMode,
    input  [31:0] EX_RestartPC,
    input  EX_IsBDS,
    input  EX_Trap,
    input  EX_TrapCond,
    input  EX_M_CanErr,
    // Data Signals
    input  [31:0] EX_ALU_Result,
    input  [31:0] EX_ReadData2,
    input  [4:0]  EX_RtRd,
    // ------------------
    output reg M_RegWrite,
    output reg M_MemtoReg,
    output reg M_ReverseEndian,
    output reg M_LLSC,
    output reg M_MemRead,
    output reg M_MemWrite,
    output reg M_MemByte,
    output reg M_MemHalf,
    output reg M_MemSignExtend,
    output reg M_Left,
    output reg M_Right,
    output reg M_KernelMode,
    output reg [31:0] M_RestartPC,
    output reg M_IsBDS,
    output reg M_Trap,
    output reg M_TrapCond,
    output reg M_M_CanErr,
    output reg [31:0] M_ALU_Result,
    output reg [31:0] M_ReadData2,
    output reg [4:0]  M_RtRd
    );


  
    // Mask of RegWrite if a Move Conditional failed.
    wire MovcRegWrite = (EX_Movn & ~EX_BZero) | (EX_Movz & EX_BZero);
    
    always @(posedge clk) begin
        M_RegWrite      <= (rst) ? 0     : ((M_Stall) ? M_RegWrite      : ((EX_Stall | EX_Flush) ? 0 : EX_RegWrite));
        M_RegWrite      <= (rst) ? 0     : ((M_Stall) ? M_RegWrite      : ((EX_Stall | EX_Flush) ? 0 : ((EX_Movn | EX_Movz) ? MovcRegWrite : EX_RegWrite)));
        M_MemtoReg      <= (rst) ? 0     : ((M_Stall) ? M_MemtoReg                                   : EX_MemtoReg);
        M_ReverseEndian <= (rst) ? 0     : ((M_Stall) ? M_ReverseEndian                              : EX_ReverseEndian);
        M_LLSC          <= (rst) ? 0     : ((M_Stall) ? M_LLSC                                       : EX_LLSC);
        M_MemRead       <= (rst) ? 0     : ((M_Stall) ? M_MemRead       : ((EX_Stall | EX_Flush) ? 0 : EX_MemRead));
        M_MemWrite      <= (rst) ? 0     : ((M_Stall) ? M_MemWrite      : ((EX_Stall | EX_Flush) ? 0 : EX_MemWrite));
        M_MemByte       <= (rst) ? 0     : ((M_Stall) ? M_MemByte                                    : EX_MemByte);
        M_MemHalf       <= (rst) ? 0     : ((M_Stall) ? M_MemHalf                                    : EX_MemHalf);
        M_MemSignExtend <= (rst) ? 0     : ((M_Stall) ? M_MemSignExtend                              : EX_MemSignExtend);
        M_Left          <= (rst) ? 0     : ((M_Stall) ? M_Left                                       : EX_Left);
        M_Right         <= (rst) ? 0     : ((M_Stall) ? M_Right                                      : EX_Right);
        M_KernelMode    <= (rst) ? 0     : ((M_Stall) ? M_KernelMode                                 : EX_KernelMode);
        M_RestartPC     <= (rst) ? 32'b0 : ((M_Stall) ? M_RestartPC                                  : EX_RestartPC);
        M_IsBDS         <= (rst) ? 0     : ((M_Stall) ? M_IsBDS                                      : EX_IsBDS);
        M_Trap          <= (rst) ? 0     : ((M_Stall) ? M_Trap          : ((EX_Stall | EX_Flush) ? 0 : EX_Trap));
        M_TrapCond      <= (rst) ? 0     : ((M_Stall) ? M_TrapCond                                   : EX_TrapCond);
        M_M_CanErr      <= (rst) ? 0     : ((M_Stall) ? M_M_CanErr      : ((EX_Stall | EX_Flush) ? 0 : EX_M_CanErr));
        M_ALU_Result    <= (rst) ? 32'b0 : ((M_Stall) ? M_ALU_Result                                 : EX_ALU_Result);
        M_ReadData2     <= (rst) ? 32'b0 : ((M_Stall) ? M_ReadData2                                  : EX_ReadData2);
        M_RtRd          <= (rst) ? 5'b0  : ((M_Stall) ? M_RtRd                                       : EX_RtRd);
    end

endmodule

//MEM/WB stage
module MEMWB(
    input  clock,
    input  reset,
    input  M_Flush,
    input  M_Stall,
    input  WB_Stall,
    // Control Signals
    input  M_RegWrite,
    input  M_MemtoReg,
    // Data Signals
    input  [31:0] M_ReadData,
    input  [31:0] M_ALU_Result,
    input  [4:0]  M_RtRd,
    // ----------------
    output reg WB_RegWrite,
    output reg WB_MemtoReg,
    output reg [31:0] WB_ReadData,
    output reg [31:0] WB_ALU_Result,
    output reg [4:0]  WB_RtRd
    );
    
    
    always @(posedge clock) begin
        WB_RegWrite   <= (reset) ? 0     : ((WB_Stall) ? WB_RegWrite   : ((M_Stall | M_Flush) ? 0 : M_RegWrite));
        WB_MemtoReg   <= (reset) ? 0     : ((WB_Stall) ? WB_MemtoReg                              : M_MemtoReg);
        WB_ReadData   <= (reset) ? 32'b0 : ((WB_Stall) ? WB_ReadData                              : M_ReadData);
        WB_ALU_Result <= (reset) ? 32'b0 : ((WB_Stall) ? WB_ALU_Result                            : M_ALU_Result);
        WB_RtRd       <= (reset) ? 5'b0  : ((WB_Stall) ? WB_RtRd                                  : M_RtRd);
    end

endmodule