/*
*
*	CPU Parameter
*
*
*
*	Chris Cheng
*	2014-4-13
*
***/
/***

	Define of signal width 

***/

`define MIPS_PARA

`define DP_WIDTH 32
`define ADDR_WIDTH 30
`define HALF_DP_WIDTH 16
`define REG_WIDTH 5
`define OPCODE_WIDTH 6
`define FUNCCODE_WIDTH 6
`define ALUOP_WIDTH 4
`define CTLBUS_WIDTH 12
`define HAZARD_WIDTH 8
`define JUMPADDR_WIDTH 26
/***

	Some Parameters in ALU Unit

***/



/* Op Code Categories */
parameter [`OPCODE_WIDTH - 1:0]  Op_Type_R   = 6'b00_0000;  // Standard R-Type instructions

// --------------------------------------
parameter [`OPCODE_WIDTH - 1:0]  Op_Add      = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Addi     = 6'b00_1000;
parameter [`OPCODE_WIDTH - 1:0]  Op_Addiu    = 6'b00_1001;
parameter [`OPCODE_WIDTH - 1:0]  Op_Addu     = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_And      = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Andi     = 6'b00_1100;
parameter [`OPCODE_WIDTH - 1:0]  Op_Beq      = 6'b00_0100;
parameter [`OPCODE_WIDTH - 1:0]  Op_Bne      = 6'b00_0101;
parameter [`OPCODE_WIDTH - 1:0]  Op_J        = 6'b00_0010;
parameter [`OPCODE_WIDTH - 1:0]  Op_Jal      = 6'b00_0011;
//parameter [`OPCODE_WIDTH - 1:0]  Op_Jalr     = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Jr       = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Lb       = 6'b10_0000;
parameter [`OPCODE_WIDTH - 1:0]  Op_Lbu      = 6'b10_0100;
parameter [`OPCODE_WIDTH - 1:0]  Op_Lh       = 6'b10_0001;
parameter [`OPCODE_WIDTH - 1:0]  Op_Lhu      = 6'b10_0101;
parameter [`OPCODE_WIDTH - 1:0]  Op_Lui      = 6'b00_1111;
parameter [`OPCODE_WIDTH - 1:0]  Op_Lw       = 6'b10_0011;
parameter [`OPCODE_WIDTH - 1:0]  Op_Nor      = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Or       = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Ori      = 6'b00_1101;
parameter [`OPCODE_WIDTH - 1:0]  Op_Sb       = 6'b10_1000;
parameter [`OPCODE_WIDTH - 1:0]  Op_Sh       = 6'b10_1001;
parameter [`OPCODE_WIDTH - 1:0]  Op_Sll      = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Slt      = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Slti     = 6'b00_1010;
parameter [`OPCODE_WIDTH - 1:0]  Op_Sltiu    = 6'b00_1011;
parameter [`OPCODE_WIDTH - 1:0]  Op_Sltu     = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Srl      = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Sub      = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Subu     = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Sw       = 6'b10_1011;
parameter [`OPCODE_WIDTH - 1:0]  Op_Xor      = Op_Type_R;
parameter [`OPCODE_WIDTH - 1:0]  Op_Xori     = 6'b00_1110;



/* Funcion Codes for R-Type Op Codes */
parameter [`FUNCCODE_WIDTH - 1:0]  Func_Add     = 6'b10_0000;
parameter [`FUNCCODE_WIDTH - 1:0]  Func_Addu    = 6'b10_0001;
parameter [`FUNCCODE_WIDTH - 1:0]  Func_And     = 6'b10_0100;
parameter [`FUNCCODE_WIDTH - 1:0]  Func_Jr      = 6'b00_1000;
//parameter [`FUNCCODE_WIDTH - 1:0]  Func_Jalr    = 6'b00_1001;
parameter [`FUNCCODE_WIDTH - 1:0]  Func_Nor     = 6'b10_0111;
parameter [`FUNCCODE_WIDTH - 1:0]  Func_Or      = 6'b10_0101;
parameter [`FUNCCODE_WIDTH - 1:0]  Func_Sll     = 6'b00_0000;
parameter [`FUNCCODE_WIDTH - 1:0]  Func_Slt     = 6'b10_1010;
parameter [`FUNCCODE_WIDTH - 1:0]  Func_Sltu    = 6'b10_1011;
parameter [`FUNCCODE_WIDTH - 1:0]  Func_Srl     = 6'b00_0010;
parameter [`FUNCCODE_WIDTH - 1:0]  Func_Sub     = 6'b10_0010;
parameter [`FUNCCODE_WIDTH - 1:0]  Func_Subu    = 6'b10_0011;
parameter [`FUNCCODE_WIDTH - 1:0]  Func_Xor     = 6'b10_0110;


/* ALU Operations (Implementation) */
parameter [`ALUOP_WIDTH - 1:0]  AluOp_Add    = 5'd0;
parameter [`ALUOP_WIDTH - 1:0]  AluOp_Addu   = 5'd1;
parameter [`ALUOP_WIDTH - 1:0]  AluOp_And    = 5'd2;
parameter [`ALUOP_WIDTH - 1:0]  AluOp_Nor    = 5'd3;
parameter [`ALUOP_WIDTH - 1:0]  AluOp_Or     = 5'd4;
parameter [`ALUOP_WIDTH - 1:0]  AluOp_Sll    = 5'd5;
parameter [`ALUOP_WIDTH - 1:0]  AluOp_Slt    = 5'd6;
parameter [`ALUOP_WIDTH - 1:0]  AluOp_Sltu   = 5'd7;
parameter [`ALUOP_WIDTH - 1:0]  AluOp_Sra    = 5'd8;
parameter [`ALUOP_WIDTH - 1:0]  AluOp_Srl    = 5'd9;
parameter [`ALUOP_WIDTH - 1:0]  AluOp_Sub    = 5'd10;
parameter [`ALUOP_WIDTH - 1:0]  AluOp_Subu   = 5'd11;
parameter [`ALUOP_WIDTH - 1:0]  AluOp_Xor    = 5'd12;

