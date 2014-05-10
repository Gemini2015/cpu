/*
*
*	Register File & Register
*
*	32 bits Reg Array
*
*
*	Chris Cheng
*	2014-4-9
*
***/

/* 	
*	reg file
*	32 regs
*
*	read: 	regA -> Adat, 
*			regB -> Bdat,
*			regC -> Cdat
*
*	write:	regW -> Wdat
*	writeEnable: RegWrite
*
*/
module RegFile(clk, rst, regA, regB, regW, Wdat, RegWrite, Adat, Bdat);
	
	input clk, rst, RegWrite;
   	input [4:0] regA, regB, regW;
   	input [31:0] Wdat;
   	output [31:0] Adat, Bdat;

   	reg [31:0] iRegf[31:1];
   	integer i;

	assign Adat = (regA == 0) ? 32'h0000_0000 : iRegf[regA];
	assign Bdat = (regB == 0) ? 32'h0000_0000 : iRegf[regB];

	initial 
	begin
		for (i = 1; i < 32; i = i + 1)
		begin
			iRegf[i] <= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			// reset reg file
			for (i=1; i<32; i=i+1) begin
                iRegf[i] <= 0;
            end
		end
		else 
		begin
			if (regW != 0)
				iRegf[regW] <= (RegWrite) ? Wdat : iRegf[regW];
		end
	end
endmodule

// single 32 bits reg
module Register(clk, rst, RegWrite, idat, odat);
	input	clk, rst, RegWrite;
	input[31:0]		idat;
	output[31:0]	odat;
	reg[31:0]		odat;

	initial
		odat = 0;

	always @(posedge clk) begin
		if(rst) odat <= 0;
		else begin 
			if(RegWrite) odat <= idat;
			else odat <= odat;
		end
	end
endmodule