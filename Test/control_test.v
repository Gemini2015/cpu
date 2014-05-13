/*
*	Control test driver
*
*
*	Chris Cheng
*	2014-5-13
*
***/

module testControl;

	reg ID_Stall;
	reg [`OPCODE_WIDTH - 1:0] OpCode;
	reg [`FUNCCODE_WIDTH - 1:0] Func;
	reg Comp_EQ;
	
	wire IF_Flush, SignExt, Link, NextIsDelay, RegDest, ALUSrcSel;
	wire MemWrite, MemRead, MemByte, MemHalf, MemSignExt, RegWrite, MemtoReg;
	wire [`HAZARD_WIDTH - 1:0] DP_Hazards;
	wire [`ALUOP_WIDTH - 1:0] ALUOp;

	Control(
		.ID_Stall(ID_Stall),
		.OpCode(OpCode),
		.Func(Func),
		.Comp_EQ(Comp_EQ),

		.IF_Flush(IF_Flush),
		.DP_Hazards(DP_Hazards),
		.PCSrcSel(PCSrcSel),
		.SignExt(SignExt),
		.Link(Link),
		.NextIsDelay(NextIsDelay),
		.RegDest(RegDest),
		.ALUSrcSel(ALUSrcSel),
		.ALUOp(ALUOp),
		.MemWrite(MemWrite),
		.MemRead(MemRead),
		.MemByte(MemByte),
		.MemHalf(MemHalf),
		.MemSignExt(MemSignExt),
		.RegWrite(RegWrite),
		.MemtoReg(MemtoReg)
		);

	initial
	begin
				ID_Stall <= 0;
				Comp_EQ <= 0;
				OpCode <= Op_Type_R;
				Func <= Func_Add;
		#100	Func <= Func_Addu;
		#100	Func <= Func_And;
		#100	Func <= Func_Jr;
		#100	Func <= Func_Nor;
		#100	Func <= Func_Or;
		#100	Func <= Func_Sll;
		#100	Func <= Func_Slt;
		#100	Func <= Func_Sltu;
		#100	Func <= Func_Srl;
		#100	Func <= Func_Sub;
		#100	Func <= Func_Subu;
		#100	ID_Stall <= 1;
				Func <= Func_Xor;
		#100	ID_Stall <= Func_Xor;
		#100	OpCode <= Op_Addi;
		#100	OpCode <= Op_Addiu;
		#100	OpCode <= Op_Andi;
		#100	OpCode <= Op_Beq;
		#100	OpCode <= Op_Bne;
		#100	OpCode <= Op_J;
		#100	OpCode <= Op_Jal;
		#100	OpCode <= Op_Lb;
		#100	OpCode <= Op_Lbu;
		#100	OpCode <= Op_Lh;
		#100	OpCode <= Op_Lhu;
		#100	OpCode <= Op_Lui;
		#100	OpCode <= Op_Lw;
		#100	OpCode <= Op_Ori;
		#100	OpCode <= Op_Sb;
		#100	OpCode <= Op_Sh;
		#100	OpCode <= Op_Slti;
		#100	OpCode <= Op_Sltiu;
		#100	OpCode <= Op_Sw;
		#100	OpCode <= Op_Xori;
		#100	
	end

endmodule