/* Control Bus */
/*** Control Signal ***

     All Signals are Active High. Branching and Jump signals (determined by "PCSrc"),
     as well as ALU operation signals ("ALUOp") are handled by the controller and are not found here.

	//11:  Movc          (Conditional Move)
    //10:  Trap          (Trap Instruction)
    //9 :  TrapCond      (Trap Condition) [0=ALU result is 0; 1=ALU result is not 0]
	//7 :  LLSC          (Load Linked or Store Conditional)

     Bit  Name          Description
     ------------------------------
     11:  PCSrc         (Instruction Type)
     10:                   11: Instruction is Jump to Register
                           10: Instruction is Branch
                           01: Instruction is Jump to Immediate
                           00: Instruction does not branch nor jump
     9 :  Link          (Link on Branch/Jump)
     ------------------------------
     8 :  ALUSrc        (ALU Source) [0=ALU input B is 2nd register file output; 1=Immediate value]
     7 :  RegDst        (Register File Target) [0=Rt field; 1=Rd field]
     ------------------------------
     
     6 :  MemRead       (Data Memory Read)
     5 :  MemWrite      (Data Memory Write)
     4 :  MemHalf       (Half Word Memory Access)
     3 :  MemByte       (Byte size Memory Access)
     2 :  MemSignExt (Sign Extend Read Memory) [0=Zero Extend; 1=Sign Extend]
     ------------------------------
     1 :  RegWrite      (Register File Write)
     0 :  MemtoReg      (Memory to Register) [0=Register File write data is ALU output; 1=Is Data Memory]
     ------------------------------
*/
parameter [`CTLBUS_WIDTH - 1:0] CB_None			= 12'b000_00_00000_00;

parameter [`CTLBUS_WIDTH - 1:0] CB_RType		= 12'b000_01_00000_10;
parameter [`CTLBUS_WIDTH - 1:0] CB_IType		= 12'b000_10_00000_10;

parameter [`CTLBUS_WIDTH - 1:0] CB_Branch		= 12'b100_00_00000_00;
parameter [`CTLBUS_WIDTH - 1:0] CB_Jump			= 12'b010_00_00000_00;
parameter [`CTLBUS_WIDTH - 1:0] CB_JumpLink		= 12'b011_00_00000_10;
parameter [`CTLBUS_WIDTH - 1:0] CB_JumpReg		= 12'b110_00_00000_00;
parameter [`CTLBUS_WIDTH - 1:0] CB_JumpRegLink	= 12'b111_00_00000_10;

