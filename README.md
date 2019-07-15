#Author:  
Jordi Jaspers  
  
#Date of initial commit:  
28/12/2018  
  
#ARMv8_Pipeline  
An Arm V8 processor with pipelining made via the instructions of the ARM-Edition book written by David A. Patterson &amp; John L. Hennesey 
  
#What I learned  
* Advanced verilog & VHDL programming
* How parallel processing work instead of the regular sequential processing
* Workings of a processor (Also see Tamarac on my github)
* Understanding and importance of pipelining with error detection
  
#DISCLAIMER:  
All the code that is copied or used from other sources will be mentioned in the reference section of this file.    

#TODO list:  
The pipelining processor is made out of 9 modules or 5 big parts and ofcourse a testfile.  
==> Fetch, Decode, Execute, Data-Acces, Write-Back.  
  
1.  RegisterFile    	-->     done!  (gebruikt van de single_cycle)      
2.  ProgramCounter      -->     done! (is verwerkt in de pipelining zelf. geen apparte file meer.)  
3.  SignExtend          -->     done! (gebruikt van de single_cycle)   
4.  ALU                 -->     done! (gebruikt van de single_cycle)    
5.  ALUControl          -->     done! (gebruikt van de single_cycle)    
6.  DataMemory          -->     done! (gebruikt van de single_cycle)    
7.  InstructionMem      -->     done! (gebruikt van de single_cycle)    
8.  Piplining           -->     done!  
9.  Control             -->     done! (gebruikt van de single_cycle)      
10. Test file?          -->     done!  

#References:  
StackOverflow:  (Bible for every coder)  
https://www.StackOverflow.com/  
  
Verilog fundamentals:  
https://cseweb.ucsd.edu/classes/sp09/cse141L/Slides/01-Verilog1.pdf  
  
LEGV8 16bit component example:  
https://github.com/surajmehta95/LEGV8-Processor  
  
