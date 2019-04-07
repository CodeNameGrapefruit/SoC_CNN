`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Maxpooling of Second Stage Convolution
//////////////////////////////////////////////////////////////////////////////////


module maxpool(
    input clk,
    input enable,
    input signed [15:0] in1,
    input signed [15:0] in2,
    input signed [15:0] in3,
    input signed [15:0] in4,
    output reg signed [15:0] final,
    output reg signed pool_finished 
    );
    
    reg signed [21:0] temp1;
    reg signed [21:0] temp2;
    
    always@(posedge clk)
        if(enable)
            begin
                if(in1 < in2)
                    begin
                        temp1 <= in2;
                    end
                else
                    begin
                        temp1 <= in1;
                    end
                if(in1 == in2)
                    begin
                        temp1 <= in1;
                    end
                if(in3 < in4)
                    begin
                        temp2 <= in4;
                    end
                else
                    begin
                        temp2 <= in3;
                    end
                if(in3 == in4)
                    begin
                        temp2 <= in3;
                    end
                if(temp1 < temp2)
                        begin
                            final <= temp2;
                            pool_finished <= 1;
                            
                        end
                    else
                        begin
                            final <= temp1;
                            pool_finished <= 1;
                        end
                if(temp1 == temp2)
                    begin
                        final <= temp1;
                        pool_finished <= 1;
                    end
            end
endmodule
