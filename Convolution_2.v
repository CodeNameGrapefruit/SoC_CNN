`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Convolution of Both Images
//////////////////////////////////////////////////////////////////////////////////

module Convolution_2(
    input clk,
    input enable,
    
    input signed [7:0] in1,
    input signed [7:0] in2,
    input signed [7:0] in3,
    input signed [7:0] in4,
    input signed [7:0] in5,
    input signed [7:0] in6,
    input signed [7:0] in7,
    input signed [7:0] in8,
    input signed [7:0] in9,
    
    input signed [7:0] in10,
    input signed [7:0] in11,
    input signed [7:0] in12,
    input signed [7:0] in13,
    input signed [7:0] in14,
    input signed [7:0] in15,
    input signed [7:0] in16,
    input signed [7:0] in17,
    input signed [7:0] in18,
   
    output signed [15:0] final,
    output finished_con2
);

    reg signed [15:0] out1;
    reg signed [15:0] out2; 
    reg signed [15:0] out3; 
    reg signed [15:0] out4; 
    reg signed [15:0] out5; 
    reg signed [15:0] out6;
    reg signed [15:0] out7; 
    reg signed [15:0] out8; 
    reg signed [15:0] out9;  

    always@(posedge clk)
        begin
            if(enable)
                begin
                    out1 <= (in1 * in10);
                    out2 <= (in2 * in11);
                    out3 <= (in3 * in12);
                    out4 <= (in4 * in13);
                    out5 <= (in5 * in14);
                    out6 <= (in6 * in15);
                    out7 <= (in7 * in16);
                    out8 <= (in8 * in17);
                    out9 <= (in9 * in18);
                end
        end
        
        addr2 A1 (clk,enable,out1,out2,out3,out4,out5,out6,out7,out8,out9,final,finished_con2);
        
endmodule


module addr2(
    input clk,
    input enable,
    input signed [15:0] in1,
    input signed [15:0] in2,
    input signed [15:0] in3,
    input signed [15:0] in4,
    input signed [15:0] in5,
    input signed [15:0] in6,
    input signed [15:0] in7,
    input signed [15:0] in8,
    input signed [15:0] in9,
    output reg signed [15:0] sum1,
    output reg finished 
);

//Add up all values from convolution

    always@(posedge clk)
        begin
            if(enable)
                begin
                    sum1 <= (in1 + in2 + in3 + in4 + in5 + in6 + in7 + in8 + in9);
                    finished <= 1;
                end
        end
endmodule
