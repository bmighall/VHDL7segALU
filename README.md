# VHDL Switch-Based ALU System with Seven-Segment Display Output (Artix-7 family Nexys 4 FPGA) 
Creator: Ben Mighall

The code performs four logic tasks (add, subtract, and, or) on two binary numbers, given by two sets of four switches.
Number A is switches 12-15; number B is switches 8-11. The operation is determined by switches 1 and 0, where '00' is 'add', '01' is 'subtract', '10' is 'and', and '11' is 'or'.
					
Switches 4 and 3 set the display mode for the final output: '00' is pass through (or standard output), '01' is 'circulate left', '10' is 'circulate right', and '11' is 'invert'.

The seven-segment display uses a button as a clock, with each press displaying a different digit. The first segment is number A, the second is number B, and the third and fourth are the final output.

All of this VHDL code was written for an Artix-7 family Nexys 4 FPGA board. Constraints file is included in this repository.

This code was written as part of coursework for University of Mississippi class El E 386 (Advanced Digital Systems Lab).
