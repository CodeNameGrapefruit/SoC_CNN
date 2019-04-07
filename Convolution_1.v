`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Convolution with Lapcian Filter and Adders
//////////////////////////////////////////////////////////////////////////////////

module Convolution_1(
    input clk,
    input enable,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [7:0] in4,
    input [7:0] in5,
    input [7:0] in6,
    input [7:0] in7,
    input [7:0] in8,
    input [7:0] in9,
    output signed [7:0] final,
    output finished_con1
);

    reg signed [7:0] out1;
    reg signed [7:0] out2; 
    reg signed [7:0] out3; 
    reg signed [7:0] out4; 
    reg signed [7:0] out5; 
    reg signed [7:0] out6; 
    reg signed [7:0] out7; 
    reg signed [7:0] out8;
    reg signed [7:0] out9;
/*
Laplacian Filter to be used as Kernel/Filter
|  0  -1  0 |
| -1  4  -1 |
|  0  -1  0 |
9 convolutions must be performed
*/

    always@(posedge clk)
        begin
            if(enable)
                begin
                    out1 <= 0; //Multiply by 0
                    out2 <= in2 * 4'b1111; //Multiply by -1
                    out3 <= 0; //Multiply by 0
                    out4 <= in4 * 4'b1111; //Multiply by -1
                    out5 <= in5 * 4'b0100; //Multiply by 4
                    out6 <= in6 * 4'b1111; //Multiply by -1
                    out7 <= 0; //Multiply by 0
                    out8 <= in8 * 4'b1111; //Multiply by -1
                    out9 <= 0; //Multiply by 0
                end
            else
                begin
                    out1 <= 0;
                    out2 <= 0;
                    out3 <= 0;
                    out4 <= 0;
                    out5 <= 0;
                    out6 <= 0;
                    out7 <= 0;
                    out8 <= 0;
                    out9 <= 0;
                end
        end
        
        addr1 A1 (clk,enable,out2,out4,out5,out6,out8,final,finished_con1);
        
endmodule


module addr1(
    input clk,
    input enable,
    input signed [7:0] in2,
    input signed [7:0] in4,
    input signed [7:0] in5,
    input signed [7:0] in6,
    input signed [7:0] in8,
    output reg  signed [7:0] sum1,
    output reg finished 
);

//Remove Inputs that are 0 since adding them wont make a difference
//Add up all values from convolution

    always@(posedge clk)
        begin
            if(enable)
                begin
                    sum1 <= (in2 + in4 + in5 + in6 + in8);
                    finished <= 1'b1;
                end
            else
                begin
                    sum1 <= 0;
                    finished <= 1'b1;
                end
        end
endmodule
