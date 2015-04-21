`timescale 1ns / 1ps
//`include "../Source/ParamDefine.v"

module ALU_Test;

	reg[31:0] inA, inB;
	reg[3:0] ALUOp;
	reg[4:0] shamt;

	wire[31:0] result;
	wire overFlow;

	ALUnit alu(
		.inA(inA),
		.inB(inB),
		.ALUOp(ALUOp),
		.shamt(shamt),
		.out(result),
		.overFlow(overFlow)
	);

	initial
	begin
				inA = 32'h7fff_fff0;
				inB = 32'h0000_0010;
				shamt = 4;
				ALUOp = ALUOp_Add;
		#200	ALUOp = ALUOp_Addu;
		#200	ALUOp = ALUOp_Sub;
		#200	ALUOp = ALUOp_Subu;
		#200	ALUOp = ALUOp_And;
		#200	ALUOp = ALUOp_Nor;
		#200	ALUOp = ALUOp_Or;
		#200	ALUOp = ALUOp_Xor;
		#200	ALUOp = ALUOp_Sll;
		#200	ALUOp = ALUOp_Srl;
		#200	ALUOp = ALUOp_Slt;
		#200	ALUOp = ALUOp_Sltu;

		#200	inA = 32'hffff_ffff;
				inB = 32'h1;
				ALUOp = ALUOp_Add;
		#200	ALUOp = ALUOp_Addu;
		#200	ALUOp = ALUOp_Sub;
		#200	ALUOp = ALUOp_Subu;
		#200	ALUOp = ALUOp_Slt;
		#200	ALUOp = ALUOp_Sltu;
		#200	ALUOp = ALUOp_Lui;
		#200;
	end

endmodule
