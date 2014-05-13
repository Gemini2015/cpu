/*
*	Control test driver
*
*
*	Chris Cheng
*	2014-5-13
*
***/
`timescale 1ns / 1ps

`ifndef MIPS_PARA

`include "cpu_para.v"

`endif

`include "hazard.v"

module testHazard;
	
	reg [`HAZARD_WIDTH - 1:0] DP_Hazards;
	reg [`REG_WIDTH - 1:0] ID_Rs, ID_Rt, EX_Rs, EX_Rt, EX_RtRd, MEM_RtRd, WB_RtRd;
	reg EX_Link, EX_RegWrite, MEM_RegWrite, WB_RegWrite, MEM_MemRead, MEM_MemWrite;
	reg InstMem_Read, InstMem_Ready, MEM_Stall_Controller;

	wire IF_Stall, ID_Stall, EX_Stall, MEM_Stall, MEM_WriteDataFwdSel;
	wire [1:0] ID_RsFwdSel, ID_RtFwdSel, EX_RsFwdSel, EX_RtFwdSel;

	Hazard_Detection hazard_Detection(
		.DP_Hazards(DP_Hazards),
		.ID_Rs(ID_Rs),
		.ID_Rt(ID_Rt),
		.EX_Rs(EX_Rs),
		.EX_Rt(EX_Rt),
		.EX_RtRd(EX_RtRd),
		.MEM_RtRd(MEM_RtRd),
		.WB_RtRd(WB_RtRd),
		.EX_Link(EX_Link),
		.EX_RegWrite(EX_RegWrite),
		.MEM_RegWrite(MEM_RegWrite),
		.WB_RegWrite(WB_RegWrite),
		.MEM_MemRead(MEM_MemRead),
		.MEM_MemWrite(MEM_MemWrite),
		.InstMem_Read(InstMem_Read),
		.InstMem_Ready(InstMem_Ready),
		.MEM_Stall_Controller(MEM_Stall_Controller),

		.IF_Stall(IF_Stall),
		.ID_Stall(ID_Stall),
		.EX_Stall(EX_Stall),
		.MEM_Stall(MEM_Stall),
		.WB_Stall(WB_Stall),
		.ID_RsFwdSel(ID_RsFwdSel),
		.ID_RtFwdSel(ID_RtFwdSel),
		.EX_RsFwdSel(EX_RsFwdSel),
		.EX_RtFwdSel(EX_RtFwdSel),
		.MEM_WriteDataFwdSel(MEM_WriteDataFwdSel)
		);

	initial
	begin
		// test add hazard
		/* 
			add $1,$2,$3 	-> EX stage finish, all data store to EXEMEM stage regs in the next clk
							-> MEM_RtRd: 1, MEM_RegWrite: 1;

			add $4,$1,$3 	-> ID stage finish, all data store to IDEXE stage regs in the next clk
							-> EX_Rs: 1, EX_Rt: 3, DP_Hazard = HZ_Add;

			solution: forwarding -> MEM_ALU_Result to ID_ReadData1_End(replace Rs read from regfile )
		*/
		DP_Hazards <= HZ_Add;
		ID_Rs <= 0;
		ID_Rt <= 0;
		MEM_RtRd <= 1;
		MEM_RegWrite <= 1;
		EX_Rs <= 1; EX_Rt <= 3;
		EX_RtRd <= 4; WB_RtRd <= 0; EX_Link <= 0; EX_RegWrite <= 1; WB_RegWrite <= 0;
		MEM_MemRead <= 0; MEM_MemWrite <= 0; InstMem_Read <= 0; InstMem_Ready <= 0; MEM_Stall_Controller <= 0;
	#50	//test lw hazard
		/*
			lw $1,$2 		-> EX stage finish, all data store to EXEMEM stage regs in the next clk
							-> need access read memory
							-> MEM_RtRd: 1, MEM_MemRead: 1, MEM_Stall_Controller: 0;
			add $2,$1,$3 	-> ID stage finish, all data store to IDEXE stage regs in the next clk
							-> current: EX_Rs: 1, EX_Rt: 3, DP_Hazard = HZ_Add;
		*/
		DP_Hazards <= HZ_Add;
		ID_Rs <= 0;
		ID_Rt <= 0;
		MEM_RtRd <= 1;
		MEM_RegWrite <= 1;
		MEM_MemRead <= 1;
		EX_Rs <= 1; EX_Rt <= 3;
		EX_RtRd <= 2; WB_RtRd <= 0; EX_Link <= 0; EX_RegWrite <= 1; WB_RegWrite <= 0;
		MEM_MemWrite <= 0; InstMem_Read <= 0; InstMem_Ready <= 0; MEM_Stall_Controller <= 0;
	#50;
	end

endmodule