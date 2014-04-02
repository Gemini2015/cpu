/*
*	Basic Elements
*
*			
*	Mux:	2-1: 5, 8, 16, 32 bits
*		 	4-1: 32 bits
*
*	And: 	2: 16, 32
*			3: 32
*
*	Or: 	2: 16, 32
*			4: 32
*
*	Xor: 	2: 32
*
*
*	Chris Cheng
*	2014-4-1
*
***/

// 5 bits mux 2 - 1
module MUX5_2_1(S, ctrl, A, B);
    input[4:0]	A, B;
	 input			ctrl;
	 output[4:0]	S;

	wire [4:0]	ta, tb;
	and(ta[0], A[0], ~ctrl);
	and(ta[1], A[1], ~ctrl);
	and(ta[2], A[2], ~ctrl);
	and(ta[3], A[3], ~ctrl);
	and(ta[4], A[4], ~ctrl);
	
	and(tb[0], B[0],  ctrl);
	and(tb[1], B[1],  ctrl);
	and(tb[2], B[2],  ctrl);
	and(tb[3], B[3],  ctrl);
	and(tb[4], B[4],  ctrl);

	or(S[0], ta[0], tb[0]);
	or(S[1], ta[1], tb[1]);
	or(S[2], ta[2], tb[2]);
	or(S[3], ta[3], tb[3]);
	or(S[4], ta[4], tb[4]);
endmodule

// 8 bits mux 2 - 1
module MUX8_2_1(S, ctrl, A, B);
    input[7:0]	A, B;
	 input			ctrl;
	 output[7:0]	S;

	wire [7:0]	ta, tb;
	and(ta[0], A[0], ~ctrl);
	and(ta[1], A[1], ~ctrl);
	and(ta[2], A[2], ~ctrl);
	and(ta[3], A[3], ~ctrl);
	and(ta[4], A[4], ~ctrl);
	and(ta[5], A[5], ~ctrl);
	and(ta[6], A[6], ~ctrl);
	and(ta[7], A[7], ~ctrl);
	
	and(tb[0], B[0],  ctrl);
	and(tb[1], B[1],  ctrl);
	and(tb[2], B[2],  ctrl);
	and(tb[3], B[3],  ctrl);
	and(tb[4], B[4],  ctrl);
	and(tb[5], B[5],  ctrl);
	and(tb[6], B[6],  ctrl);
	and(tb[7], B[7],  ctrl);
	
	or(S[0], ta[0], tb[0]);
	or(S[1], ta[1], tb[1]);
	or(S[2], ta[2], tb[2]);
	or(S[3], ta[3], tb[3]);
	or(S[4], ta[4], tb[4]);
	or(S[5], ta[5], tb[5]);
	or(S[6], ta[6], tb[6]);
	or(S[7], ta[7], tb[7]);
endmodule

// 16 bits mux 2 - 1
module MUX16_2_1(S, ctrl, A, B);
    input[15:0]	A, B;
	 input			ctrl;
	 output [15:0]	S;

	wire [15:0]	ta, tb;
	AND16_2 a1(ta, A, {16{~ctrl}});
	AND16_2 a2(tb, B, {16{ ctrl}});
	OR16_2 o1(S, ta, tb);
endmodule

// 32 bits mux 2 - 1
module MUX32_2_1(S, ctrl, A, B);
    input[31:0]	A, B;
	 input			ctrl;
	 output [31:0]	S;

	wire [31:0]	ta, tb;
	AND32_2 a1(ta, A, {32{~ctrl}});
	AND32_2 a2(tb, B, {32{ ctrl}});
	OR32_2  o1(S, ta, tb);
endmodule

