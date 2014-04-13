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

/* Op Code Categories */
parameter [5:0] Op_Type_R   = 6'b00_0000;  // Standard R-Type instructions

// --------------------------------------
parameter [5:0] Op_Add      = Op_Type_R;
parameter [5:0] Op_Addi     = 6'b00_1000;
parameter [5:0] Op_Addiu    = 6'b00_1001;
parameter [5:0] Op_Addu     = Op_Type_R;
parameter [5:0] Op_And      = Op_Type_R;
parameter [5:0] Op_Andi     = 6'b00_1100;
parameter [5:0] Op_Beq      = 6'b00_0100;
parameter [5:0] Op_Bne      = 6'b00_0101;
parameter [5:0] Op_J        = 6'b00_0010;
parameter [5:0] Op_Jal      = 6'b00_0011;
//parameter [5:0] Op_Jalr     = Op_Type_R;
parameter [5:0] Op_Jr       = Op_Type_R;
parameter [5:0] Op_Lb       = 6'b10_0000;
parameter [5:0] Op_Lbu      = 6'b10_0100;
parameter [5:0] Op_Lh       = 6'b10_0001;
parameter [5:0] Op_Lhu      = 6'b10_0101;
parameter [5:0] Op_Lui      = 6'b00_1111;
parameter [5:0] Op_Lw       = 6'b10_0011;
parameter [5:0] Op_Nor      = Op_Type_R;
parameter [5:0] Op_Or       = Op_Type_R;
parameter [5:0] Op_Ori      = 6'b00_1101;
parameter [5:0] Op_Sb       = 6'b10_1000;
parameter [5:0] Op_Sh       = 6'b10_1001;
parameter [5:0] Op_Sll      = Op_Type_R;
parameter [5:0] Op_Slt      = Op_Type_R;
parameter [5:0] Op_Slti     = 6'b00_1010;
parameter [5:0] Op_Sltiu    = 6'b00_1011;
parameter [5:0] Op_Sltu     = Op_Type_R;
parameter [5:0] Op_Srl      = Op_Type_R;
parameter [5:0] Op_Sub      = Op_Type_R;
parameter [5:0] Op_Subu     = Op_Type_R;
parameter [5:0] Op_Sw       = 6'b10_1011;
parameter [5:0] Op_Xor      = Op_Type_R;
parameter [5:0] Op_Xori     = 6'b00_1110;

/* Function Codes for R-Type Op Codes */
parameter [5:0] Funct_Add     = 6'b10_0000;
parameter [5:0] Funct_Addu    = 6'b10_0001;
parameter [5:0] Funct_And     = 6'b10_0100;
parameter [5:0] Funct_Jr      = 6'b00_1000;
//parameter [5:0] Funct_Jalr    = 6'b00_1001;
parameter [5:0] Funct_Nor     = 6'b10_0111;
parameter [5:0] Funct_Or      = 6'b10_0101;
parameter [5:0] Funct_Sll     = 6'b00_0000;
parameter [5:0] Funct_Slt     = 6'b10_1010;
parameter [5:0] Funct_Sltu    = 6'b10_1011;
parameter [5:0] Funct_Srl     = 6'b00_0010;
parameter [5:0] Funct_Sub     = 6'b10_0010;
parameter [5:0] Funct_Subu    = 6'b10_0011;
parameter [5:0] Funct_Xor     = 6'b10_0110;

/* ALU Operations (Implementation) */
parameter [4:0] AluOp_Add    = 5'd0;
parameter [4:0] AluOp_Addu   = 5'd1;
parameter [4:0] AluOp_And    = 5'd2;
parameter [4:0] AluOp_Nor    = 5'd3;
parameter [4:0] AluOp_Or     = 5'd4;
parameter [4:0] AluOp_Sll    = 5'd5;
parameter [4:0] AluOp_Slt    = 5'd6;
parameter [4:0] AluOp_Sltu   = 5'd7;
parameter [4:0] AluOp_Sra    = 5'd8;
parameter [4:0] AluOp_Srl    = 5'd9;
parameter [4:0] AluOp_Sub    = 5'd10;
parameter [4:0] AluOp_Subu   = 5'd11;
parameter [4:0] AluOp_Xor    = 5'd12;