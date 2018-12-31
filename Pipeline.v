/*
 *  @Author: Jordi Jaspers
 *  
 *  This project contains the composition of all the made modules. The wiring done in this program follows
 *  the paths made in the picture in the book at page 310. This is a fully working pipeline ARM processor.
 *
 */

module Pipeline(Clk, Rst, startPC, FetchedPC, dMemOut);
    input wire Clk;
	input wire Rst;
	input wire [63:0] startPC;

    /* Outputs - Nachecken als deze kloppen bij het testen */
    output wire [63:0] FetchedPC;
	output wire [63:0] dMemOut; 

	/* Stage 1 - Instruction Fetch (IF) */
    reg [63:0] currentPC;
    wire [63:0] nextPC;
	wire [63:0] currentPCPlus4;
	wire [31:0] instruction;
	
	/* Stage 1/2 - IF/ID Registers */
	reg [63:0] currentPC2;
	reg [31:0] instruction2;
	
	/* Stage 2 - Instruction Decode (ID) connections */
	wire [63:0] Data;
	wire [63:0] Out1;
	wire [63:0] Out2;

    	wire [4:0] rb;
	wire [4:0] WReg;

	wire [63:0] SignExt;
	wire [1:0] ALUOp;

    wire ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Unconbranch;

    /* voor signalen te hergebruiken, maken we een dummywire */
    wire dummyWire; 
	
	/* Stage 2/3 - ID/EX Registers */
	reg ALUSrc3, MemToReg3, RegWrite3, MemRead3, MemWrite3, Branch3, Unconbranch3;
	reg [1:0] ALUOp3;
	reg [63:0] currentPC3;
	reg [63:0] Out1_3;
	reg [63:0] Out2_3;
	reg [63:0] SignExt3;
	reg [10:0] Opcode3;
	reg [4:0] Rd3; 
	
	/* Stage 3 - EX Connections */
	wire [63:0] shiftedImm;
	wire [63:0] branchAddr;
	wire [63:0] ALUBusB;
	wire [3:0] ALUControlBits;
	wire [63:0] ALUBusW;
	wire ALUZero;
	
	/* Stage 3/4 EX/MEM Registers */
	reg [63:0] branchAddr4;
	reg [63:0] ALUBusW4;
	reg ALUZero4;
	reg [63:0] Out2_4;
	reg [4:0] Rd4;
	reg MemToReg4, RegWrite4, MemRead4, MemWrite4, Branch4, Unconbranch4;
	
	/* Stage 4 - MEM Connections */
	wire [63:0] MemReadBus;
	wire PCSrc;
	
	/* Stage 4/5 MEM/WB Registers */
	reg [63:0] MemReadBus5;
	reg [63:0] ALUBusW5;
	reg [4:0] Rd5;
	reg MemToReg5, RegWrite5;
	
	/* Stage 5 WB Connections */
	wire [63:0] RegBusW;

    /* Assigns toepassen voor de testwaarden na te kijken zoals boven aangegeven. */
	assign dMemOut  MemReadBus5;
	assign FetchedPC  currentPC; 

    /* Stage 1 - IF Logic */
	assign nextPC  PCSrc ? branchAddr4 : currentPCPlus4;
	assign currentPCPlus4  currentPC + 64'd4;

	always@(posedge Clk)
	begin
		if(Rst)
			currentPC <= startPC;
		else
			currentPC <= nextPC;
	end
	
	InstructionMemory InstructionMem(
        .Instruction(instruction), 
		.Address(currentPC)
    );
							 
	/* Stage 1/2 - IF/ID Registers */
	
	always@(posedge Clk or posedge Rst)
	begin
		if(Rst)
		begin
			currentPC2 <= 64'd0;
			instruction2 <= 64'd0;
		end
		else
		begin
			currentPC2 <= currentPC;
			instruction2 <= instruction;
		end
	end

    /* Stage 2 - ID Logic */
	
	assign rb  instruction2[28] ? instruction2[4:0] : instruction2[20:16];

	RegisterFile RegFile(
        .R1(instruction2[9:5]), 
        .R2(rb),
        .WReg(Rd5), 
        .Data(RegBusW),
        .WE(RegWrite5), 
        .Out1(Out1), 
        .Out2(Out2), 
        .Clk(Clk),
	.Rst(Rst)
    );
				 
	SignExtend SignExtention(
        .extended(SignExt), 
        .Instruction(instruction2)
    );
				  
	Control control(
        .OPCode(instruction2[31:21]),
        .Reg2Loc(dummyWire),        //het hergebruiken van de control unit, gebruiken we de dummy wire.
        .Branch(Branch),
	.UnconBranch(Unconbranch),
        .MemRead(MemRead),
        .MemToReg(MemToReg), 
        .ALUOP(ALUOp), 
        .MemWrite(MemWrite), 
        .ALUSrc(ALUSrc), 
        .RegWrite(RegWrite)
    );
	
    /* Stage 2/3 - ID/EX Registers */
	always@(posedge Clk or posedge Rst)
	begin
		if(Rst)
		begin
			ALUSrc3 <= 1'b0;
			MemToReg3 <= 1'b0;
			RegWrite3 <= 1'b0;
			MemRead3 <= 1'b0;
			MemWrite3 <= 1'b0;
			Branch3 <= 1'b0;
			Unconbranch3 <= 1'b0;
			ALUOp3 <= 2'b00;
	        currentPC3 <= 64'b0;
	        Out1_3 <= 64'd0;
	        Out2_3 <= 64'd0;
	        SignExt3 <= 64'd0;
	        Opcode3 <= 10'b0;
	        Rd3 <= 5'b0; 
		end
		else
		begin
			ALUSrc3 <= ALUSrc;
			MemToReg3 <= MemToReg;
			RegWrite3 <= RegWrite;
			MemRead3 <= MemRead;
			MemWrite3 <= MemWrite;
			Branch3 <= Branch;
			Unconbranch3 <= Unconbranch;
			ALUOp3 <= ALUOp;
	        currentPC3 <= currentPC2;
	        Out1_3 <= Out1;
	        Out2_3 <= Out2;
	        SignExt3 <= SignExt;
	        Opcode3 <= instruction2[31:21];
	        Rd3 <= instruction2[4:0]; 
		end
	end

    /* Stage 3 - EX Logic */
	
	assign shiftedImm  SignExt3 << 2;  //zoals de PC counter can single cycle, zie scheme single cycle boek p.272
	assign branchAddr  currentPC3 + shiftedImm;
	assign ALUBusB  ALUSrc3 ? SignExt3 : Out2_3;

	ALUControl ALUCont(
        .Operation(ALUControlBits), 
        .ALUOP(ALUOp3), 
        .OPCode(Opcode3)
    );
       
	ALU ALUcomp(
        .Out(ALUBusW), 
	    .R1(Out1_3), 
	    .R2(ALUBusB), 
	    .Mode(ALUControlBits), 
	    .Zero(ALUZero)
    );

    /* Stage 3/4 - EX/MEM Registers */
	always@(posedge Clk or posedge Rst)
	begin
	    if(Rst)
	    begin
	        branchAddr4 <= 64'b0;
	        ALUBusW4 <= 64'b0;
	        ALUZero4 <= 1'b0;
	        Out2_4 <= 63'b0;
	        Rd4 <= 5'b0;
	        MemToReg4 <= 1'b0;
	        RegWrite4 <= 1'b0;
	        MemRead4 <= 1'b0;
	        MemWrite4 <= 1'b0;
	        Branch4 <= 1'b0;
	        Unconbranch4 <= 1'b0;
	    end
	    else
	    begin
	        branchAddr4 <= branchAddr;
	        ALUBusW4 <= ALUBusW;
	        ALUZero4 <= ALUZero;
	        Out2_4 <= Out2_3;
	        Rd4 <= Rd3;
	        MemToReg4 <= MemToReg3;
	        RegWrite4 <= RegWrite3;
	        MemRead4 <= MemRead3;
	        MemWrite4 <= MemWrite3;
	        Branch4 <= Branch3;
	        Unconbranch4 <= Unconbranch3;
	    end
	end

    /* Stage 4 - MEM Logic */
	assign PCSrc  ((ALUZero4 & Branch4) | Unconbranch4);

	DataMemory DMem(
        .ReadData(MemReadBus),
        .Address(ALUBusW4), 
        .WriteData(Out2_4), 
        .MemoryRead(MemRead4), 
        .MemoryWrite(MemWrite4), 
        .Clk(Clk)
    );
	
	/* Stage 4/5 - MEM/WB Registers */
	
	always@(posedge Clk or posedge Rst)
	begin
	    if(Rst)
	    begin
		MemReadBus5 <= 64'b0;
		ALUBusW5 <= 64'b0;
		Rd5 <= 5'b0;
		MemToReg5 <= 1'b0;
		RegWrite5 <= 1'b0;
	    end
	    else
	    begin
		MemReadBus5 <= MemReadBus;
		ALUBusW5 <= ALUBusW4;
		Rd5 <= Rd4;
		MemToReg5 <= MemToReg4;
		RegWrite5 <= RegWrite4;
	    end
	end
	
	/* Stage 5 - WB Logic */
	assign RegBusW  MemToReg5 ? MemReadBus5 : ALUBusW5;
	
endmodule
	