/*
*	MIPS CPU top module
*
*	
*
*
*	Chris Cheng
*	2014-4-26
*
***/
`include "cpu-para.v"

module Control(
    input  ID_Stall,
    input  [`OPCODE_WIDTH - 1:0] OpCode,
    input  [`FUNCCODE_WIDTH - 1:0] Func,
    input  Comp_EQ,
    
    //------------
    output IF_Flush,
    output reg [`HAZARD_WIDTH - 1:0] DP_Hazards,
    output [1:0] PCSrcSel,
    output SignExt,
    output Link,
    output NextIsDelay,
    output RegDest,
    output ALUSrcSel,
    output reg [`ALUOP_WIDTH - 1:0] ALUOp,
    //output LLSC,
    output MemWrite,
    output MemRead,
    output MemByte,
    output MemHalf,
    output MemSignExt,
    output RegWrite,
    output MemtoReg
    );

	//wire Movc;
    wire Branch, Branch_EQ, Branch_NEQ;//, Branch_GTZ, Branch_LEZ, Branch_NEQ, Branch_GEZ, Branch_LTZ;
   	//wire Unaligned_Mem;
    
    reg [`CTLBUS_WIDTH - 1:0] CtlBus;
    //
    assign PCSrc[0]      = CtlBus[10];
    assign Link          = CtlBus[9];
    assign ALUSrcSel     = CtlBus[8];
    assign RegDst        = CtlBus[7];
    assign MemRead       = CtlBus[6];
    assign MemWrite      = CtlBus[5];
    assign MemHalf       = CtlBus[4];
    assign MemByte       = CtlBus[3];
    assign MemSignExt	 = CtlBus[2];
    assign RegWrite      = CtlBus[1];
    assign MemtoReg      = CtlBus[0];
    
    

    always @(*)
    begin
    	if (ID_Stall)
    		CtlBus <= CB_None;
    	else
		begin
			case(op_code)
				// R type Instruction
				Op_Type_R:
				begin
					case(func_code)
						Func_Add 	: CtlBus <= CB_Add;
						Func_Addu	: CtlBus <= CB_Addu;
						Func_And	: CtlBus <= CB_And;
						Func_Jr 	: CtlBus <= CB_Jr;
						Func_Nor	: CtlBus <= CB_Nor;
						Func_Or 	: CtlBus <= CB_Or;
						Func_Sll	: CtlBus <= CB_Sll;
						Func_Slt 	: CtlBus <= CB_Slt;
						Func_Sltu 	: CtlBus <= CB_Sltu;
						Func_Srl 	: CtlBus <= CB_Srl;
						Func_Sub 	: CtlBus <= CB_Sub;
						Func_Subu 	: CtlBus <= CB_Subu;
						Func_Xor 	: CtlBus <= CB_Xor;
						default 	: CtlBus <= CB_None;
					endcase
				end
				Op_Addi     : CtlBus <= CB_Addi;
	            Op_Addiu    : CtlBus <= CB_Addiu;
	            Op_Andi     : CtlBus <= CB_Andi;
	            Op_Jal      : CtlBus <= CB_Jal;
	            Op_J 		: CtlBus <= CB_J;
	            Op_Lb       : CtlBus <= CB_Lb;
	            Op_Lbu      : CtlBus <= CB_Lbu;
	            Op_Lh       : CtlBus <= CB_Lh;
	            Op_Lhu      : CtlBus <= CB_Lhu;
	            Op_Lui      : CtlBus <= CB_Lui;
	            Op_Lw       : CtlBus <= CB_Lw;
	            Op_Ori      : CtlBus <= CB_Ori;
	            Op_Sb       : CtlBus <= CB_Sb;
	            Op_Sh       : CtlBus <= CB_Sh;
	            Op_Slti     : CtlBus <= CB_Slti;
	            Op_Sltiu    : CtlBus <= CB_Sltiu;
	            Op_Sw       : CtlBus <= CB_Sw;
	            Op_Xori     : CtlBus <= CB_Xori;
	            Op_Beq 		: CtlBus <= CB_Beq;
	            Op_Bne 		: CtlBus <= CB_Bne;
	            default     : CtlBus <= CB_None;
			endcase
		end
	end

	// Hazard detection
	always @(*)
    begin
		case(op_code)
			// R type Instruction
			Op_Type_R:
			begin
				case(func_code)
					Func_Add 	: DP_Hazards <= HZ_Add;
					Func_Addu	: DP_Hazards <= HZ_Addu;
					Func_And	: DP_Hazards <= HZ_And;
					Func_Jr 	: DP_Hazards <= HZ_Jr;
					Func_Nor	: DP_Hazards <= HZ_Nor;
					Func_Or 	: DP_Hazards <= HZ_Or;
					Func_Sll	: DP_Hazards <= HZ_Sll;
					Func_Slt 	: DP_Hazards <= HZ_Slt;
					Func_Sltu 	: DP_Hazards <= HZ_Sltu;
					Func_Srl 	: DP_Hazards <= HZ_Srl;
					Func_Sub 	: DP_Hazards <= HZ_Sub;
					Func_Subu 	: DP_Hazards <= HZ_Subu;
					Func_Xor 	: DP_Hazards <= HZ_Xor;
					default 	: DP_Hazards <= HZ_None;
				endcase
			end
			Op_Addi     : DP_Hazards <= HZ_Addi;
            Op_Addiu    : DP_Hazards <= HZ_Addiu;
            Op_Andi     : DP_Hazards <= HZ_Andi;
            Op_Jal      : DP_Hazards <= HZ_Jal;
            Op_J 		: DP_Hazards <= HZ_J;
            Op_Lb       : DP_Hazards <= HZ_Lb;
            Op_Lbu      : DP_Hazards <= HZ_Lbu;
            Op_Lh       : DP_Hazards <= HZ_Lh;
            Op_Lhu      : DP_Hazards <= HZ_Lhu;
            Op_Lui      : DP_Hazards <= HZ_Lui;
            Op_Lw       : DP_Hazards <= HZ_Lw;
            Op_Ori      : DP_Hazards <= HZ_Ori;
            Op_Sb       : DP_Hazards <= HZ_Sb;
            Op_Sh       : DP_Hazards <= HZ_Sh;
            Op_Slti     : DP_Hazards <= HZ_Slti;
            Op_Sltiu    : DP_Hazards <= HZ_Sltiu;
            Op_Sw       : DP_Hazards <= HZ_Sw;
            Op_Xori     : DP_Hazards <= HZ_Xori;
            Op_Beq 		: DP_Hazards <= HZ_Beq;
            Op_Bne 		: DP_Hazards <= HZ_Bne;
            default     : DP_Hazards <= HZ_None;
		endcase
	end

    // ALU Control signal
    always@(*)
	begin
		case(op_code)
			// R type Instruction
			Op_Type_R:
			begin
				case(func_code)
					Func_Add 	: ALUOp <= AluOp_Add;
					Func_Addu	: ALUOp <= AluOp_Addu;
					Func_And	: ALUOp <= AluOp_And;
					//Func_Jr:	ALUOp <= AluOp_;
					Func_Nor	: ALUOp <= AluOp_Nor;
					Func_Or 	: ALUOp <= AluOp_Or;
					Func_Sll	: ALUOp <= AluOp_Sll;
					Func_Slt 	: ALUOp <= AluOp_Slt;
					Func_Sltu 	: ALUOp <= AluOp_Sltu;
					Func_Srl 	: ALUOp <= AluOp_Srl;
					Func_Sub 	: ALUOp <= AluOp_Sub;
					Func_Subu 	: ALUOp <= AluOp_Subu;
					Func_Xor 	: ALUOp <= AluOp_Xor;
					default 	: ALUOp <= AluOp_Addu;
				endcase
			end
			Op_Addi     : ALUOp <= AluOp_Add;
            Op_Addiu    : ALUOp <= AluOp_Addu;
            Op_Andi     : ALUOp <= AluOp_And;
            /*
            Op_Jal      : ALUOp <= AluOp_Addu;
            Op_Lb       : ALUOp <= AluOp_Addu;
            Op_Lbu      : ALUOp <= AluOp_Addu;
            Op_Lh       : ALUOp <= AluOp_Addu;
            Op_Lhu      : ALUOp <= AluOp_Addu;
            Op_Lui      : ALUOp <= AluOp_Addu;
            Op_Lw       : ALUOp <= AluOp_Addu;
            Op_Sb       : ALUOp <= AluOp_Addu;
            Op_Sh       : ALUOp <= AluOp_Addu;
            Op_Sw       : ALUOp <= AluOp_Addu;
            */
            Op_Ori      : ALUOp <= AluOp_Or;
            Op_Slti     : ALUOp <= AluOp_Slt;
            Op_Sltiu    : ALUOp <= AluOp_Sltu;
            Op_Xori     : ALUOp <= AluOp_Xor;
            default     : ALUOp <= AluOp_Addu;
		endcase
	end
	
    /*** 
     These remaining options cover portions of the datapath that are not
     controlled directly by the datapath bits. Note that some refer to bits of
     the opcode or other fields, which breaks the otherwise fully-abstracted view
     of instruction encodings. Make sure when adding custom instructions that
     no false positives/negatives are generated here.
     ***/
     
    // Branch Detection: Options are mutually exclusive.
    assign Branch_EQ  = ~OpCode[5] & ~OpCode[4] & ~OpCode[3] & OpCode[2] & ~OpCode[1] & ~OpCode[0] &  Comp_EQ;
    assign Branch_NEQ = ~OpCode[5] & ~OpCode[4] & ~OpCode[3] & OpCode[2] & ~OpCode[1] &  OpCode[0] & ~Comp_EQ;
    
    assign Branch = Branch_EQ | Branch_NEQ; //| Branch_GTZ | Branch_LEZ | Branch_NEQ | Branch_GEZ | Branch_LTZ;
    assign PCSrcSel[1] = (CtlBus[11] & ~CtlBus[10]) ? Branch : CtlBus[11];
    
    /* In MIPS32, all Branch and Jump operations execute the Branch Delay Slot,
     * or next instruction, regardless if the branch is taken or not. The exception
     * is the "Branch Likely" instruction group. These are deprecated, however, and not
     * implemented here. "IF_Flush" is defined to allow for the cancelation of a
     * Branch Delay Slot should these be implemented later.
     */

    assign IF_Flush = 0;

    // Indicator that next instruction is a Branch Delay Slot.
    assign NextIsDelay = CtlBus[11] | CtlBus[10];
    
    // Sign- or Zero-Extension Control. The only ops that require zero-extension are
    // Andi, Ori, and Xori. The following also zero-extends 'lui', however it does not alter the effect of lui.
    assign SignExt = (OpCode[5:2] != 4'b0011);

    
endmodule