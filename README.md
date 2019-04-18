# SoC_CNN

Convolutional Neural Network Implemented in Verilog for System on Chip -Work in Progress-

Steps:

1) Two 128x128 grey scale images are read into ROMs, these images are text files that have a single pixel value per line.
2) Convolution is preformed on image one using a Laplacian filter and the result is written back into the initial ROM.
3) Convolution is preformed on image two using a Laplacian filter and the result is written back into the initial ROM.
4) Convolution is preformed between the two results from steps 2 and 3. The result is written into a new ROM.
5) Max pooling is prefomed on the result of step 4 and written into a new ROM.

Convolution.v Functionality:

The convolution modules are fairly straight forward. 9 inputs are read in from their respective ROMs and multiplied. In Convolution1 the inputs are multiplied by the Laplacian kernel and in Convolution2 the two ROMs' values are multiplied together. At the end of each convolution results are totalled and returned to the main.

Maxpooling.v Functionality:

The max pooling module takes in 4 inputs and returns the largest value to the main.

Main.v Functionality:

The main function first reads in the two 128x128 images from BRAM. Each image's pixel values are stored in a ROM. 

Once the images have been loaded into their respective ROMs the convolution module is instantiated. However, convolution can not just be applied to the ROMs. When convolution is done in a CNN it is not preformed on pixels 1, 2, 3, 4, 5, 6, 7, 8, and 9. A matrix like window is passed over the orginal image. So to replicate this effect, convolution must actually be performed on ROM values 0, 1, 2, 128, 129, 130, 256, 257, 258 (Imagine each text file has a giant matrix rather than its actual list). After the first calculation is done a "finished" signal notifies the main that the result can be written and the next set up inputs is required. 

This CNN uses a stride of 1, meaning that the convolution "window" is moved by one each time. This means that the second set of inputs required is 1, 2, 3, 129, 130, 131, 257, 258, and 259. Convolution continues until the width of the image has been covered. Once the "right side" of the "image" has been reached (ROM values 127, 255, and 383) the convolution "window" is moved down one "pixel" and reset back to the "left side" of the "image". The next 9 inputs should be ROM values 128, 129, 130, 256, 257, 258, 384, 385, and 386. This process repeats until the entire image has be convoluted with the laplacian filter. Results are written back into the initial ROMs. 

After both images have been convoluted with the filter, layer 1 is finished. Convolution is then preformed on these results using the same method described above to move through the ROMs and assign inputs. Results are written into a 3rd ROM.

After layer 2 is complete the maxpooling module is instantiated. The same method is used to move through the ROMs and assign the inputs; however, a 2x2 matrix is used for max pooling rather than a 3x3. Results are written into a 4th ROM.

FPGA Implementaion:

Nexys 4 DDR Atrix 7 used for implementation. Constraint file included.

Update  4/18/2019: Images are initialized in BRAM instead of being read from desktop. Allows for future FPGA implementation. BRAM created using Vivado IP Catalog and instantiated in Main.v.


Work Left:
1) Bug and Functionality Fixes
2) Softmax implementation/Classification?
3) Cadence Analysis for SoC potential
