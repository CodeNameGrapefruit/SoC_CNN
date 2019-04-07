`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Kethan Narasimhalu
// Masters Thesis
// University of Texas at San Antonio
//
// System on Chip - Convolutional Neural Network
//

module main(
    input clk,
    input rst
    );
    
    reg signed [7:0] image [0:16384];
    reg signed [7:0] test [0:16384];
    reg signed [15:0] con2 [0:15875];
    reg signed [15:0] pool [0:7937];
    
    //Read Input Images Into ROMS    
    initial begin
        $readmemb("C:/Users/halok/Desktop/School/Grad VLSI/jordan1.txt", image, 0, 16384);
        $readmemb("C:/Users/halok/Desktop/School/Grad VLSI/jordan1.txt", test, 0, 16384);
    end
    
    //Convolution Stage 1 Image//////////////////////////////////////////////////////////////////////////
    reg image_enable;
    wire [7:0] con1_in1;
    wire [7:0] con1_in2;
    wire [7:0] con1_in3;
    wire [7:0] con1_in4;
    wire [7:0] con1_in5;
    wire [7:0] con1_in6;
    wire [7:0] con1_in7;
    wire [7:0] con1_in8;
    wire [7:0] con1_in9;
    wire signed [7:0] con1_final;
    wire finished_con1;
    
    reg [15:0] img_in1_addr;
    reg [15:0] img_in2_addr;
    reg [15:0] img_in3_addr;
    reg [15:0] img_in4_addr;
    reg [15:0] img_in5_addr;
    reg [15:0] img_in6_addr;
    reg [15:0] img_in7_addr;
    reg [15:0] img_in8_addr;
    reg [15:0] img_in9_addr;
    
    reg [15:0] img_addr = 0;
    
    reg[15:0] img_counter = 16'b0000_0000_0000_0001;
    
    reg img_stop = 1'b1;

    initial 
        begin
            img_in1_addr <= 16'b0000_0000_0000_0000;
            img_in2_addr <= 16'b0000_0000_0000_0001;
            img_in3_addr <= 16'b0000_0000_0000_0010;
            
            img_in4_addr <= 16'b0000_0000_1000_0000;
            img_in5_addr <= 16'b0000_0000_1000_0001;
            img_in6_addr <= 16'b0000_0000_1000_0010;
            
            img_in7_addr <= 16'b0000_0001_0000_0000;
            img_in8_addr <= 16'b0000_0001_0000_0001;
            img_in9_addr <= 16'b0000_0001_0000_0010;
            
            image_enable <=1'b1;
                        
        end
        
    Convolution_1 Image_Convolution (clk, image_enable, con1_in1, con1_in2, con1_in3, con1_in4, con1_in5, con1_in6, con1_in7, con1_in8, con1_in9, con1_final, finished_con1);
    
    //Assign Inputs
    assign con1_in1 = (image_enable && (image[img_in1_addr])); 
    assign con1_in2 = (image_enable && (image[img_in2_addr]));
    assign con1_in3 = (image_enable && (image[img_in3_addr]));
    assign con1_in4 = (image_enable && (image[img_in4_addr]));
    assign con1_in5 = (image_enable && (image[img_in5_addr]));
    assign con1_in6 = (image_enable && (image[img_in6_addr]));
    assign con1_in7 = (image_enable && (image[img_in7_addr]));
    assign con1_in8 = (image_enable && (image[img_in8_addr]));
    assign con1_in9 = (image_enable && (image[img_in9_addr]));
    
    //Block for Generating Address and Writing Con1 Outputs to ROM  
    always @(posedge clk)
        begin
        if(img_stop)
        begin
            if(rst)
                begin
                    img_in1_addr <= 16'b0000_0000_0000_0000;
                    img_in2_addr <= 16'b0000_0000_0000_0001;
                    img_in3_addr <= 16'b0000_0000_0000_0010;
                    img_in4_addr <= 16'b0000_0000_1000_0000;
                    img_in5_addr <= 16'b0000_0000_1000_0001;
                    img_in6_addr <= 16'b0000_0000_1000_0010;
                    img_in7_addr <= 16'b0000_0001_0000_0000;
                    img_in8_addr <= 16'b0000_0001_0000_0001;
                    img_in9_addr <= 16'b0000_0001_0000_0010;                
                end
             if(finished_con1)
                begin
                    image[img_addr] = con1_final;
                    img_addr = img_addr + 1'b1;
                    if(img_in9_addr == 16383)
                        begin
                            img_stop = 0;
                        end
                    img_counter = img_counter + 1;
                    if(img_counter == 127)
                        begin
                            img_in1_addr <= img_in1_addr + 16'b0000_0000_0000_0011;
                            img_in2_addr <= img_in2_addr + 16'b0000_0000_0000_0011;
                            img_in3_addr <= img_in3_addr + 16'b0000_0000_0000_0011;
                            img_in4_addr <= img_in4_addr + 16'b0000_0000_0000_0011;
                            img_in5_addr <= img_in5_addr + 16'b0000_0000_0000_0011;
                            img_in6_addr <= img_in6_addr + 16'b0000_0000_0000_0011;
                            img_in7_addr <= img_in7_addr + 16'b0000_0000_0000_0011;
                            img_in8_addr <= img_in8_addr + 16'b0000_0000_0000_0011;
                            img_in9_addr <= img_in9_addr + 16'b0000_0000_0000_0011;
                            img_counter <= 16'b0000_0000_0000_0001; 
                        end
                    else
                        begin
                            img_in1_addr <= img_in1_addr + 1'b1;
                            img_in2_addr <= img_in2_addr + 1'b1;
                            img_in3_addr <= img_in3_addr + 1'b1;
                            img_in4_addr <= img_in4_addr + 1'b1;
                            img_in5_addr <= img_in5_addr + 1'b1;
                            img_in6_addr <= img_in6_addr + 1'b1;
                            img_in7_addr <= img_in7_addr + 1'b1;
                            img_in8_addr <= img_in8_addr + 1'b1;
                            img_in9_addr <= img_in9_addr + 1'b1;    
                        end                  
                end
        end
        end

//Convolution Stage 1 Image END//////////////////////////////////////////////////////////////////////////

//Convolution Stage 1 Test Pattern//////////////////////////////////////////////////////////////////////
    reg test_enable; 
    wire [7:0] test_in1;
    wire [7:0] test_in2;
    wire [7:0] test_in3;
    wire [7:0] test_in4;
    wire [7:0] test_in5;
    wire [7:0] test_in6;
    wire [7:0] test_in7;
    wire [7:0] test_in8;
    wire [7:0] test_in9;
    wire signed [7:0] test_final;
    wire finished_test;
    
    reg [15:0] test_in1_addr;
    reg [15:0] test_in2_addr;
    reg [15:0] test_in3_addr;
    reg [15:0] test_in4_addr;
    reg [15:0] test_in5_addr;
    reg [15:0] test_in6_addr;
    reg [15:0] test_in7_addr;
    reg [15:0] test_in8_addr;
    reg [15:0] test_in9_addr;
    
    reg [15:0] test_addr = 0;
    
    reg [15:0] test_counter = 16'b0000_0000_0000_0001;
    
    reg test_stop = 1'b1;

    initial 
        begin
            test_in1_addr <= 16'b0000_0000_0000_0000;
            test_in2_addr <= 16'b0000_0000_0000_0001;
            test_in3_addr <= 16'b0000_0000_0000_0010;
            
            test_in4_addr <= 16'b0000_0000_1000_0000;
            test_in5_addr <= 16'b0000_0000_1000_0001;
            test_in6_addr <= 16'b0000_0000_1000_0010;
            
            test_in7_addr <= 16'b0000_0001_0000_0000;
            test_in8_addr <= 16'b0000_0001_0000_0001;
            test_in9_addr <= 16'b0000_0001_0000_0010;
            
            test_enable <=1'b1;            
        end
     
    
    Convolution_1 Test_Convolution (clk, test_enable, test_in1, test_in2, test_in3, test_in4, test_in5, test_in6, test_in7, test_in8, test_in9, test_final, finished_test);

//Pre Assigne Inputs
    assign test_in1 = (test_enable && (test[test_in1_addr])); 
    assign test_in2 = (test_enable && (test[test_in2_addr]));
    assign test_in3 = (test_enable && (test[test_in3_addr]));
    assign test_in4 = (test_enable && (test[test_in4_addr]));
    assign test_in5 = (test_enable && (test[test_in5_addr]));
    assign test_in6 = (test_enable && (test[test_in6_addr]));
    assign test_in7 = (test_enable && (test[test_in7_addr]));
    assign test_in8 = (test_enable && (test[test_in8_addr]));
    assign test_in9 = (test_enable && (test[test_in9_addr]));
   
//Block for Generating Address and Writing Con1 Outputs to ROM  
    always @(posedge clk)
        begin
        if(test_stop)
        begin
            if(rst)
                begin
                    test_in1_addr <= 16'b0000_0000_0000_0000;
                    test_in2_addr <= 16'b0000_0000_0000_0001;
                    test_in3_addr <= 16'b0000_0000_0000_0010;
                    test_in4_addr <= 16'b0000_0000_1000_0000;
                    test_in5_addr <= 16'b0000_0000_1000_0001;
                    test_in6_addr <= 16'b0000_0000_1000_0010;
                    test_in7_addr <= 16'b0000_0001_0000_0000;
                    test_in8_addr <= 16'b0000_0001_0000_0001;
                    test_in9_addr <= 16'b0000_0001_0000_0010;                
                end
             if(finished_test)
                begin
                    test[test_addr] = test_final;
                    test_addr = test_addr + 1'b1;
                    if(test_in9_addr == 16386)
                        begin
                            test_stop = 0;
                        end                    
                    test_counter = test_counter + 1;
                    if(test_counter == 127)
                        begin
                            test_in1_addr <=test_in1_addr + 16'b0000_0000_0000_0011;
                            test_in2_addr <=test_in2_addr + 16'b0000_0000_0000_0011;
                            test_in3_addr <=test_in3_addr + 16'b0000_0000_0000_0011;
                            test_in4_addr <=test_in4_addr + 16'b0000_0000_0000_0011;
                            test_in5_addr <=test_in5_addr + 16'b0000_0000_0000_0011;
                            test_in6_addr <=test_in6_addr + 16'b0000_0000_0000_0011;
                            test_in7_addr <=test_in7_addr + 16'b0000_0000_0000_0011;
                            test_in8_addr <=test_in8_addr + 16'b0000_0000_0000_0011;
                            test_in9_addr <=test_in9_addr + 16'b0000_0000_0000_0011;
                            test_counter <= 16'b0000_0000_0000_0001; 
                        end
                    else
                        begin
                            test_in1_addr <= test_in1_addr + 1'b1;
                            test_in2_addr <= test_in2_addr + 1'b1;
                            test_in3_addr <= test_in3_addr + 1'b1;
                            test_in4_addr <= test_in4_addr + 1'b1;
                            test_in5_addr <= test_in5_addr + 1'b1;
                            test_in6_addr <= test_in6_addr + 1'b1;
                            test_in7_addr <= test_in7_addr + 1'b1;
                            test_in8_addr <= test_in8_addr + 1'b1;
                            test_in9_addr <= test_in9_addr + 1'b1;    
                        end                  
                end
        end
        end

//Convolution Stage 1 Test Pattern END//////////////////////////////////////////////////////////////////////////

//Convolution Stage 2//////////////////////////////////////////////////////////////////////////////////////////

    reg con2_enable;
    reg [15:0] con2_counter = 16'b0000_0000_0000_0001;
    reg [15:0] con2_addr = 0;
    wire finished_con2;
    wire signed [7:0] con2_img_in1;
    wire signed [7:0] con2_img_in2;
    wire signed [7:0] con2_img_in3;
    wire signed [7:0] con2_img_in4;
    wire signed [7:0] con2_img_in5;
    wire signed [7:0] con2_img_in6;
    wire signed [7:0] con2_img_in7;
    wire signed [7:0] con2_img_in8;
    wire signed [7:0] con2_img_in9;
    wire signed [7:0] con2_test_in1;
    wire signed [7:0] con2_test_in2;
    wire signed [7:0] con2_test_in3;
    wire signed [7:0] con2_test_in4;
    wire signed [7:0] con2_test_in5;
    wire signed [7:0] con2_test_in6;
    wire signed [7:0] con2_test_in7;
    wire signed [7:0] con2_test_in8;
    wire signed [7:0] con2_test_in9;
    wire signed [15:0] con2_final;

    reg [15:0] con2_in1_addr;
    reg [15:0] con2_in2_addr;
    reg [15:0] con2_in3_addr;
    reg [15:0] con2_in4_addr;
    reg [15:0] con2_in5_addr;
    reg [15:0] con2_in6_addr;
    reg [15:0] con2_in7_addr;
    reg [15:0] con2_in8_addr;
    reg [15:0] con2_in9_addr;
    
    reg [15:0] con2_in10_addr;
    reg [15:0] con2_in11_addr;
    reg [15:0] con2_in12_addr;
    reg [15:0] con2_in13_addr;
    reg [15:0] con2_in14_addr;
    reg [15:0] con2_in15_addr;
    reg [15:0] con2_in16_addr;
    reg [15:0] con2_in17_addr;
    reg [15:0] con2_in18_addr;
    
    reg con2_stop = 1'b1;
    
    initial 
        begin
            con2_in1_addr <= 16'b0000_0000_0000_0000;
            con2_in2_addr <= 16'b0000_0000_0000_0001;
            con2_in3_addr <= 16'b0000_0000_0000_0010;

            con2_in4_addr <= 16'b0000_0000_1000_0000;
            con2_in5_addr <= 16'b0000_0000_1000_0001;
            con2_in6_addr <= 16'b0000_0000_1000_0010;

            con2_in7_addr <= 16'b0000_0001_0000_0000;
            con2_in8_addr <= 16'b0000_0001_0000_0001;
            con2_in9_addr <= 16'b0000_0001_0000_0010;

            con2_in10_addr <= 16'b0000_0000_0000_0000;
            con2_in11_addr <= 16'b0000_0000_0000_0001;
            con2_in12_addr <= 16'b0000_0000_0000_0010;

            con2_in13_addr <= 16'b0000_0000_1000_0000;
            con2_in14_addr <= 16'b0000_0000_1000_0001;
            con2_in15_addr <= 16'b0000_0000_1000_0010;

            con2_in16_addr <= 16'b0000_0001_0000_0000;
            con2_in17_addr <= 16'b0000_0001_0000_0001;
            con2_in18_addr <= 16'b0000_0001_0000_0010;
            
            con2_enable <=1'b1;
        end            
        
    
    assign con2_img_in1 = (con2_enable && (image[con2_in1_addr]));
    assign con2_img_in2 = (con2_enable && (image[con2_in2_addr]));
    assign con2_img_in3 = (con2_enable && (image[con2_in3_addr]));
    assign con2_img_in4 = (con2_enable && (image[con2_in4_addr]));
    assign con2_img_in5 = (con2_enable && (image[con2_in5_addr]));
    assign con2_img_in6 = (con2_enable && (image[con2_in6_addr]));
    assign con2_img_in7 = (con2_enable && (image[con2_in7_addr]));
    assign con2_img_in8 = (con2_enable && (image[con2_in8_addr]));
    assign con2_img_in9 = (con2_enable && (image[con2_in9_addr]));
    assign con2_test_in1 = (con2_enable && (test[con2_in10_addr]));
    assign con2_test_in2 = (con2_enable && (test[con2_in11_addr]));
    assign con2_test_in3 = (con2_enable && (test[con2_in12_addr]));
    assign con2_test_in4 = (con2_enable && (test[con2_in13_addr]));
    assign con2_test_in5 = (con2_enable && (test[con2_in14_addr]));
    assign con2_test_in6 = (con2_enable && (test[con2_in15_addr]));
    assign con2_test_in7 = (con2_enable && (test[con2_in16_addr]));
    assign con2_test_in8 = (con2_enable && (test[con2_in17_addr]));
    assign con2_test_in9 = (con2_enable && (test[con2_in18_addr]));

    Convolution_2 c1(clk,con2_enable,
                        con2_img_in1,con2_img_in2,con2_img_in3,con2_img_in4,con2_img_in5,con2_img_in6,con2_img_in7,con2_img_in8,con2_img_in9,
                        con2_test_in1,con2_test_in2,con2_test_in3,con2_test_in4,con2_test_in5,con2_test_in6,con2_test_in7,con2_test_in8,con2_test_in9,
                        con2_final,finished_con2);
    
    always@(posedge clk)   
        begin
        if(con2_stop)
        begin
            if(rst)
                begin
                    con2_in1_addr <= 16'b0000_0000_0000_0000;
                    con2_in2_addr <= 16'b0000_0000_0000_0001;
                    con2_in3_addr <= 16'b0000_0000_0000_0010;
                    con2_in4_addr <= 16'b0000_0000_1000_0000;
                    con2_in5_addr <= 16'b0000_0000_1000_0001;
                    con2_in6_addr <= 16'b0000_0000_1000_0010;
                    con2_in7_addr <= 16'b0000_0001_0000_0000;
                    con2_in8_addr <= 16'b0000_0001_0000_0001;
                    con2_in9_addr <= 16'b0000_0001_0000_0010;
                    con2_in10_addr <= 16'b0000_0000_0000_0000;
                    con2_in11_addr <= 16'b0000_0000_0000_0001;
                    con2_in12_addr <= 16'b0000_0000_0000_0010;
                    con2_in13_addr <= 16'b0000_0000_1000_0000;
                    con2_in14_addr <= 16'b0000_0000_1000_0001;
                    con2_in15_addr <= 16'b0000_0000_1000_0010;
                    con2_in16_addr <= 16'b0000_0001_0000_0000;
                    con2_in17_addr <= 16'b0000_0001_0000_0001;
                    con2_in18_addr <= 16'b0000_0001_0000_0010;          
                end
             if(finished_con2)
                begin
                    con2[con2_addr] = con2_final;
                    con2_addr = con2_addr + 1'b1;
                    if((con2_in9_addr == 16386) && (con2_in18_addr == 16386))
                        begin
                            con2_stop <= 0;
                        end                    
                    con2_counter = con2_counter + 1;
                    if(con2_counter == 127)
                        begin
                            con2_in1_addr <=con2_in1_addr + 16'b0000_0000_0000_0011;
                            con2_in2_addr <=con2_in2_addr + 16'b0000_0000_0000_0011;
                            con2_in3_addr <=con2_in3_addr + 16'b0000_0000_0000_0011;
                            con2_in4_addr <=con2_in4_addr + 16'b0000_0000_0000_0011;
                            con2_in5_addr <=con2_in5_addr + 16'b0000_0000_0000_0011;
                            con2_in6_addr <=con2_in6_addr + 16'b0000_0000_0000_0011;
                            con2_in7_addr <=con2_in7_addr + 16'b0000_0000_0000_0011;
                            con2_in8_addr <=con2_in8_addr + 16'b0000_0000_0000_0011;
                            con2_in9_addr <=con2_in9_addr + 16'b0000_0000_0000_0011;
                            con2_in10_addr <=con2_in10_addr + 16'b0000_0000_0000_0011;
                            con2_in11_addr <=con2_in11_addr + 16'b0000_0000_0000_0011;
                            con2_in12_addr <=con2_in12_addr + 16'b0000_0000_0000_0011;
                            con2_in13_addr <=con2_in13_addr + 16'b0000_0000_0000_0011;
                            con2_in14_addr <=con2_in14_addr + 16'b0000_0000_0000_0011;
                            con2_in15_addr <=con2_in15_addr + 16'b0000_0000_0000_0011;
                            con2_in16_addr <=con2_in16_addr + 16'b0000_0000_0000_0011;
                            con2_in17_addr <=con2_in17_addr + 16'b0000_0000_0000_0011;
                            con2_in18_addr <=con2_in18_addr + 16'b0000_0000_0000_0011;
                            con2_counter <= 16'b0000_0000_0000_0001;  
                        end
                    else
                        begin
                            con2_in1_addr <=con2_in1_addr + 1'b1; 
                            con2_in2_addr <=con2_in2_addr + 1'b1; 
                            con2_in3_addr <=con2_in3_addr + 1'b1; 
                            con2_in4_addr <=con2_in4_addr + 1'b1; 
                            con2_in5_addr <=con2_in5_addr + 1'b1; 
                            con2_in6_addr <=con2_in6_addr + 1'b1; 
                            con2_in7_addr <=con2_in7_addr + 1'b1; 
                            con2_in8_addr <=con2_in8_addr + 1'b1; 
                            con2_in9_addr <=con2_in9_addr + 1'b1; 
                            con2_in10_addr <=con2_in10_addr + 1'b1;
                            con2_in11_addr <=con2_in11_addr + 1'b1;
                            con2_in12_addr <=con2_in12_addr + 1'b1;
                            con2_in13_addr <=con2_in13_addr + 1'b1;
                            con2_in14_addr <=con2_in14_addr + 1'b1;
                            con2_in15_addr <=con2_in15_addr + 1'b1;
                            con2_in16_addr <=con2_in16_addr + 1'b1;
                            con2_in17_addr <=con2_in17_addr + 1'b1;
                            con2_in18_addr <=con2_in18_addr + 1'b1;    
                        end                  
             end
        end
        end

//Convolution Stage 2 END/////////////////////////////////////////////////////////////////////////////////////

//Max Pooling Start////////////////////////////////////////////////////////////////////////////////////
    
 
    reg pool_enable;
    wire finished_pool;
    wire signed [15:0] pool_in1;
    wire signed [15:0] pool_in2;
    wire signed [15:0] pool_in3;
    wire signed [15:0] pool_in4;
    wire signed [15:0] pool_final;
    
    reg [15:0] pool_in1_addr;
    reg [15:0] pool_in2_addr;
    reg [15:0] pool_in3_addr;
    reg [15:0] pool_in4_addr;
    reg [15:0] pool_addr = 0;
    
    reg [15:0] pool_counter = 0;
    reg pool_stop = 1'b1;
    
    initial
        begin
            pool_in1_addr <= 16'b0000_0000_0000_0000;
            pool_in2_addr <= 16'b0000_0000_0000_0001;
            pool_in3_addr <= 16'b0000_0000_0101_1011;
            pool_in4_addr <= 16'b0000_0000_0101_1100;
            
            pool_enable = 1'b1;
        end
    
    maxpool MaxPooling(clk,pool_enable,pool_in1,pool_in2,pool_in3,pool_in4,pool_final,finished_pool);
    
    assign pool_in1 = ((con2[pool_in1_addr]));
    assign pool_in2 = ((con2[pool_in2_addr]));
    assign pool_in3 = ((con2[pool_in3_addr]));
    assign pool_in4 = ((con2[pool_in4_addr]));
    
    always @(posedge clk)
        begin
        if(con2_stop == 0)
        begin
        if(pool_stop)
        begin
            if(rst)
                begin
                    pool_in1_addr <= 16'b0000_0000_0000_0000;
                    pool_in2_addr <= 16'b0000_0000_0000_0001;
                    pool_in3_addr <= 16'b0000_0000_0111_1110;
                    pool_in4_addr <= 16'b0000_0000_0111_1111;               
                end
             if(finished_pool)
                begin
                    pool[pool_addr] = pool_final;
                    pool_addr = pool_addr + 1'b1;
                    if(pool_in4_addr == 7938)
                        begin
                            pool_stop = 0;
                        end                    
                    pool_counter = pool_counter + 1;
                    if(pool_counter == 90)
                        begin
                            pool_in1_addr <=pool_in1_addr + 16'b0000_0000_0000_0010;
                            pool_in2_addr <=pool_in2_addr + 16'b0000_0000_0000_0010;
                            pool_in3_addr <=pool_in3_addr + 16'b0000_0000_0000_0010;
                            pool_in4_addr <=pool_in4_addr + 16'b0000_0000_0000_0010;
                            pool_counter <= 16'b0000_0000_0000_0001; 
                        end
                    else
                        begin
                            pool_in1_addr <= pool_in1_addr + 1'b1;
                            pool_in2_addr <= pool_in2_addr + 1'b1;
                            pool_in3_addr <= pool_in3_addr + 1'b1;
                            pool_in4_addr <= pool_in4_addr + 1'b1;    
                        end                  
                end
        end
        end
        end

//Max Pooling END////////////////////////////////////////////////////////////////////////////////////

//Write Max Pooling Result to File/////////////////////////////////////////////////////////////////////////////////////
//Writing to File END/////////////////////////////////////////////////////////////////////////////////
endmodule

