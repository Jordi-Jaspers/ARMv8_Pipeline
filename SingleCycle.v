/*
 *  @Author: Jordi Jaspers
 *  
 *  This project contains the composition of all the made modules. The wiring done in this program follows
 *  the paths made in the picture in the book at page 276. This is a fully working single cycle ARM processor.
 *
 */

module SingleCycle(Clk, Rst, startPC, currentPC, dMemOut);
   input Clk;
   input Rst;
   input [63:0] startPC;
   output [63:0] currentPC;
   output [63:0] dMemOut;
   
   //PC Logic -- wire 64 bit programcounter aangemaakt
   wire [63:0] 	 nextPC;
   reg [63:0] 	 currentPC;
   
   //Instruction Decode -- wire Book page 272
   wire [31:0] 	 currentInstruction;
   wire [10:0] 	 OPCode;
   wire [4:0] 	    rm,rn,rd;  
   wire [5:0] 	    shamt;

   assign {OPCode, rm, shamt, rn, rd} = currentInstruction;
   
   wire [63:0] 	 Out1;
   wire [63:0] 	 Out2;
   wire [63:0] 	 Data;
   wire [4:0]	 Rb;
   
   //Control & ALUControl Logic Wires
   wire Reg2Loc, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite;
   wire [1:0] 	 ALUOP;

   //ALUControl --wires
   wire [3:0] 	 Operation;

   //ALU -- wires
   wire [63:0] 	 ALUIn1, ALUIn2;
   wire [63:0] 	 OutALU;
   wire 	          Zero;
   
   //Data Memory Wires -- ReadData in module
   wire [63:0] 	 dMemOut;

   //SignExtension wires
   wire [63:0]    signextended;

   //Instruction Memory
   InstructionMemory instrMem(
      .Instruction(currentInstruction), 
      .Address(currentPC)
   );	
   
   //PC Logic	
   ProgramCounter next(	
      .NextPC(nextPC),
      .CurrentPC(currentPC),
      .SignExt(ALUIn2),
      .Branch(Branch), 
      .ALUZero(Zero),
      .Clk(Clk),
      .Rst(Rst)
   );   


	always @ (posedge Clk, Rst) 
	begin
		if(Rst)
			currentPC = startPC;
		else
			currentPC = nextPC;
	end
   
   //Control
   Control control(
      .OPCode(OPCode),
      .Reg2Loc(Reg2Loc),
      .Branch(Branch),
      .MemRead(MemRead),
      .MemToReg(MemToReg),
      .ALUOP(ALUOP),
      .MemWrite(MemWrite),
      .ALUSrc(ALUSrc),
      .RegWrite(RegWrite)
   );
   
   //Register file
   //Mux voor Read Register 2 als Reg2Loc is 1 dan Rb = rd ander Rb = rm
   assign Rb = Reg2Loc ? rd : rm;

   RegisterFile registers(
      .R1(rn), 
      .R2(Rb),
      .WReg(rd), 
      .Data(Data), 
      .WE(RegWrite), 
      .Out1(Out1), 
      .Out2(Out2), 
      .Clk(Clk),
      .Rst(Rst)
   );   
   
   //Sign Extender -- vragen
   SignExtend SignExt(
      .Instruction(currentInstruction), 
      .extended(signextended)
   );

   //ALU-control
   ALUControl ALUCont(
      .Operation(Operation), 
      .ALUOP(ALUOP), 
      .OPCode(OPCode)
   );

   assign ALUIn2 = ALUSrc ? signextended : Out2;
   assign ALUIn1 = Out1;

   ALU mainALU(
      .Out(OutALU), 
      .R1(ALUIn1), 
      .R2(ALUIn2), 
      .Mode(Operation), 
      .Zero(Zero)
   );
   
   //Data Memory
   DataMemory data(.ReadData(dMemOut), 
                   .Address(OutALU), 
                   .WriteData(Out2), 
                   .MemoryRead(MemRead), 
                   .MemoryWrite(MemWrite), 
                   .Clk(Clk));
  
   /* create MemToReg mux - another ternary statement */
	assign Data = MemToReg == 1 ? dMemOut : OutALU;
   
endmodule
