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

	Define of Datapath width 

***/

`define DP_WIDTH 32



/***

	Some Parameters in ALU Unit

***/

`define OPCODE_WIDTH 6

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

`define FUNCCODE_WIDTH 6

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

`define ALUOP_WIDTH 4

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