/*
*	ALU & ALU controller & Adder
*
*	32 bits ALU
*	adder:	32,8
*	adder:	4 
*	Comparator:	32
*
*	Chris Cheng
*	2014-4-9
*
***/

/*
*	ALU relative instruction
*
*	add, addu, addi, addiu, sub, subu,
*	and, andi, or, ori, xor, xori, nor
*	sll, srl
*	slt, sltu, slti, sltiu
*
*
***/
`ifndef MIPS_PARA

`include "cpu_para.v"

`endif

/*
*
*	ALU Unit
*
*	process Arithmetic operations and logical operations
*
***/
module ALU_Unit(
    input[`DP_WIDTH - 1:0]	A,
    input[`DP_WIDTH - 1:0]	B,
    input[`ALUOP_WIDTH - 1:0]  ALUOp,
    input[4:0]	Shamt,
    output reg [`DP_WIDTH - 1:0]	Result,
    output Carry,
    output OverFlow
	);
	
	// Internal signals
	// add or sub flag
	// Add: AddSub_Mode = 0
	// Sub: AddSub_Mode = 1
	wire signed[`DP_WIDTH - 1:0] SignedA, SignedB;
    wire AddSub_Mode;
    wire[`DP_WIDTH - 1:0] AddSub_Result;
    
    // Initial
    assign AddSub_Mode = ((ALUOp == AluOp_Sub) | (ALUOp == AluOp_Subu));
	 assign SignedA = A;
	 assign SignedB = B;
	 
    Adder32 adder(
    		.A(A),
    		.B(B),
    		.Cin(AddSub_Mode),
    		.m(AddSub_Mode),
    		.S(AddSub_Result),
    		.Carry(Carry),
    		.OverFlow(OverFlow)
    		);

    always @(*)
    begin
        case (ALUOp)
            AluOp_Add   : Result <= AddSub_Result;
            AluOp_Addu  : Result <= AddSub_Result;
            AluOp_And   : Result <= A & B;
            AluOp_Nor   : Result <= ~(A | B);
            AluOp_Or    : Result <= A | B;
            AluOp_Sll   : Result <= B << Shamt;
            AluOp_Slt   : Result <= (SignedA < SignedB) ? 32'h00000001 : 32'h00000000;
            AluOp_Sltu  : Result <= (A < B)   ? 32'h00000001 : 32'h00000000;
            AluOp_Srl   : Result <= B >> Shamt;
            AluOp_Sub   : Result <= AddSub_Result;
            AluOp_Subu  : Result <= AddSub_Result;
            AluOp_Xor   : Result <= A ^ B;
            default     : Result <= 32'bx;
        endcase
    end

endmodule

/*
* 
*	ALU Controller
*
*	Decode Instruction Op_code and Func_code
*
**/
/*
module ALU_Controller(
	input[`OPCODE_WIDTH - 1:0] op_code,
	input[`FUNCCODE_WIDTH - 1:0] func_code,
	output[`ALUOP_WIDTH - 1:0] ALUop_code
	);
	
	wire[`OPCODE_WIDTH -1:0] op_code;
	wire[`FUNCCODE_WIDTH - 1:0] func_code;
	reg[`ALUOP_WIDTH - 1:0] ALUop_code;

	always@(*)
	begin
		case(op_code)
			// R type Instruction
			Op_Type_R:
			begin
				case(func_code)
					Func_Add 	: ALUop_code <= AluOp_Add;
					Func_Addu	: ALUop_code <= AluOp_Addu;
					Func_And	: ALUop_code <= AluOp_And;
					//Func_Jr:	ALUop_code <= AluOp_;
					Func_Nor	: ALUop_code <= AluOp_Nor;
					Func_Or 	: ALUop_code <= AluOp_Or;
					Func_Sll	: ALUop_code <= AluOp_Sll;
					Func_Slt 	: ALUop_code <= AluOp_Slt;
					Func_Sltu 	: ALUop_code <= AluOp_Sltu;
					Func_Srl 	: ALUop_code <= AluOp_Srl;
					Func_Sub 	: ALUop_code <= AluOp_Sub;
					Func_Subu 	: ALUop_code <= AluOp_Subu;
					Func_Xor 	: ALUop_code <= AluOp_Xor;
					default 	: ALUop_code <= AluOp_Addu;
				endcase
			end
			Op_Addi     : ALUOp <= AluOp_Add;
            Op_Addiu    : ALUOp <= AluOp_Addu;
            Op_Andi     : ALUOp <= AluOp_And;
            Op_Jal      : ALUOp <= AluOp_Addu;
            Op_Lb       : ALUOp <= AluOp_Addu;
            Op_Lbu      : ALUOp <= AluOp_Addu;
            Op_Lh       : ALUOp <= AluOp_Addu;
            Op_Lhu      : ALUOp <= AluOp_Addu;
            Op_Lui      : ALUOp <= AluOp_Addu;
            Op_Lw       : ALUOp <= AluOp_Addu;
            Op_Ori      : ALUOp <= AluOp_Or;
            Op_Sb       : ALUOp <= AluOp_Addu;
            Op_Sh       : ALUOp <= AluOp_Addu;
            Op_Slti     : ALUOp <= AluOp_Slt;
            Op_Sltiu    : ALUOp <= AluOp_Sltu;
            Op_Sw       : ALUOp <= AluOp_Addu;
            Op_Xori     : ALUOp <= AluOp_Xor;
            default     : ALUOp <= AluOp_Addu;
		endcase
	end

endmodule
*/
// 32 bit adder
//对于有符号数，需要考察 OverFlow
//对于无符号数，忽�OverFlow
module Adder32(A, B, Cin, m, S, Carry, OverFlow);
    
    input[31:0]	A, B;
	input Cin, m;
	output[31:0] S;
    output Carry, OverFlow;

	wire t1, t2, t3, t4;
	
	Adder8 ad1(A[ 7: 0], B[ 7: 0], Cin, m, S[ 7: 0], t1, t4);
	Adder8 ad2(A[15: 8], B[15: 8], t1,  m, S[15: 8], t2, t5);
	Adder8 ad3(A[23:16], B[23:16], t2,  m, S[23:16], t3, t6);
	Adder8 ad4(A[31:24], B[31:24], t3,  m, S[31:24], Carry, OverFlow);

endmodule

module PCAdder(
	input[31:0] a,
	input[31:0] b,
	output[31:0] res
	);

	assign res = a + b;

endmodule

module Adder8(A, B, Cin, m, S, Carry, OverFlow);
    input [7:0]	A, B;
	input			Cin, m;
	output [7:0]	S;
    output	Carry, OverFlow;

	Adder4 ad1(A[3:0], B[3:0], Cin, m, S[3:0], t1, t2);
	Adder4 ad2(A[7:4], B[7:4], t1,  m, S[7:4], Carry, OverFlow);
endmodule

/*
*
*	a - b = a + (-b) = a + not(b) + 1
*
*	add: cin = 0,
*		 m = 0;
*
*	sub: cin = 1,
*		 m = 1;
*
*/
module Adder4(A, B, Cin, m, S, Carry, OverFlow);
    input[3:0]		A, B;
	input			Cin, m;
    output[3:0]	S;
    output	Carry, OverFlow;
	 
	wire[3:0]	xb, p, g;
	// if m == 1, not(B)
	xor(xb[0], B[0], m); xor(xb[1], B[1], m);
	xor(xb[2], B[2], m); xor(xb[3], B[3], m);
	and(g[0], A[0], xb[0]);	and(g[1], A[1], xb[1]);
	and(g[2], A[2], xb[2]);	and(g[3], A[3], xb[3]);
	or (p[0], A[0], xb[0]);	or (p[1], A[1], xb[1]);
	or (p[2], A[2], xb[2]);	or (p[3], A[3], xb[3]);
	
	xor(S[0], A[0], xb[0], Cin);	//c0=Cin
	wire	u1, u2;
	and(u1, p[0],Cin);
	or (u2, g[0], u1);
	xor(S[1], A[1], xb[1], u2);		//c1=g0+p0c0
	wire	v1, v2, v3;
	and(v1, p[1],g[0]);
	and(v2, p[1],p[0],Cin);
	or (v3, g[1], v1, v2);
	xor(S[2], A[2], xb[2], v3);		//c2=g1+p1g0+p1p0c0 
	wire	w1, w2, w3, w4;
	and(w1, p[2],g[1]);
	and(w2, p[2],p[1],g[0]);
	and(w3, p[2],p[1],p[0],Cin);
	or (w4, g[2], w1, w2, w3);
	xor(S[3], A[3], xb[3], w4);		//c3=g2+p2g1+p2p1g0+p2p1p0c0
	wire	x1, x2, x3, x4;
	and(x1, p[3],g[2]);
	and(x2, p[3],p[2],g[1]);
	and(x3, p[3],p[2],p[1],g[0]);
	and(x4, p[3],p[2],p[1],p[0],Cin);
	or (Carry, g[3], x1, x2, x3, x4);//c4=g3+p3g2+p3p2g1+p3p2p1g0+p3p2p1p0c0
	//溢出的进位判断法
	//符号位向前产生的进位值与尾数最高位向前产生的进位值相异时，才会溢�
	xor(OverFlow, w4, Carry);
	
endmodule

/*
*
*	Comparator
*
*	Compare two 32 bits value
*
*
***/
module Compare32(
	input[`DP_WIDTH - 1:0] A,
	input[`DP_WIDTH - 1:0] B,
	output EQ
	);
	
	assign EQ = (A == B);

endmodule