// 32 bits mux 4 - 1
module MUX32_4_1(S, ctrl, A, B, C, D);
    input[31:0]	A, B, C, D;
	 input[1:0]		ctrl;
	 output [31:0]	S;

	wire[31:0]	ta, tb, tc, td;
	AND32_3 a31(ta, A, {32{~ctrl[1]}}, {32{~ctrl[0]}});
	AND32_3 a32(tb, B, {32{~ctrl[1]}}, {32{ ctrl[0]}});
	AND32_3 a33(tc, C, {32{ ctrl[1]}}, {32{~ctrl[0]}});
	AND32_3 a34(td, D, {32{ ctrl[1]}}, {32{ ctrl[0]}});
	OR32_4 o1(S, ta, tb, tc, td);
endmodule

// 16 bits and gate, 2 channels
module AND16_2(S, A, B);
    input [15:0]		A, B;
    output [15:0]		S;

	and(S[ 0], A[ 0], B[ 0]);
	and(S[ 1], A[ 1], B[ 1]);
	and(S[ 2], A[ 2], B[ 2]);
	and(S[ 3], A[ 3], B[ 3]);
	and(S[ 4], A[ 4], B[ 4]);
	and(S[ 5], A[ 5], B[ 5]);
	and(S[ 6], A[ 6], B[ 6]);
	and(S[ 7], A[ 7], B[ 7]);
	and(S[ 8], A[ 8], B[ 8]);
	and(S[ 9], A[ 9], B[ 9]);
	and(S[10], A[10], B[10]);
	and(S[11], A[11], B[11]);
	and(S[12], A[12], B[12]);
	and(S[13], A[13], B[13]);
	and(S[14], A[14], B[14]);
	and(S[15], A[15], B[15]);
endmodule

// 32 bits and gate, 2 channels
module AND32_2(S, A, B);
    input [31:0]		A, B;
    output [31:0]		S;

	and(S[ 0], A[ 0], B[ 0]);
	and(S[ 1], A[ 1], B[ 1]);
	and(S[ 2], A[ 2], B[ 2]);
	and(S[ 3], A[ 3], B[ 3]);
	and(S[ 4], A[ 4], B[ 4]);
	and(S[ 5], A[ 5], B[ 5]);
	and(S[ 6], A[ 6], B[ 6]);
	and(S[ 7], A[ 7], B[ 7]);
	and(S[ 8], A[ 8], B[ 8]);
	and(S[ 9], A[ 9], B[ 9]);
	and(S[10], A[10], B[10]);
	and(S[11], A[11], B[11]);
	and(S[12], A[12], B[12]);
	and(S[13], A[13], B[13]);
	and(S[14], A[14], B[14]);
	and(S[15], A[15], B[15]);
	and(S[16], A[16], B[16]);
	and(S[17], A[17], B[17]);
	and(S[18], A[18], B[18]);
	and(S[19], A[19], B[19]);
	and(S[20], A[20], B[20]);
	and(S[21], A[21], B[21]);
	and(S[22], A[22], B[22]);
	and(S[23], A[23], B[23]);
	and(S[24], A[24], B[24]);
	and(S[25], A[25], B[25]);
	and(S[26], A[26], B[26]);
	and(S[27], A[27], B[27]);
	and(S[28], A[28], B[28]);
	and(S[29], A[29], B[29]);
	and(S[30], A[30], B[30]);
	and(S[31], A[31], B[31]);
endmodule