parameter [`CTLBUS_WIDTH - 1:0] CB_LoadByteS	= 12'b000_10_10011_11;
parameter [`CTLBUS_WIDTH - 1:0] CB_LoadByteU	= 12'b000_10_10010_11;
parameter [`CTLBUS_WIDTH - 1:0] CB_LoadHalfS	= 12'b000_10_10101_11;
parameter [`CTLBUS_WIDTH - 1:0] CB_LoadHalfU	= 12'b000_10_10100_11;
parameter [`CTLBUS_WIDTH - 1:0] CB_LoadWord		= 12'b000_10_10000_11;
parameter [`CTLBUS_WIDTH - 1:0] CB_StoreByte	= 12'b000_10_01010_00;
parameter [`CTLBUS_WIDTH - 1:0] CB_StoreHalf	= 12'b000_10_01100_00;
parameter [`CTLBUS_WIDTH - 1:0] CB_StoreWord	= 12'b000_10_01000_00;

parameter [`CTLBUS_WIDTH - 1:0] CB_Add 		= CB_RType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Addi		= CB_IType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Addu		= CB_RType;	
parameter [`CTLBUS_WIDTH - 1:0] CB_Addiu	= CB_IType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Sub		= CB_RType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Subu		= CB_RType;
parameter [`CTLBUS_WIDTH - 1:0] CB_And		= CB_RType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Andi		= CB_IType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Or 		= CB_RType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Ori		= CB_IType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Xor		= CB_RType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Xori		= CB_IType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Nor		= CB_RType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Sll		= CB_RType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Srl 		= CB_RType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Slt		= CB_RType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Sltu		= CB_RType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Slti		= CB_IType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Sltiu	= CB_IType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Lw 		= CB_LoadWord;
parameter [`CTLBUS_WIDTH - 1:0] CB_Lb 		= CB_LoadByteS;
parameter [`CTLBUS_WIDTH - 1:0] CB_Lbu 		= CB_LoadByteU;
parameter [`CTLBUS_WIDTH - 1:0] CB_Lh 		= CB_LoadHalfS;
parameter [`CTLBUS_WIDTH - 1:0] CB_Lhu 		= CB_LoadHalfU;
parameter [`CTLBUS_WIDTH - 1:0] CB_Lui 		= CB_IType;
parameter [`CTLBUS_WIDTH - 1:0] CB_Sw 		= CB_StoreWord;
parameter [`CTLBUS_WIDTH - 1:0] CB_Sb 		= CB_StoreByte;
parameter [`CTLBUS_WIDTH - 1:0] CB_Sh 		= CB_StoreHalf;
parameter [`CTLBUS_WIDTH - 1:0] CB_Beq  	= CB_Branch;
parameter [`CTLBUS_WIDTH - 1:0] CB_Bne 		= CB_Branch;
parameter [`CTLBUS_WIDTH - 1:0] CB_J 		= CB_Jump;
parameter [`CTLBUS_WIDTH - 1:0] CB_Jal 		= CB_JumpLink;
parameter [`CTLBUS_WIDTH - 1:0] CB_Jr 		= CB_JumpReg;


