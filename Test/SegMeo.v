`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chris Cheng
// 
// Create Date:    11:30:53 05/20/2014 
// Design Name: 
// Module Name:    SegMod 
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
module SegMod(
    input clk,
    input rst,
    input[15:0] num,
    output reg [3:0] an,
    output reg [7:0] seg
    );

    reg [1:0] sel;
    reg [3:0] temp;
    reg [15:0] counter;
    
    //display delay
    always@(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            sel <= 2'b00;
            counter <= 16'b0;
        end
        else
        begin
            counter <= counter + 1;
            if(counter == 16'hffff)
            begin
                counter <= 16'b0;
                sel <= sel + 2'b01;
            end
        end
    end
    
    always@(*)
    begin
        case(sel)
            2'b11:
                begin
                    an <= 4'b0111;
                    temp <= num[15:12];
                end
            2'b10:
                begin
                    an <= 4'b1011;
                    temp <= num[11:8];
                end
            2'b01:
                begin
                    an <= 4'b1101;
                    temp <= num[7:4];
                end
            2'b00:
                begin
                    an <= 4'b1110;
                    temp <= num[3:0];
                end
            default:;
        endcase
        
        case(temp)
            4'b0000: seg <= 8'b1100_0000;
            4'b0001: seg <= 8'b1111_1001;
            4'b0010: seg <= 8'b1010_0100;
            4'b0011: seg <= 8'b1011_0000;
            4'b0100: seg <= 8'b1001_1001;
            4'b0101: seg <= 8'b1001_0010;
            4'b0110: seg <= 8'b1000_0010;
            4'b0111: seg <= 8'b1111_1000;
            4'b1000: seg <= 8'b1000_0000;
            4'b1001: seg <= 8'b1001_0000;
            4'b1010: seg <= 8'b1000_1000;
            4'b1011: seg <= 8'b1000_0011;
            4'b1100: seg <= 8'b1100_0110;
            4'b1101: seg <= 8'b1010_0001;
            4'b1110: seg <= 8'b1000_0110;
            4'b1111: seg <= 8'b1000_1110;
            default: seg <= 8'b1111_1111;
        endcase
    end
    
endmodule
