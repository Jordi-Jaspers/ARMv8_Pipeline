/*
 *	Module: RegisterFile
 */
 
module RegisterFile(R1, R2, WReg, Data, WE, Out1, Out2, Clk, Rst);
	input Clk;						//Clock signaal
	input Rst;
	input [4:0] R1, R2;				//5-bits -> 32 plekker in een register
	input [4:0] WReg;				//Bepaalt welke register naar to schrijven
	input [63:0] Data;				//DAta die wegeschreven moet worden
	input WE;						//Write-enable
	
	output [63:0] Out1, Out2;		//2 - 64bit data uitvoer
	reg [63:0] registers [31:0]; 	//32 registers van 64-bit

	integer i;

	//Assign data outputs naar de 65 bit registers
	assign #2 Out1 = registers[R1];
	assign #2 Out2 = registers[R2];

	initial
	begin
		registers[31] = 64'b0; 	//64 bit binary literals (64'b0)
	end
    
	//Door een always the doen maakt verilog automatisch een sensitivity-list
	//Als WE is HIGH en WREG is 5bit dan mag schrijf de data naar WReg register
	always @ (posedge Clk)
	begin
		if(Rst)
		for(i = 0; i < 64; i=i+1)
			registers[i] = 64'b0;
		else
		begin
			if(WE && WReg != 5'b11111)
			registers[WReg] = Data;
		end
	end
	
	// always @ (*) betekent bij iedere verandering voer dit uit.
	always @ (*)
	begin
		registers[31] = {64{1'b0}}; //set register 31 terug naar 0
	end
endmodule