/*
*	ALU & Adder
*
*	32 bits ALU
*	adder:	32,8
*	full adder:	4 
*
*
*	Chris Cheng
*	2014-4-9
*
***/



// 32 bit adder
//对于有符号数，需要考察 OF(overflow)
//对于无符号数，忽略 OF
module Adder32(A, B, Cin, m, S, CF, OF);
    
    input[31:0]	A, B;
	input Cin, m;
	output[31:0] S;
    output CF, OF;

	wire t1, t2, t3, t4;
	
	Adder8 ad1(A[ 7: 0], B[ 7: 0], Cin, m, S[ 7: 0], t1, t4);
	Adder8 ad2(A[15: 8], B[15: 8], t1,  m, S[15: 8], t2, t5);
	Adder8 ad3(A[23:16], B[23:16], t2,  m, S[23:16], t3, t6);
	Adder8 ad4(A[31:24], B[31:24], t3,  m, S[31:24], CF, OF);

endmodule

module Adder8(A, B, Cin, m, S, CF, OF);
    input [7:0]	A, B;
	input			Cin, m;
	output [7:0]	S;
    output	CF, OF;

	Adder4 ad1(A[3:0], B[3:0], Cin, m, S[3:0], t1, t2);
	Adder4 ad2(A[7:4], B[7:4], t1,  m, S[7:4], CF, OF);
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
module Adder4(A, B, Cin, m, S, CF, OF);
    input[3:0]		A, B;
	 input			Cin, m;
    output[3:0]	S;
    output	CF, OF;
	 
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
	or (CF, g[3], x1, x2, x3, x4);//c4=g3+p3g2+p3p2g1+p3p2p1g0+p3p2p1p0c0
	//溢出的进位判断法
	//符号位向前产生的进位值与尾数最高位向前产生的进位值相异时，才会溢出
	xor(OF, w4, CF);
	
endmodule