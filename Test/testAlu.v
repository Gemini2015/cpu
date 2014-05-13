// Verilog Test Fixture Template
/*
*	ALU test driver
*
*
*	Chris Cheng
*	2014-5-13
*
***/
`timescale 1 ns / 1 ps

module testAlu;

	reg[31:0] A,B;
	reg[3:0] ALUOp;
	reg[4:0] Shamt;

	wire[31:0] Result;
	wire OverFlow;

	ALU_Unit alu(
		.A(A),
		.B(B),
		.ALUOp(ALUOp),
		.Shamt(Shamt),
		.Result(Result),
		.OverFlow(OverFlow)
		);

	initial
	begin
				A = 32'h7fff_fff0;
				B = 32'h0000_0010;
				Shamt = 4;
				ALUOp = AluOp_Add;
		#200	ALUOp = AluOp_Addu;
		#200	ALUOp = AluOp_Sub;
		#200	ALUOp = AluOp_Subu;
		#200	ALUOp = AluOp_And;
		#200	ALUOp = AluOp_Or;
		#200	ALUOp = AluOp_Nor;
		#200	ALUOp = AluOp_Xor;
		#200	ALUOp = AluOp_Sll;
		#200	ALUOp = AluOp_Srl;
		#200	ALUOp = AluOp_Slt;
		#200	ALUOp = AluOp_Sltu;
		#200	A = 32'hffff_ffff;
				B = 32'h1;
				ALUOp = AluOp_Add;
		#200	ALUOp = AluOp_Addu;
		#200	ALUOp = AluOp_Slt;
		#200	ALUOp = AluOp_Sltu;
		#200;
	end

endmodule

