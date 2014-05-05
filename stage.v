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
module IFID_Stage(
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
module IDEXE_Stage(
	input  clk,
    input  rst,
    input  ID_Flush,
    input  ID_Stall,
    input  EX_Stall,
    // Control Signals
    input  ID_Link,
    input  ID_RegDest,
    input  ID_ALUSrcSel,
    input  [`ALUOP_WIDTH - 1:0] ID_ALUOp,
    
    input  ID_MemRead,
    input  ID_MemWrite,
    input  ID_MemByte,
    input  ID_MemHalf,
    input  ID_MemSignExt,
    
    input  ID_RegWrite,
    input  ID_MemtoReg,
    
    // Hazard & Forwarding
    input  [`REG_WIDTH - 1:0] ID_Rs,
    input  [`REG_WIDTH - 1:0] ID_Rt,
    input  ID_WantRsByEX,
    input  ID_NeedRsByEX,
    input  ID_WantRtByEX,
    input  ID_NeedRtByEX,
    input  ID_RestartPC,
    input  ID_IsBDS,
    // Data Signals
    input  [`DP_WIDTH - 1:0] ID_ReadData1,
    input  [`DP_WIDTH - 1:0] ID_ReadData2,
    input  [`HALF_DP_WIDTH - 1:0] ID_SignExtImm, // ID_Rd, ID_Shamt included here
    // ----------------
    output reg EX_Link,
    output [1:0] EX_LinkRegDest,
    output reg EX_ALUSrcSel,
    output reg [`ALUOP_WIDTH - 1:0] EX_ALUOp,
    
    output reg EX_MemRead,
    output reg EX_MemWrite,
    output reg EX_MemByte,
    output reg EX_MemHalf,
    output reg EX_MemSignExt,
    
    output reg EX_RegWrite,
    output reg EX_MemtoReg,
    
    output reg [`REG_WIDTH - 1:0]  EX_Rs,
    output reg [`REG_WIDTH - 1:0]  EX_Rt,
    output reg EX_WantRsByEX,
    output reg EX_NeedRsByEX,
    output reg EX_WantRtByEX,
    output reg EX_NeedRtByEX,
    output reg EX_KernelMode,
    output reg [`DP_WIDTH - 1:0] EX_RestartPC,
    output reg EX_IsBDS,
    
    output reg [`DP_WIDTH - 1:0] EX_ReadData1,
    output reg [`DP_WIDTH - 1:0] EX_ReadData2,
    output [`HALF_DP_WIDTH - 1:0] EX_SignExtImm,
    output [`REG_WIDTH - 1:0]      EX_Rd,
    output [`REG_WIDTH - 1:0]      EX_Shamt
    );


    
    reg [16:0] EX_SignExtImMEM_pre;
    reg EX_RegDest;
    assign EX_LinkRegDest = (EX_Link) ? 2'b10 : ((EX_RegDest) ? 2'b01 : 2'b00);   
    assign EX_Rd = EX_SignExtImm[15:11];
    assign EX_Shamt = EX_SignExtImm[10:6];
    assign EX_SignExtImm = (EX_SignExtImMEM_pre[16]) ? {15'h7fff, EX_SignExtImMEM_pre[16:0]} : {15'h0000, EX_SignExtImMEM_pre[16:0]};
    
    always @(posedge clk) 
    begin
        EX_Link           <= (rst) ? 0     : ((EX_Stall) ? EX_Link                                       : ID_Link);
        EX_RegDest         <= (rst) ? 0     : ((EX_Stall) ? EX_RegDest                                     : ID_RegDest);
        EX_ALUSrcSel      <= (rst) ? 0     : ((EX_Stall) ? EX_ALUSrcSel                                  : ID_ALUSrcSel);
        EX_ALUOp          <= (rst) ? 5'b0  : ((EX_Stall) ? EX_ALUOp         : ((ID_Stall | ID_Flush) ? 5'b0 : ID_ALUOp));
        EX_MemRead        <= (rst) ? 0     : ((EX_Stall) ? EX_MemRead       : ((ID_Stall | ID_Flush) ? 0 : ID_MemRead));
        EX_MemWrite       <= (rst) ? 0     : ((EX_Stall) ? EX_MemWrite      : ((ID_Stall | ID_Flush) ? 0 : ID_MemWrite));
        EX_MemByte        <= (rst) ? 0     : ((EX_Stall) ? EX_MemByte                                    : ID_MemByte);
        EX_MemHalf        <= (rst) ? 0     : ((EX_Stall) ? EX_MemHalf                                    : ID_MemHalf);
        EX_MemSignExt     <= (rst) ? 0     : ((EX_Stall) ? EX_MemSignExt                                 : ID_MemSignExt);
        EX_RegWrite       <= (rst) ? 0     : ((EX_Stall) ? EX_RegWrite      : ((ID_Stall | ID_Flush) ? 0 : ID_RegWrite));
        EX_MemtoReg       <= (rst) ? 0     : ((EX_Stall) ? EX_MemtoReg                                   : ID_MemtoReg);
        EX_RestartPC      <= (rst) ? 32'b0 : ((EX_Stall) ? EX_RestartPC                                  : ID_RestartPC);
        EX_IsBDS          <= (rst) ? 0     : ((EX_Stall) ? EX_IsBDS                                      : ID_IsBDS);
        EX_ReadData1      <= (rst) ? 32'b0 : ((EX_Stall) ? EX_ReadData1                                  : ID_ReadData1);
        EX_ReadData2      <= (rst) ? 32'b0 : ((EX_Stall) ? EX_ReadData2                                  : ID_ReadData2);
        EX_SignExtImMEM_pre <= (rst) ? 17'b0 : ((EX_Stall) ? EX_SignExtImMEM_pre                             : ID_SignExtImm);
        EX_Rs             <= (rst) ? 5'b0  : ((EX_Stall) ? EX_Rs                                         : ID_Rs);
        EX_Rt             <= (rst) ? 5'b0  : ((EX_Stall) ? EX_Rt                                         : ID_Rt);
        EX_WantRsByEX     <= (rst) ? 0     : ((EX_Stall) ? EX_WantRsByEX    : ((ID_Stall | ID_Flush) ? 0 : ID_WantRsByEX));
        EX_NeedRsByEX     <= (rst) ? 0     : ((EX_Stall) ? EX_NeedRsByEX    : ((ID_Stall | ID_Flush) ? 0 : ID_NeedRsByEX));
        EX_WantRtByEX     <= (rst) ? 0     : ((EX_Stall) ? EX_WantRtByEX    : ((ID_Stall | ID_Flush) ? 0 : ID_WantRtByEX));
        EX_NeedRtByEX     <= (rst) ? 0     : ((EX_Stall) ? EX_NeedRtByEX    : ((ID_Stall | ID_Flush) ? 0 : ID_NeedRtByEX));
    end

endmodule

//EXE/MEM stage
module EXEMEM_Stage(
    input  clk,
    input  rst,
    input  EX_Flush,
    input  EX_Stall,
    input  MEM_Stall,
    // Control Signals
    input  EX_BZero,
    input  EX_RegWrite,  // Future Control to WB
    input  EX_MemtoReg,  // Future Control to WB
    input  EX_MemRead,
    input  EX_MemWrite,
    input  EX_MemByte,
    input  EX_MemHalf,
    input  EX_MemSignExt,
    input  [31:0] EX_RestartPC,
    input  EX_IsBDS,
    // Data Signals
    input  [31:0] EX_ALU_Result,
    input  [31:0] EX_ReadData2,
    input  [4:0]  EX_RtRd,

    // ------------------
    output reg MEM_RegWrite,
    output reg MEM_MemtoReg,
    output reg MEM_MemRead,
    output reg MEM_MemWrite,
    output reg MEM_MemByte,
    output reg MEM_MemHalf,
    output reg MEM_MemSignExt,
    output reg [31:0] MEM_RestartPC,
    output reg MEM_IsBDS,
    output reg [31:0] MEM_ALU_Result,
    output reg [31:0] MEM_ReadData2,
    output reg [4:0]  MEM_RtRd
    );


  
    
    
    always @(posedge clk) begin
        MEM_RegWrite      <= (rst) ? 0     : ((MEM_Stall) ? MEM_RegWrite      : ((EX_Stall | EX_Flush) ? 0 : EX_RegWrite));
        MEM_RegWrite      <= (rst) ? 0     : ((MEM_Stall) ? MEM_RegWrite      : ((EX_Stall | EX_Flush) ? 0 : EX_RegWrite));
        MEM_MemtoReg      <= (rst) ? 0     : ((MEM_Stall) ? MEM_MemtoReg                                   : EX_MemtoReg);
        MEM_MemRead       <= (rst) ? 0     : ((MEM_Stall) ? MEM_MemRead       : ((EX_Stall | EX_Flush) ? 0 : EX_MemRead));
        MEM_MemWrite      <= (rst) ? 0     : ((MEM_Stall) ? MEM_MemWrite      : ((EX_Stall | EX_Flush) ? 0 : EX_MemWrite));
        MEM_MemByte       <= (rst) ? 0     : ((MEM_Stall) ? MEM_MemByte                                    : EX_MemByte);
        MEM_MemHalf       <= (rst) ? 0     : ((MEM_Stall) ? MEM_MemHalf                                    : EX_MemHalf);
        MEM_MemSignExt    <= (rst) ? 0     : ((MEM_Stall) ? MEM_MemSignExt                                 : EX_MemSignExt);
        MEM_RestartPC     <= (rst) ? 32'b0 : ((MEM_Stall) ? MEM_RestartPC                                  : EX_RestartPC);
        MEM_IsBDS         <= (rst) ? 0     : ((MEM_Stall) ? MEM_IsBDS                                      : EX_IsBDS);
        MEM_ALU_Result    <= (rst) ? 32'b0 : ((MEM_Stall) ? MEM_ALU_Result                                 : EX_ALU_Result);
        MEM_ReadData2     <= (rst) ? 32'b0 : ((MEM_Stall) ? MEM_ReadData2                                  : EX_ReadData2);
        MEM_RtRd          <= (rst) ? 5'b0  : ((MEM_Stall) ? MEM_RtRd                                       : EX_RtRd);
    end

endmodule

//MEM/WB stage
module MEMWB_Stage(
    input  clk,
    input  rst,
    input  MEM_Flush,
    input  MEM_Stall,
    input  WB_Stall,
    // Control Signals
    input  MEM_RegWrite,
    input  MEM_MemtoReg,
    // Data Signals
    input  [31:0] MEM_ReadData,
    input  [31:0] MEM_ALU_Result,
    input  [4:0]  MEM_RtRd,
    // ----------------
    output reg WB_RegWrite,
    output reg WB_MemtoReg,
    output reg [31:0] WB_ReadData,
    output reg [31:0] WB_ALU_Result,
    output reg [4:0]  WB_RtRd
    );
    
    
    always @(posedge clk) begin
        WB_RegWrite   <= (rst) ? 0     : ((WB_Stall) ? WB_RegWrite   : ((MEM_Stall | MEM_Flush) ? 0 : MEM_RegWrite));
        WB_MemtoReg   <= (rst) ? 0     : ((WB_Stall) ? WB_MemtoReg                              : MEM_MemtoReg);
        WB_ReadData   <= (rst) ? 32'b0 : ((WB_Stall) ? WB_ReadData                              : MEM_ReadData);
        WB_ALU_Result <= (rst) ? 32'b0 : ((WB_Stall) ? WB_ALU_Result                            : MEM_ALU_Result);
        WB_RtRd       <= (rst) ? 5'b0  : ((WB_Stall) ? WB_RtRd                                  : MEM_RtRd);
    end

endmodule