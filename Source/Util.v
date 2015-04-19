`timescale 1ns / 1ps

module Mux32_4_1(
	input[1:0] sel,
	input[31:0] in0, in1, in2, in3,
	output reg[31:0] out
);

	always @(*)
	begin
		case(sel)
			2'b00: out <= in0;
			2'b01: out <= in1;
			2'b10: out <= in2;
			2'b11: out <= in3;
		endcase
	end
endmodule

module Mux32_2_1(
	input sel,
	input[31:0] in0, in1,
	output reg[31:0] out
);

	always @(*)
	begin
		case(sel)
			2'b0: out <= in0;
			2'b1: out <= in1;
		endcase
	end
endmodule


module Adder32_2_1(
	input[31:0] in0,
	input[31:0] in1,
	output[31:0] out
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

