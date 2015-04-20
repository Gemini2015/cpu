`timescale 1ns / 1ps

module AddSub4_2_1(
	input[3:0] inA,
	input[3:0] inB,
	input cin,
	input mode,

	output[3:0] out,
	output carry,
	output overFlow
);

    wire[3:0]   xb, p, g;
    xor(xb[0], inB[0], mode); xor(xb[1], inB[1], mode);
    xor(xb[2], inB[2], mode); xor(xb[3], inB[3], mode);
    and(g[0], inA[0], xb[0]); and(g[1], inA[1], xb[1]);
    and(g[2], inA[2], xb[2]); and(g[3], inA[3], xb[3]);
    or (p[0], inA[0], xb[0]); or (p[1], inA[1], xb[1]);
    or (p[2], inA[2], xb[2]); or (p[3], inA[3], xb[3]);

    xor(out[0], inA[0], xb[0], cin);    //c0=cin

    wire    u1, u2;
    and(u1, p[0],cin);
    or (u2, g[0], u1);
    xor(out[1], inA[1], xb[1], u2);     //c1=g0+p0c0

    wire    v1, v2, v3;
    and(v1, p[1],g[0]);
    and(v2, p[1],p[0],cin);
	or(v3, g[1], v1, v2);
    xor(out[2], inA[2], xb[2], v3);    //c2=g1+p1g0+p1p0c0

    wire    w1, w2, w3, w4;
    and(w1, p[2],g[1]);
    and(w2, p[2],p[1],g[0]);
    and(w3, p[2],p[1],p[0],cin);
    or (w4, g[2], w1, w2, w3);
    xor(out[3], inA[3], xb[3], w4);     //c3=g2+p2g1+p2p1g0+p2p1p0c0

    wire    x1, x2, x3, x4;
    and(x1, p[3],g[2]);
    and(x2, p[3],p[2],g[1]);
    and(x3, p[3],p[2],p[1],g[0]);
    and(x4, p[3],p[2],p[1],p[0],cin);
    or (carry, g[3], x1, x2, x3, x4);	//c4=g3+p3g2+p3p2g1+p3p2p1g0+p3p2p1p0c0

    xor(overFlow, w4, carry);

endmodule

module AddSub8_2_1(
	input[7:0] inA,
	input[7:0] inB,
	input cin,
	input mode,

	output[7:0] out,
	output carry,
	output overFlow
);

	wire t1, t2;

	AddSub4_2_1 addsub1(inA[3:0], inB[3:0], cin, mode, out[3:0], t1, t2);
	AddSub4_2_1 addsub2(inA[7:4], inB[7:4], t1, mode, out[7:4], carry, overFlow);

endmodule

module AddSub32_2_1(
	input[31:0] inA,
	input[31:0] inB,
	input cin,
	input mode,

	output[31:0] out,
	output carry,
	output overFlow
);

	wire t1, t2, t3, t4, t5, t6;

	AddSub8_2_1 addsub1(inA[7:0], inB[7:0], cin, mode, out[7:0], t1, t4);
	AddSub8_2_1 addsub2(inA[15:8], inB[15:8], t1, mode, out[15:8], t2, t5);
	AddSub8_2_1 addsub3(inA[23:16], inB[23:16], t2, mode, out[23:16], t3, t6);
	AddSub8_2_1 addsub4(inA[31:24], inB[31:24], t3, mode, out[31:24], carry, overFlow);

endmodule

module Adder32_2_1(
	input [31:0] in0,
	input [31:0] in1,
	output [31:0] out
);

	assign out = in0 + in1;

endmodule

module AdderS32_2_1(
	input signed[31:0] in0,
	input signed[31:0] in1,
	output signed[31:0] out
);

	assign out = in0 + in1;

endmodule

module ALUnit(
	input[31:0] inA,
	input[31:0] inB,
	input[3:0] ALUOp,
	input[4:0] shamt,
	output reg[31:0] out,
	output reg overFlow
);

	wire signed[31:0] signedInA, signedInB;
	wire mode;
	wire[31:0] addsub_result;
	wire carry, of;

	assign mode = ((ALUOp == ALUOp_Sub) | (ALUOp == ALUOp_Subu));
	assign signedInA = inA;
	assign signedInB = inB;

	AddSub32_2_1 addsub(
		.inA(inA),
		.inB(inB),
		.cin(mode),
		.mode(mode),
		.out(addsub_result),
		.carry(carry),
		.overFlow(of)
	);

	always @(*)
	begin
		case(ALUOp)
			ALUOp_Add	: out <= addsub_result;
			ALUOp_Addu	: out <= addsub_result;
			ALUOp_And	: out <= inA & inB;
			ALUOp_Nor	: out <= ~(inA | inB);
			ALUOp_Or	: out <= inA | inB;
			ALUOp_Sll	: out <= inB << shamt;
			ALUOp_Slt	: out <= (signedInA < signedInB) ? 32'h0000_0001 : 32'h0000_0000;
			ALUOp_Sltu	: out <= (inA < inB) ? 32'h0000_0001 : 32'h0000_0000;
			ALUOp_Srl	: out <= inB >> shamt;
			ALUOp_Sub	: out <= addsub_result;
			ALUOp_Subu	: out <= addsub_result;
			ALUOp_Xor	: out <= inA ^ inB;
			ALUOp_Lui	: out <= {inB[15:0], 16'b0};
			default		: out <= 32'bx;
		endcase

		case(ALUOp)
			ALUOp_Add	: overFlow <= of;
			ALUOp_Sub	: overFlow <= of;
			default		: overFlow <= 0;
		endcase
	end

endmodule
