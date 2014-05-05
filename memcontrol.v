/*
*	MIPS CPU Memory Control
*
*	
*
*
*	Chris Cheng
*	2014-5-5
*
***/
`ifndef MIPS_PARA

`include "cpu_para.v"

`endif

module MemControl(
	/**********  Input ***********/
	input  clk,
    input  rst,
    input  [`DP_WIDTH:0] DataFromCPU,           // Data from CPU
    input  [`DP_WIDTH:0] Address,          // From CPU
    input  [`DP_WIDTH:0] DataFromMem,        // Data from Memory
    input  MemReadFromCPU,                 // Memory Read command from CPU
    input  MemWriteFromCPU,                // Memory Write command from CPU
    input  MemReadyFromMem,           // Ready signal from Memory, 0 - ready
    input  Byte,                    // Load/Store is Byte (8-bit)
    input  Half,                    // Load/Store is Half (16-bit)
    input  SignExt,              // Sub-word load should be sign extended
    input  IF_Stall,                // XXX Clean this up between this module and HAZ/FWD

    /**********  Output ***********/
    output reg [`DP_WIDTH:0] DataToCPU,      // Data to CPU
    output [`DP_WIDTH:0] DataToMem,       // Data to Memory
    output reg[3:0] WriteEnable,   // Write Enable to Memory for each of 4 bytes of Memory
    output ReadEnable,              // Read Enable to Memory
    output MEM_Stall
    );
    
    /*** Indicator that the current memory reference must be word-aligned ***/
    wire Word = ~(Half | Byte);
    
    reg RW_Mask;
    always @(posedge clk) begin
        RW_Mask <= (rst) ? 0 : (((MemWriteFromCPU | MemReadFromCPU) & MemReadyFromMem) ? 1 : ((~MEM_Stall & ~IF_Stall) ? 0 : RW_Mask));
    end

    assign MEM_Stall = ReadEnable | (WriteEnable != 4'b0000) | MemReadyFromMem;
    assign ReadEnable  = MemReadFromCPU  & ~RW_Mask;
    
    wire Half_Access_L  = Address[1];
    wire Half_Access_R  = ~Address[1];
    wire Byte_Access_LL = Half_Access_L & Address[0];
    wire Byte_Access_LM = Half_Access_L & ~Address[0];
    wire Byte_Access_RM = Half_Access_R & Address[0];
    wire Byte_Access_RR = Half_Access_R & ~Address[0];
    
    // Write-Enable Signals to Memory
    always @(*) begin
        if (MemWriteFromCPU & ~RW_Mask) begin
            if (Byte)
            begin
                WriteEnable[3] <= Byte_Access_LL;
                WriteEnable[2] <= Byte_Access_LM;
                WriteEnable[1] <= Byte_Access_RM;
                WriteEnable[0] <= Byte_Access_RR;
            end
            else if (Half)
            begin
                WriteEnable[3] <= Half_Access_L;
                WriteEnable[2] <= Half_Access_L;
                WriteEnable[1] <= Half_Access_R;
                WriteEnable[0] <= Half_Access_R;
            end
            else
            begin
                WriteEnable <= 4'b1111;
            end
        end
        else
        begin
            WriteEnable <= 4'b0000;
        end
    end
    
    // Data Going to Memory
    assign DataToMem[31:24] = (Byte) ? DataFromCPU[7:0] : ((Half) ? DataFromCPU[15:8] : DataFromCPU[31:24]);
    assign DataToMem[23:16] = (Byte | Half) ? DataFromCPU[7:0] : DataFromCPU[23:16];
    assign DataToMem[15:8]  = (Byte) ? DataFromCPU[7:0] : DataFromCPU[15:8];
    assign DataToMem[7:0]   = DataFromCPU[7:0];
    
    // Data Read from Memory
    always @(*)
    begin
        if (Byte)
        begin
            if (Byte_Access_LL)
            begin
                DataToCPU <= (SignExt & DataFromMem[31]) ? {24'hFFFFFF, DataFromMem[31:24]} : {24'h000000, DataFromMem[31:24]};
            end
            else if (Byte_Access_LM)
            begin
                DataToCPU <= (SignExt & DataFromMem[23]) ? {24'hFFFFFF, DataFromMem[23:16]} : {24'h000000, DataFromMem[23:16]};
            end
            else if (Byte_Access_RM)
            begin
                DataToCPU <= (SignExt & DataFromMem[15]) ? {24'hFFFFFF, DataFromMem[15:8]}  : {24'h000000, DataFromMem[15:8]};
            end
            else
            begin
                DataToCPU <= (SignExt & DataFromMem[7])  ? {24'hFFFFFF, DataFromMem[7:0]}   : {24'h000000, DataFromMem[7:0]};
            end
        end
        else if (Half)
        begin
            if (Half_Access_L)
            begin
                DataToCPU <= (SignExt & DataFromMem[31]) ? {16'hFFFF, DataFromMem[31:16]} : {16'h0000, DataFromMem[31:16]};
            end
            else 
            begin
                DataToCPU <= (SignExt & DataFromMem[15]) ? {16'hFFFF, DataFromMem[15:0]}  : {16'h0000, DataFromMem[15:0]};
            end
        end
        else
        begin
            DataToCPU <= DataFromMem;
        end
    end
endmodule