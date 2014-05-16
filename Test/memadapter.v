`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chris Cheng
// 
// Create Date:    10:36:33 05/14/2014 
// Design Name: 
// Module Name:    DataMemAdapter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module MemAdapter(
	input clk,
	input rst,
	//instruction
	input rea,
	input [3:0] wea,
	input [6:0] addra,
	input [31:0] dina,
	output [31:0] douta,
	output reg dreadya,
	//data
	input reb,
	input [3:0] web,
	input [6:0] addrb,
	input [31:0] dinb,
	output [31:0] doutb,
	output reg dreadyb
    );
	
	reg [1:0] delay_A,delay_B;
	
	always @(posedge clk)
	begin
		delay_A <= (rst | ~rea) ? 2'b00 : ((delay_A == 2'b01) ? delay_A : delay_A + 1);
		delay_B <= (rst | ~reb) ? 2'b00 : ((delay_B == 2'b10) ? delay_B : delay_B + 1);
	end
	
	// in ISE with iSim, it must be 2b'01
	always @(posedge clk)
	begin
		dreadya <= (rst) ? 0 : ((wea != 4'b0000) || ((delay_A != 2'b01) && rea)) ? 1 : 0;
		dreadyb <= (rst) ? 0 : ((web != 4'b0000) || ((delay_B != 2'b10) && reb)) ? 1 : 0;
	end
	
	dataMem datamem(
		.clka(clk),
		.rsta(rst),
		.wea(web),
		.addra(addrb),
		.dina(dinb),
		.douta(doutb)
		);
	
	InstMem instmem(
		.clka(clk),
		.rsta(rst),
		.wea(wea),
		.addra(addra),
		.dina(dina),
		.douta(douta)
		);
	
endmodule
