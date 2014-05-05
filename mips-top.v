/*
*	MIPS CPU top module
*
*	
*
*
*	Chris Cheng
*	2014-4-22
*
***/

`ifndef MIPS_PARA

`include "cpu_para.v"

`endif

module Processor(
	input  clk,
    input  rst,

    // Instruction Memory Interface
    input  [`DP_WIDTH - 1:0] InstMem_In,
    output [`ADDR_WIDTH - 1:0] InstMem_Address,      // Addresses are words, not bytes. 30 bits, require external shifter,
    input  InstMem_Ready,
    output InstMem_Read,
    
    // Data Memory Interface
    input  [`DP_WIDTH - 1:0] DataMem_In,
    input  DataMem_Ready,
    output DataMem_Read, 
    output [3:0]  DataMem_Write,        // 4-bit Write, one for each byte in word.
    output [`ADDR_WIDTH - 1:0] DataMem_Address,      // Addresses are words, not bytes. 30 bits, require external shifter
    output [`DP_WIDTH - 1:0] DataMem_Out
    //output [7:0] IP                     // Pending interrupts (diagnostic)
    );
	
	`include "cpu_para.v"
	
	/*** MIPS Instruction and Components (ID Stage) ***/
    wire [`DP_WIDTH - 1:0] Instruction;
    wire [`OPCODE_WIDTH - 1:0]  OpCode = Instruction[31:26];
    wire [`REG_WIDTH - 1:0]  Rs = Instruction[25:21];
    wire [`REG_WIDTH - 1:0]  Rt = Instruction[20:16];
    wire [`REG_WIDTH - 1:0]  Rd = Instruction[15:11];
    wire [`FUNCCODE_WIDTH - 1:0]  Func = Instruction[5:0];
    wire [`HALF_DP_WIDTH - 1:0] Immediate = Instruction[15:0];
    wire [`JUMPADDR_WIDTH - 1:0] JumpAddress = Instruction[25:0];
    //wire [2:0]  Cp0_Sel = Instruction[2:0];

    /*** IF (Instruction Fetch) Signals ***/
    wire IF_Stall, IF_Flush;
    /*
    wire IF_EXC_AdIF;
    wire IF_Exception_Stall;
    wire IF_Exception_Flush;
    */
    wire IF_IsBDS;  //Next is branch delay slot
    wire [31:0] IF_PCAdd4, IF_PC_PreExc, IF_PCIn, IF_PCOut, IF_Instruction;

    /*** ID (Instruction Decode) Signals ***/
    wire ID_Stall;
    wire [1:0] ID_PCSrc;
    wire [1:0] ID_RsFwdSel, ID_RtFwdSel;
    wire ID_Link, ID_Movn, ID_Movz;
    wire ID_SignExtend;
    wire ID_LLSC;
    wire ID_RegDst, ID_ALUSrcSel, ID_MemWrite, ID_MemRead, ID_MemByte, ID_MemHalf, ID_MemSignExtend, ID_RegWrite, ID_MemtoReg;
    wire [4:0] ID_ALUOp;
    wire ID_Mfc0, ID_Mtc0, ID_Eret;
    wire ID_NextIsDelay;
    wire ID_CanErr, ID_ID_CanErr, ID_EX_CanErr, ID_MEM_CanErr;
    wire ID_KernelMode;
    wire ID_ReverseEndian;
    wire ID_Trap, ID_TrapCond;
    wire ID_EXC_Sys, ID_EXC_Bp, ID_EXC_RI;
    wire ID_Exception_Stall;
    wire ID_Exception_Flush;
    wire ID_PCSrc_Exc;
    wire [31:0] ID_ExceptionPC;
    wire ID_CP1, ID_CP2, ID_CP3;
    wire [31:0] ID_PCAdd4;
    wire [31:0] ID_ReadData1_RF, ID_ReadData1_End;
    wire [31:0] ID_ReadData2_RF, ID_ReadData2_End;
    wire [31:0] CP0_RegOut;
    wire ID_CompEQ, ID_CmpGZ, ID_CmpLZ, ID_CmpGEZ, ID_CmpLEZ;
    wire [29:0] ID_SignExtImm = (ID_SignExtend & Immediate[15]) ? {14'h3FFF, Immediate} : {14'h0000, Immediate};
    wire [31:0] ID_ImmLeftShift2 = {ID_SignExtImm[29:0], 2'b00};
    wire [31:0] ID_JumpAddress = {ID_PCAdd4[31:28], JumpAddress[25:0], 2'b00};
    wire [31:0] ID_BranchAddress;
    wire [31:0] ID_RestartPC;
    wire ID_IsBDS;
    wire ID_Left, ID_Right;
    wire ID_IsFlushed;

    /*** EX (Execute) Signals ***/
    wire EX_ALU_Stall, EX_Stall;
    wire [1:0] EX_RsFwdSel, EX_RtFwdSel;
    wire EX_Link;
    wire [1:0] EX_LinkRegDst;
    wire EX_ALUSrcSel;
    wire [4:0] EX_ALUOp;
    wire EX_Movn, EX_Movz;
    wire EX_LLSC;
    wire EX_MemRead, EX_MemWrite, EX_MemByte, EX_MemHalf, EX_MemSignExtend, EX_RegWrite, EX_MemtoReg;
    wire [4:0] EX_Rs, EX_Rt;
    wire EX_WantRsByEX, EX_NeedRsByEX, EX_WantRtByEX, EX_NeedRtByEX;
    wire EX_Trap, EX_TrapCond;
    wire EX_CanErr, EX_EX_CanErr, EX_MEM_CanErr;
    wire EX_KernelMode;
    wire EX_ReverseEndian;
    wire EX_Exception_Stall;
    wire EX_Exception_Flush;
    wire [31:0] EX_ReadData1_PR, EX_ReadData1_Fwd, EX_ReadData2_PR, EX_ReadData2_Fwd, EX_ReadData2_Imm;
    wire [31:0] EX_SignExtImm;
    wire [4:0] EX_Rd, EX_RtRd, EX_Shamt;
    wire [31:0] EX_ALUResult;
    wire EX_BZero;
    wire EX_EXC_Ov;
    wire [31:0] EX_RestartPC;
    wire EX_IsBDS;
    wire EX_Left, EX_Right;

    /*** MEM (Memory) Signals ***/
    wire MEM_Stall, MEM_Stall_Controller;
    wire MEM_LLSC;
    wire MEM_MemRead, MEM_MemWrite, MEM_MemByte, MEM_MemHalf, MEM_MemSignExtend;
    wire MEM_RegWrite, MEM_MemtoReg;
    wire MEM_WriteDataFwdSel;
    wire MEM_EXC_AdEL, MEM_EXC_AdES;
    wire MEM_MEM_CanErr;
    wire MEM_KernelMode;
    wire MEM_ReverseEndian;
    wire MEM_Trap, MEM_TrapCond;
    wire MEM_EXC_Tr;
    wire MEM_Exception_Flush;
    wire [31:0] MEM_ALUResult, MEM_ReadData2_PR;
    wire [4:0] MEM_RtRd;
    wire [31:0] MEM_MemReadData;
    wire [31:0] MEM_RestartPC;
    wire MEM_IsBDS;
    wire [31:0] MEM_WriteData_Pre;
    wire MEM_Left, MEM_Right;
    wire MEM_Exception_Stall;

    /*** WB (Writeback) Signals ***/
    wire WB_Stall, WB_RegWrite;
    wire [31:0] WB_ReadData, WB_ALUResult;
    wire [4:0]  WB_RtRd;
    wire [31:0] WB_WriteData;

    /*** Other Signals ***/
    wire [7:0] ID_DP_Hazards, HAZ_DP_Hazards;

    /*** Assignments ***/
    assign IF_Instruction = (IF_Stall) ? 32'h00000000 : InstMem_In;
    assign IF_IsBDS = ID_NextIsDelay;
    assign HAZ_DP_Hazards = {ID_DP_Hazards[7:4], EX_WantRsByEX, EX_NeedRsByEX, EX_WantRtByEX, EX_NeedRtByEX};
    assign IF_EXC_AdIF = IF_PCOut[1] | IF_PCOut[0];
    assign ID_CanErr = ID_ID_CanErr | ID_EX_CanErr | ID_MEM_CanErr;
    assign EX_CanErr = EX_EX_CanErr | EX_MEM_CanErr;
    assign MEM_CanErr  = MEM_MEM_CanErr;

    // External Memory Interface
    reg IRead, IReadMask;
    // InstrMem Addresss & DataMem Address
    assign InstMem_Address = IF_PCOut[31:2];
    assign DataMem_Address = MEM_ALUResult[31:2];

    // 
    always @(posedge clk)
    begin
        IRead <= (rst) ? 1 : ~InstMem_Ready;
        IReadMask <= (rst) ? 0 : ((IRead & InstMem_Ready) ? 1 : ((~IF_Stall) ? 0 : IReadMask));
    end
    assign InstMem_Read = IRead & ~IReadMask;


    /*** Datapath Controller ***/
    Control Controller (
        /***   input  *****/
        .ID_Stall       (ID_Stall),
        .OpCode         (OpCode),
        .Func           (Func),
        .Comp_EQ        (ID_CompEQ),

        /***   Output  *****/
        .IF_Flush       (IF_Flush),
        .DP_Hazards     (ID_DP_Hazards),
        .PCSrcSel       (ID_PCSrcSel),
        .SignExt        (ID_SignExt),
        .Link           (ID_Link),
        .NextIsDelay    (ID_NextIsDelay),
        .RegDest        (ID_RegDest),
        .ALUSrcSel      (ID_ALUSrcSel),
        .ALUOp          (ID_ALUOp),
        .MemWrite       (ID_MemWrite),
        .MemRead        (ID_MemRead),
        .MemByte        (ID_MemByte),
        .MemHalf        (ID_MemHalf),
        .MemSignExt     (ID_MemSignExt),
        .RegWrite       (ID_RegWrite),
        .MemtoReg       (ID_MemtoReg)
    );

    /*** Hazard and Forward Control Unit ***/
    Hazard_Detection HazardControl (
        /***   input  *****/
        .DP_Hazards          (HAZ_DP_Hazards),
        .ID_Rs               (Rs),
        .ID_Rt               (Rt),
        .EX_Rs               (EX_Rs),
        .EX_Rt               (EX_Rt),
        .EX_RtRd             (EX_RtRd),
        .MEM_RtRd            (MEM_RtRd),
        .WB_RtRd             (WB_RtRd),
        .EX_Link             (EX_Link),
        .EX_RegWrite         (EX_RegWrite),
        .MEM_RegWrite        (MEM_RegWrite),
        .WB_RegWrite         (WB_RegWrite),
        .MEM_MemRead         (MEM_MemRead),
        .MEM_MemWrite        (MEM_MemWrite),
        .InstMem_Read        (InstMem_Read),
        .InstMem_Ready       (InstMem_Ready),
        .EX_ALU_Stall        (EX_ALU_Stall),
        .MEM_Stall_Controller (MEM_Stall_Controller),

        /***   output  *****/
        .IF_Stall            (IF_Stall),
        .ID_Stall            (ID_Stall),
        .EX_Stall            (EX_Stall),
        .MEM_Stall           (MEM_Stall),
        .WB_Stall            (WB_Stall),
        .ID_RsFwdSel         (ID_RsFwdSel),
        .ID_RtFwdSel         (ID_RtFwdSel),
        .EX_RsFwdSel         (EX_RsFwdSel),
        .EX_RtFwdSel         (EX_RtFwdSel),
        .MEM_WriteDataFwdSel   (MEM_WriteDataFwdSel)
    );

    
    /*** PC Source Non-Exception Mux ***/
    MUX32_4_1  PCSrcStd_Mux (
        .sel  (ID_PCSrcSel),
        .in0  (IF_PCAdd4),
        .in1  (ID_JumpAddress),
        .in2  (ID_BranchAddress),
        .in3  (ID_ReadData1_End),
        .out  (IF_PCIn)
    );

    /*** Program Counter ***/
    Register PC (
        .clk   (clk),
        .rst   (rst),
        .RegWrite   (~(IF_Stall | ID_Stall)),
        .idat       (IF_PCIn),
        .odat       (IF_PCOut)
    );

    /*** PC +4 Adder ***/
    PCAdder PC_Add4 (
        .a  (IF_PCOut),
        .b  (32'h00000004),
        .res  (IF_PCAdd4)
    );

    /*** Instruction Fetch -> Instruction Decode Stage Register ***/
    IFID_Stage IFID (
        /***   Input  *****/
        .clk           (clk),
        .rst           (rst),
        .IF_Flush        (IF_Flush),
        .IF_Stall        (IF_Stall),
        .ID_Stall        (ID_Stall),
        .IF_Instruction  (IF_Instruction),
        .IF_PCAdd4       (IF_PCAdd4),
        .IF_PC           (IF_PCOut),
        .IF_IsBDS        (IF_IsBDS),

        /***   Output  *****/
        .ID_Instruction  (Instruction),
        .ID_PCAdd4       (ID_PCAdd4),
        // .ID_RestartPC (ID_PC),  => .ID_PC (ID_PC),
        .ID_RestartPC    (ID_RestartPC),
        .ID_IsBDS        (ID_IsBDS),
        .ID_IsFlushed    (ID_IsFlushed)
    );

    /*** Register File ***/
    RegFile RegisterFile (
        /***   Input  *****/
        .clk        (clk),
        .rst        (rst),
        .regA       (Rs),
        .regB       (Rt),
        .regW       (WB_RtRd),
        .Wdat       (WB_WriteData),
        .RegWrite   (WB_RegWrite),

        /***   Output  *****/
        .Adat       (ID_ReadData1_Front),
        .Bdat       (ID_ReadData2_Front)
    );

    /*** ID Rs Forwarding/Link Mux ***/
    MUX32_4_1  IDRsFwd_Mux (
        .sel  (ID_RsFwdSel),
        .in0  (ID_ReadData1_Front),
        .in1  (MEM_ALUResult),
        .in2  (WB_WriteData),
        .in3  (32'hxxxxxxxx),
        .out  (ID_ReadData1_End)
    );

    /*** ID Rt Forwarding/CP0 Mfc0 Mux ***/
    MUX32_4_1  IDRtFwd_Mux (
        .sel  (ID_RtFwdSel),
        .in0  (ID_ReadData2_Front),
        .in1  (MEM_ALUResult),
        .in2  (WB_WriteData),
        .in3  (32'hxxxxxxxx),
        .out  (ID_ReadData2_End)
    );

    /*** Condition Compare Unit ***/
    Compare32 Compare (
        .A    (ID_ReadData1_End),
        .B    (ID_ReadData2_End),
        .EQ   (ID_CompEQ)
    );

    /*** Branch Address Adder ***/
    PCAdder BranchAddress_Add (
        .a  (ID_PCAdd4),
        .b  (ID_ImmLeftShift2),
        .res  (ID_BranchAddress)
    );

    /*** Instruction Decode -> Execute Pipeline Stage ***/
    IDEXE_Stage IDEXE (
        .clk             (clk),
        .rst             (rst),
        //.ID_Flush          (ID_Exception_Flush),
        .ID_Stall          (ID_Stall),
        .EX_Stall          (EX_Stall),
        .ID_Link           (ID_Link),
        .ID_RegDest        (ID_RegDest),
        .ID_ALUSrcSel      (ID_ALUSrcSel),
        .ID_ALUOp          (ID_ALUOp),
        .ID_MemRead        (ID_MemRead),
        .ID_MemWrite       (ID_MemWrite),
        .ID_MemByte        (ID_MemByte),
        .ID_MemHalf        (ID_MemHalf),
        .ID_MemSignExt     (ID_MemSignExt),
        .ID_RegWrite       (ID_RegWrite),
        .ID_MemtoReg       (ID_MemtoReg),
        .ID_Rs             (Rs),
        .ID_Rt             (Rt),
        .ID_WantRsByEX     (ID_DP_Hazards[3]),
        .ID_NeedRsByEX     (ID_DP_Hazards[2]),
        .ID_WantRtByEX     (ID_DP_Hazards[1]),
        .ID_NeedRtByEX     (ID_DP_Hazards[0]),
        .ID_RestartPC      (ID_RestartPC),
        .ID_IsBDS          (ID_IsBDS),
        .ID_ReadData1      (ID_ReadData1_End),
        .ID_ReadData2      (ID_ReadData2_End),
        .ID_SignExtImm     (ID_SignExtImm[16:0]),
        //-----------------------------------------
        // Output
        .EX_Link           (EX_Link),
        .EX_LinkRegDest    (EX_LinkRegDest),
        .EX_ALUSrcSel      (EX_ALUSrcSel),
        .EX_ALUOp          (EX_ALUOp),
        .EX_MemRead        (EX_MemRead),
        .EX_MemWrite       (EX_MemWrite),
        .EX_MemByte        (EX_MemByte),
        .EX_MemHalf        (EX_MemHalf),
        .EX_MemSignExt     (EX_MemSignExt),
        .EX_RegWrite       (EX_RegWrite),
        .EX_MemtoReg       (EX_MemtoReg),
        .EX_Rs             (EX_Rs),
        .EX_Rt             (EX_Rt),
        .EX_WantRsByEX     (EX_WantRsByEX),
        .EX_NeedRsByEX     (EX_NeedRsByEX),
        .EX_WantRtByEX     (EX_WantRtByEX),
        .EX_NeedRtByEX     (EX_NeedRtByEX),
        .EX_RestartPC      (EX_RestartPC),
        .EX_IsBDS          (EX_IsBDS),
        .EX_ReadData1      (EX_ReadData1_Front),
        .EX_ReadData2      (EX_ReadData2_Front),
        .EX_SignExtImm     (EX_SignExtImm),
        .EX_Rd             (EX_Rd),
        .EX_Shamt          (EX_Shamt)
    );

    /*** EX Rs Forwarding Mux ***/
    MUX32_4_1  EXRsFwd_Mux (
        .sel  (EX_RsFwdSel),
        .in0  (EX_ReadData1_Front),
        .in1  (MEM_ALUResult),
        .in2  (WB_WriteData),
        .in3  (EX_RestartPC),
        .out  (EX_ReadData1_Fwd)
    );

    /*** EX Rt Forwarding / Link Mux ***/
    MUX32_4_1  EXRtFwdLnk_Mux (
        .sel  (EX_RtFwdSel),
        .in0  (EX_ReadData2_Front),
        .in1  (MEM_ALUResult),
        .in2  (WB_WriteData),
        .in3  (32'h00000008),
        .out  (EX_ReadData2_Fwd)
    );

    /*** EX ALU Immediate Mux ***/
    MUX32_2_1  EXALUImMEM_Mux (
        .sel  (EX_ALUSrcSel),
        .in0  (EX_ReadData2_Fwd),
        .in1  (EX_SignExtImm),
        .out  (EX_ReadData2_Imm)
    );

    /*** EX RtRd / Link Mux ***/
    MUX5_4_1 EXRtRdLnk_Mux (
        .sel  (EX_LinkRegDest),
        .in0  (EX_Rt),
        .in1  (EX_Rd),
        .in2  (5'b11111),
        .in3  (5'bxxxxx),
        .out  (EX_RtRd)
    );

    /*** Arithmetic Logic Unit ***/
    ALU_Unit ALU (
        .A          (EX_ReadData1_Fwd),
        .B          (EX_ReadData2_Imm),
        .ALUOp      (EX_ALUOp),
        .Shamt      (EX_Shamt),
        .Result     (EX_ALUResult),
        .Carry      (EX_Carry),
        .OverFlow   (EX_OverFlow)
    );

    /*** Execute -> Memory Pipeline Stage ***/
    EXEMEM_Stage EXMEM (
        /****  Input  ****/
        .clk             (clk),
        .rst             (rst),
        //.EX_Flush          (EX_Exception_Flush),
        .EX_Stall          (EX_Stall),
        .MEM_Stall         (MEM_Stall),
        .EX_RegWrite       (EX_RegWrite),
        .EX_MemtoReg       (EX_MemtoReg),
        .EX_MemRead        (EX_MemRead),
        .EX_MemWrite       (EX_MemWrite),
        .EX_MemByte        (EX_MemByte),
        .EX_MemHalf        (EX_MemHalf),
        .EX_MemSignExt     (EX_MemSignExt),
        .EX_RestartPC      (EX_RestartPC),
        .EX_IsBDS          (EX_IsBDS),
        .EX_ALU_Result     (EX_ALUResult),
        .EX_ReadData2      (EX_ReadData2_Fwd),
        .EX_RtRd           (EX_RtRd),
        /****  Output   *****/
        .MEM_RegWrite        (MEM_RegWrite),
        .MEM_MemtoReg        (MEM_MemtoReg),
        .MEM_MemRead         (MEM_MemRead),
        .MEM_MemWrite        (MEM_MemWrite),
        .MEM_MemByte         (MEM_MemByte),
        .MEM_MemHalf         (MEM_MemHalf),
        .MEM_MemSignExt      (MEM_MemSignExt),
        .MEM_RestartPC       (MEM_RestartPC),
        .MEM_IsBDS           (MEM_IsBDS),
        .MEM_ALU_Result      (MEM_ALUResult),
        .MEM_ReadData2       (MEM_ReadData2_Front),
        .MEM_RtRd            (MEM_RtRd)
    );

    /*** MEM Write Data Mux ***/
    MUX32_2_1  MWriteData_Mux (
        .sel  (MEM_WriteDataFwdSel),
        .in0  (MEM_ReadData2_Front),
        .in1  (WB_WriteData),
        .out  (MEM_WriteData)
    );

    /*** Data Memory Controller ***/
    MemControl DataMem_Controller (
        .clk            (clk),
        .rst            (rst),
        .DataFromCPU    (MEM_WriteData),
        .Address        (MEM_ALUResult),
        .DataFromMem    (DataMem_In),
        .MemReadFromCPU (MEM_MemRead),
        .MemWriteFromCPU  (MEM_MemWrite),
        .MemReadyFromMem  (DataMem_Ready),
        .Byte           (MEM_MemByte),
        .Half           (MEM_MemHalf),
        .SignExt        (MEM_MemSignExtend),
        .IF_Stall       (IF_Stall),
        
        .DataToCPU      (MEM_MemReadData),
        .DataToMem      (DataMem_Out),
        .WriteEnable    (DataMem_Write),
        .ReadEnable     (DataMem_Read),
        .MEM_Stall      (MEM_Stall_Controller)
    );

    /*** Memory -> Writeback Pipeline Stage ***/
    MEMWB_Stage MEMWB (
        .clk          (clk),
        .rst          (rst),
        //.MEM_Flush        (MEM_Exception_Flush),
        .MEM_Stall      (MEM_Stall),
        .WB_Stall       (WB_Stall),
        .MEM_RegWrite     (MEM_RegWrite),
        .MEM_MemtoReg     (MEM_MemtoReg),
        .MEM_ReadData     (MEM_MemReadData),
        .MEM_ALU_Result   (MEM_ALUResult),
        .MEM_RtRd         (MEM_RtRd),
        .WB_RegWrite    (WB_RegWrite),
        .WB_MemtoReg    (WB_MemtoReg),
        .WB_ReadData    (WB_ReadData),
        .WB_ALU_Result  (WB_ALUResult),
        .WB_RtRd        (WB_RtRd)
    );

    /*** WB MemtoReg Mux ***/
    MUX32_2_1  WBMemtoReg_Mux (
        .sel  (WB_MemtoReg),
        .in0  (WB_ALUResult),
        .in1  (WB_ReadData),
        .out  (WB_WriteData)
    );

endmodule