// 32 bits and gate, 3 channels
module AND32_3(S, A, B, C);
    input [31:0]		A, B, C;
    output [31:0]		S;

	and(S[ 0], A[ 0], B[ 0], C[ 0]);
	and(S[ 1], A[ 1], B[ 1], C[ 1]);
	and(S[ 2], A[ 2], B[ 2], C[ 2]);
	and(S[ 3], A[ 3], B[ 3], C[ 3]);
	and(S[ 4], A[ 4], B[ 4], C[ 4]);
	and(S[ 5], A[ 5], B[ 5], C[ 5]);
	and(S[ 6], A[ 6], B[ 6], C[ 6]);
	and(S[ 7], A[ 7], B[ 7], C[ 7]);
	and(S[ 8], A[ 8], B[ 8], C[ 8]);
	and(S[ 9], A[ 9], B[ 9], C[ 9]);
	and(S[10], A[10], B[10], C[10]);
	and(S[11], A[11], B[11], C[11]);
	and(S[12], A[12], B[12], C[12]);
	and(S[13], A[13], B[13], C[13]);
	and(S[14], A[14], B[14], C[14]);
	and(S[15], A[15], B[15], C[15]);
	and(S[16], A[16], B[16], C[16]);
	and(S[17], A[17], B[17], C[17]);
	and(S[18], A[18], B[18], C[18]);
	and(S[19], A[19], B[19], C[19]);
	and(S[20], A[20], B[20], C[20]);
	and(S[21], A[21], B[21], C[21]);
	and(S[22], A[22], B[22], C[22]);
	and(S[23], A[23], B[23], C[23]);
	and(S[24], A[24], B[24], C[24]);
	and(S[25], A[25], B[25], C[25]);
	and(S[26], A[26], B[26], C[26]);
	and(S[27], A[27], B[27], C[27]);
	and(S[28], A[28], B[28], C[28]);
	and(S[29], A[29], B[29], C[29]);
	and(S[30], A[30], B[30], C[30]);
	and(S[31], A[31], B[31], C[31]);
endmodule

// 16 bits or gate, 2 channels
module OR16_2(S, A, B);
    input [15:0]		A, B;
    output [15:0]		S;

	or(S[ 0], A[ 0], B[ 0]);
	or(S[ 1], A[ 1], B[ 1]);
	or(S[ 2], A[ 2], B[ 2]);
	or(S[ 3], A[ 3], B[ 3]);
	or(S[ 4], A[ 4], B[ 4]);
	or(S[ 5], A[ 5], B[ 5]);
	or(S[ 6], A[ 6], B[ 6]);
	or(S[ 7], A[ 7], B[ 7]);
	or(S[ 8], A[ 8], B[ 8]);
	or(S[ 9], A[ 9], B[ 9]);
	or(S[10], A[10], B[10]);
	or(S[11], A[11], B[11]);
	or(S[12], A[12], B[12]);
	or(S[13], A[13], B[13]);
	or(S[14], A[14], B[14]);
	or(S[15], A[15], B[15]);
endmodule

// 32 bits or gate, 2 channels
module OR32_2(S, A, B);
    input [31:0]		A, B;
    output [31:0]		S;

	or(S[ 0], A[ 0], B[ 0]);
	or(S[ 1], A[ 1], B[ 1]);
	or(S[ 2], A[ 2], B[ 2]);
	or(S[ 3], A[ 3], B[ 3]);
	or(S[ 4], A[ 4], B[ 4]);
	or(S[ 5], A[ 5], B[ 5]);
	or(S[ 6], A[ 6], B[ 6]);
	or(S[ 7], A[ 7], B[ 7]);
	or(S[ 8], A[ 8], B[ 8]);
	or(S[ 9], A[ 9], B[ 9]);
	or(S[10], A[10], B[10]);
	or(S[11], A[11], B[11]);
	or(S[12], A[12], B[12]);
	or(S[13], A[13], B[13]);
	or(S[14], A[14], B[14]);
	or(S[15], A[15], B[15]);
	or(S[16], A[16], B[16]);
	or(S[17], A[17], B[17]);
	or(S[18], A[18], B[18]);
	or(S[19], A[19], B[19]);
	or(S[20], A[20], B[20]);
	or(S[21], A[21], B[21]);
	or(S[22], A[22], B[22]);
	or(S[23], A[23], B[23]);
	or(S[24], A[24], B[24]);
	or(S[25], A[25], B[25]);
	or(S[26], A[26], B[26]);
	or(S[27], A[27], B[27]);
	or(S[28], A[28], B[28]);
	or(S[29], A[29], B[29]);
	or(S[30], A[30], B[30]);
	or(S[31], A[31], B[31]);
endmodule

