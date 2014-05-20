`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chris Cheng
// 
// Create Date:    11:06:58 05/20/2014 
// Design Name: 
// Module Name:    testFPGA 
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
module testFPGA(
    input clk,
    //input mclk,
    input rst,
    input [7:0] sw,
    //input [4:0] btn,
    output [7:0] Led,
    output [7:0] seg,
    output [3:0] an
    );
    
    assign Led = sw;
    
    wire [31:0] DataMem_In;
    wire [31:0] DataMem_Out, InstMem_In;
    wire [29:0] DataMem_Address, InstMem_Address;
    wire [3:0]  DataMem_WE;
    wire        DataMem_Read, InstMem_Read;
    wire        InstMem_Ready, DataMem_Ready;
    
    reg [15:0] clk_cnt1;
    reg [16:0] clk_cnt2;
    
    //wire start;
    //assign start = sw[7];
    
    //wire MemReg;
    //assign MemReg = sw[6];
    
    wire [4:0] DisReg;
    assign DisReg[4:0] = sw[4:0];
    
    wire [31:0] DisRegData;
    
    reg clock1x,clock2x;
    
    always@(posedge clk or posedge rst)
    begin
        if(rst == 1)
        begin
            clk_cnt1 <= 0;
            clk_cnt2 <= 0;
            clock1x <= 0;
            clock2x <= 0;
        end
        else
        begin
            if(sw[7] == 1)
            begin
                if(clk_cnt1 == 16'hffff)
                begin
                    clk_cnt1 <= 0;
                    clock2x <= ~clock2x;
                end
                else
                begin
                    clk_cnt1 <= clk_cnt1 + 1;
                end
                
                if(clk_cnt2 == 17'h1_ffff)
                begin
                    clk_cnt2 <= 0;
                    clock1x <= ~clock1x;
                end
                else
                begin
                    clk_cnt2 <= clk_cnt2 + 1;
                end
            end
            else
            begin
                clk_cnt1 <= 0;
                clk_cnt2 <= 0;
                /*
                if(clk_cnt1 == 2'b11)
                begin
                    clk_cnt1 <= 0;
                    clock2x <= !(clock2x);
                end
                else
                begin
                    clk_cnt1 <= clk_cnt1 + 1;
                end
                */
                //clk_cnt2 <= 0;
                
                /*
                if(mclk == 1)
                begin
                    clock2x <= ! clock2x;
                    if(clock2x == 1'b0)
                    begin
                        clock1x <= ! clock1x;
                    end
                end
                */
            end
        end
    end
    
    // MIPS-32 Core
    Processor MIPS32 (
        .clk            (clock1x),
        .rst            (rst),
        
        //for test
        .DisReg         (DisReg),
        .DisRegData     (DisRegData),
        
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
    
    //for test
    // Mem address
    //assign DataMem_Address = start ? CPUDataMem_Address : MemReg ? {24'b0, sw[4:0]} : 29'b0;
    //assign DataMem_Read = start ? CPUDataMem_Read : MemReg ? 1'b1 : 1'b0;
    //assign DisRegData = MemReg ? DataMem_In : CPUDisRegData;
    
    // On-Chip Block RAM
    //MEM_592KB_Wrapper Memory (
    MemAdapter memadapter(
        .clk    (clock2x),
        .rst    (rst),
        //inst
        .rea      (InstMem_Read),
        .wea      (4'b0000),
        .addra    (InstMem_Address[6:0]),
        .dina     (32'h0000_0000),
        .douta    (InstMem_In),
        .dreadya  (InstMem_Ready),
        //.InstMem_Stall(InstMem_Stall),
        //data
        .reb      (DataMem_Read),
        .web      (DataMem_WE),
        .addrb    (DataMem_Address[6:0]),
        .dinb     (DataMem_Out),
        .doutb    (DataMem_In),
        .dreadyb  (DataMem_Ready)
    );

    SegMod segmod(
        .clk(clk),
        .rst(rst),
        .num(DisRegData[15:0]),
        .an(an),
        .seg(seg)
        );

endmodule


