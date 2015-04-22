`timescale 1ns / 1ps

module AddSub_Test;

	reg[31:0] inA;
	reg[31:0] inB;
	reg mode;

	wire[31:0] out;
	wire carry;
	wire overFlow;

	AddSub32_2_1 addsub(
		.inA(inA),
		.inB(inB),
		.cin(mode),
		.mode(mode),

		.out(out),
		.carry(carry),
		.overFlow(overFlow)
	);

	initial
	begin
		// unsigned
		// UINT32_MAX + 1
				inA = 32'hffff_ffff;
				inB = 32'h1;
				mode = 0;
		// 1 + 1
		#200	inA = 32'h1;
				inB = 32'h1;

		// UINT32_MAX + UINT32_MAX
		#200	inA = 32'hffff_ffff;
				inB = 32'hffff_ffff;

		// UINT32_MIN + UINT32_MIN
		#200	inA = 32'h0;
				inB = 32'h0;

		// INT32_MAX + 1
		#200	inA = 32'h7fff_ffff;
				inB = 32'h1;

		// signed
		// INT32_MAX + INT32_MAX
		#200	inA = 32'h7fff_ffff;
				inB = 32'h7fff_ffff;

		// INT32_MIN + INT32_MIN
		#200	inA = 32'h8000_0000;
				inB = 32'h8000_0000;

		// INT32_MIN + -1
		#200	inA = 32'h8000_0000;
				inB = 32'hffff_ffff;

	end

endmodule