// 32 bits or gate, 4 channels
module OR32_4(S, A, B, C, D);
    input [31:0]		A, B, C, D;
    output [31:0]		S;

	or(S[ 0], A[ 0], B[ 0], C[ 0], D[ 0]);
	or(S[ 1], A[ 1], B[ 1], C[ 1], D[ 1]);
	or(S[ 2], A[ 2], B[ 2], C[ 2], D[ 2]);
	or(S[ 3], A[ 3], B[ 3], C[ 3], D[ 3]);
	or(S[ 4], A[ 4], B[ 4], C[ 4], D[ 4]);
	or(S[ 5], A[ 5], B[ 5], C[ 5], D[ 5]);
	or(S[ 6], A[ 6], B[ 6], C[ 6], D[ 6]);
	or(S[ 7], A[ 7], B[ 7], C[ 7], D[ 7]);
	or(S[ 8], A[ 8], B[ 8], C[ 8], D[ 8]);
	or(S[ 9], A[ 9], B[ 9], C[ 9], D[ 9]);
	or(S[10], A[10], B[10], C[10], D[10]);
	or(S[11], A[11], B[11], C[11], D[11]);
	or(S[12], A[12], B[12], C[12], D[12]);
	or(S[13], A[13], B[13], C[13], D[13]);
	or(S[14], A[14], B[14], C[14], D[14]);
	or(S[15], A[15], B[15], C[15], D[15]);
	or(S[16], A[16], B[16], C[16], D[16]);
	or(S[17], A[17], B[17], C[17], D[17]);
	or(S[18], A[18], B[18], C[18], D[18]);
	or(S[19], A[19], B[19], C[19], D[19]);
	or(S[20], A[20], B[20], C[20], D[20]);
	or(S[21], A[21], B[21], C[21], D[21]);
	or(S[22], A[22], B[22], C[22], D[22]);
	or(S[23], A[23], B[23], C[23], D[23]);
	or(S[24], A[24], B[24], C[24], D[24]);
	or(S[25], A[25], B[25], C[25], D[25]);
	or(S[26], A[26], B[26], C[26], D[26]);
	or(S[27], A[27], B[27], C[27], D[27]);
	or(S[28], A[28], B[28], C[28], D[28]);
	or(S[29], A[29], B[29], C[29], D[29]);
	or(S[30], A[30], B[30], C[30], D[30]);
	or(S[31], A[31], B[31], C[31], D[31]);
endmodule

// 32 bits xor gate, 2 channels
module XOR32_2(S, A, B);
    input [31:0]		A, B;
    output [31:0]		S;

	xor(S[ 0], A[ 0], B[ 0]);
	xor(S[ 1], A[ 1], B[ 1]);
	xor(S[ 2], A[ 2], B[ 2]);
	xor(S[ 3], A[ 3], B[ 3]);
	xor(S[ 4], A[ 4], B[ 4]);
	xor(S[ 5], A[ 5], B[ 5]);
	xor(S[ 6], A[ 6], B[ 6]);
	xor(S[ 7], A[ 7], B[ 7]);
	xor(S[ 8], A[ 8], B[ 8]);
	xor(S[ 9], A[ 9], B[ 9]);
	xor(S[10], A[10], B[10]);
	xor(S[11], A[11], B[11]);
	xor(S[12], A[12], B[12]);
	xor(S[13], A[13], B[13]);
	xor(S[14], A[14], B[14]);
	xor(S[15], A[15], B[15]);
	xor(S[16], A[16], B[16]);
	xor(S[17], A[17], B[17]);
	xor(S[18], A[18], B[18]);
	xor(S[19], A[19], B[19]);
	xor(S[20], A[20], B[20]);
	xor(S[21], A[21], B[21]);
	xor(S[22], A[22], B[22]);
	xor(S[23], A[23], B[23]);
	xor(S[24], A[24], B[24]);
	xor(S[25], A[25], B[25]);
	xor(S[26], A[26], B[26]);
	xor(S[27], A[27], B[27]);
	xor(S[28], A[28], B[28]);
	xor(S[29], A[29], B[29]);
	xor(S[30], A[30], B[30]);
	xor(S[31], A[31], B[31]);
endmodule



