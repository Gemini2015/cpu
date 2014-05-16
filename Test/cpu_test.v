/*
*   CPU test driver
*
*
*   Chris Cheng
*   2014-5-14
*
***/
`timescale 1ns/1ps



module testCPU;
    
    // Clock signals
    reg clocksrc;
    wire clock1x, clock2x;
    wire PLL_Locked;
    
    reg reset;
    always @(posedge clocksrc) begin
        reset <= ~PLL_Locked;
    end
    
    // MIPS Processor Signals
    wire [31:0] DataMem_In;
    wire [31:0] DataMem_Out, InstMem_In;
    wire [29:0] DataMem_Address, InstMem_Address;
    wire [3:0]  DataMem_WE;
    wire        DataMem_Read, InstMem_Read;
    wire        InstMem_Ready, DataMem_Ready;

    // Clock Generation
    clock Clock_Generator (
        .CLK_IN1        (clocksrc),
        .RESET          (1'b0),
        .CLK_OUT1   (clock1x), 
        .CLK_OUT2   (clock2x),
        .LOCKED     (PLL_Locked)
    );

    // MIPS-32 Core
    Processor MIPS32 (
        .clk            (clock1x),
        .rst            (reset),
        .DataMem_In       (DataMem_In),
        .DataMem_Ready    (DataMem_Ready),
        .DataMem_Read     (DataMem_Read),
        .DataMem_Write    (DataMem_WE),
        .DataMem_Address  (DataMem_Address),
        .DataMem_Out      (DataMem_Out),
        .InstMem_In       (InstMem_In),
        .InstMem_Address  (InstMem_Address),
        .InstMem_Ready    (InstMem_Ready),
        .InstMem_Read     (InstMem_Read)
    );

    // On-Chip Block RAM
    // InstMem and DataMem adapter
    MemAdapter memadapter(
        .clk    (clock2x),
        .rst    (reset),
        //inst
        .rea      (InstMem_Read),
        .wea      (4'b0000),
        .addra    (InstMem_Address[6:0]),
        .dina     (32'h0000_0000),
        .douta    (InstMem_In),
        .dreadya  (InstMem_Ready),
        //data
        .reb      (DataMem_Read),
        .web      (DataMem_WE),
        .addrb    (DataMem_Address[6:0]),
        .dinb     (DataMem_Out),
        .doutb    (DataMem_In),
        .dreadyb  (DataMem_Ready)
    );

    
    reg i;
    initial begin
        // Initialize Inputs
        clocksrc = 0;
        
        // Wait 100 ns for global reset to finish
        #50;
        
        // Add stimulus here
        for (i=0; i<1000; i=i+1) begin
            reset = (i < 28) ? 0 : 1;
            clocksrc = ~clocksrc;
            #5;
        end
    end
endmodule
