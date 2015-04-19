`timescale 1ns / 1ps

module RegFile(
	input clk,
	input rst,
	input[4:0] regA, regB, regW,
	input[31:0] writeData,
	input WE,
	output[31:0] aData,
	output[31:0] bData
);

	reg[31:0] RegArray[31:1];

	assign aData = (regA ==0) ? 32'h0000_0000 : RegArray[regA];
	assign bData = (regB ==0) ? 32'h0000_0000 : RegArray[regB];

	integer i;
	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for (i = 1; i < 32; i = i +1)
			begin
				RegArray[i] <= 0;
			end
		end
		else
		begin
			if(regW != 0)
				RegArray[regW] <= (WE) ? writeData : RegArray[regW];
		end
	end

	initial
	begin
		for(i = 1; i < 32; i = i + 1)
		begin
			RegArray[i] <= 0;
		end
	end

endmodule


// single 32 bits reg
module Register(
	input clk,
	input rst,
	input writeEnable,
	input[31:0] in,
	output reg[31:0] out
);

    initial
		out = 0;

    always @(posedge clk or posedge rst)
	begin
        if(rst)
			out <= 0;
        else
		begin
            if(WE) out <= in;
            else out <= out;
        end
    end
endmodule