/*** Hazard & Forwarding Control Signal ***

     All signals are Active High.
     
     Bit  Meaning
     ------------
     7:   Wants Rs by ID
     6:   Needs Rs by ID
     5:   Wants Rt by ID
     4:   Needs Rt by ID
     3:   Wants Rs by EX
     2:   Needs Rs by EX
     1:   Wants Rt by EX
     0:   Needs Rt by EX
*/
parameter [`HAZARD_WIDTH - 1:0] HZ_None		= 8'b0000_0000;
parameter [`HAZARD_WIDTH - 1:0] HZ_IDRsIDRt	= 8'b1111_0000;
parameter [`HAZARD_WIDTH - 1:0] HZ_IDRs 	= 8'b1100_0000;
//parameter [`HAZARD_WIDTH - 1:0] HZ_IDRt 	= 8'b0011_0000;
//parameter [`HAZARD_WIDTH - 1:0] HZ_IDRtEXRs = 8'b1011_1100;
parameter [`HAZARD_WIDTH - 1:0] HZ_EXRsEXRt = 8'b1010_1111;
parameter [`HAZARD_WIDTH - 1:0] HZ_EXRs 	= 8'b1000_1100;
parameter [`HAZARD_WIDTH - 1:0] HZ_EXRsWBRt = 8'b1010_1110;
parameter [`HAZARD_WIDTH - 1:0] HZ_EXRt 	= 8'b0010_0011;

parameter [`HAZARD_WIDTH - 1:0] HZ_Add 		= HZ_EXRsEXRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Addi		= HZ_EXRs;
parameter [`HAZARD_WIDTH - 1:0] HZ_Addu		= HZ_EXRsEXRt;	
parameter [`HAZARD_WIDTH - 1:0] HZ_Addiu	= HZ_EXRs;
parameter [`HAZARD_WIDTH - 1:0] HZ_Sub		= HZ_EXRsEXRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Subu		= HZ_EXRsEXRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_And		= HZ_EXRsEXRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Andi		= HZ_EXRs;
parameter [`HAZARD_WIDTH - 1:0] HZ_Or 		= HZ_EXRsEXRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Ori		= HZ_EXRs;
parameter [`HAZARD_WIDTH - 1:0] HZ_Xor		= HZ_EXRsEXRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Xori		= HZ_EXRs;
parameter [`HAZARD_WIDTH - 1:0] HZ_Nor		= HZ_EXRsEXRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Sll		= HZ_EXRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Srl 		= HZ_EXRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Slt		= HZ_EXRsEXRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Sltu		= HZ_EXRsEXRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Slti		= HZ_EXRs;
parameter [`HAZARD_WIDTH - 1:0] HZ_Sltiu	= HZ_EXRs;
parameter [`HAZARD_WIDTH - 1:0] HZ_Lw 		= HZ_EXRs;
parameter [`HAZARD_WIDTH - 1:0] HZ_Lb 		= HZ_EXRs;
parameter [`HAZARD_WIDTH - 1:0] HZ_Lbu 		= HZ_EXRs;
parameter [`HAZARD_WIDTH - 1:0] HZ_Lh 		= HZ_EXRs;
parameter [`HAZARD_WIDTH - 1:0] HZ_Lhu 		= HZ_EXRs;
parameter [`HAZARD_WIDTH - 1:0] HZ_Lui 		= HZ_None;
parameter [`HAZARD_WIDTH - 1:0] HZ_Sw 		= HZ_EXRsWBRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Sb 		= HZ_EXRsWBRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Sh 		= HZ_EXRsWBRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Beq  	= HZ_IDRsIDRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_Bne 		= HZ_IDRsIDRt;
parameter [`HAZARD_WIDTH - 1:0] HZ_J 		= HZ_None;
parameter [`HAZARD_WIDTH - 1:0] HZ_Jal 		= HZ_None;
parameter [`HAZARD_WIDTH - 1:0] HZ_Jr 		= HZ_IDRs;
