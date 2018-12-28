/*
 *	Module: RegisterFile
 *  Dit zorgt ervoor dat de inkomende 32bit instructie omgezet wordt naar een 64bit.
 *  32bit instructie, 9bit voor load, 19bit voor compare
 *  boek pagina 266.
 *
 */

// D-Type
`define LDUROPCODE 11'b11111000010
`define STUROPCODE 11'b11111000000

// B-Type
`define CBZOPCODE  8'b10110100

// R-Type
`define LSLOPCODE  11'b11010011011
`define LSROPCODE  11'b11010011010
`define BOPCODE    6'b000101

module SignExtend(Instruction, extended);

input [31:0] Instruction;
output reg [63:0] extended;

always @ (*)
begin
if (Instruction[31:26] == `BOPCODE)				
	extended = {{38{Instruction[25]}}, Instruction[25:0]};

else if(Instruction[31:24] == `CBZOPCODE)
	extended = {{45{Instruction[23]}}, Instruction[23:5]};

else if(Instruction[31:21] == `LDUROPCODE || Instruction[31:21] == `STUROPCODE)
	extended = {{55{Instruction[20]}}, Instruction[20:12]};

else if(Instruction[31:21] == `LSLOPCODE || `LSROPCODE)
	extended = {{58{1'b0}}, Instruction[15:10]};

else
	extended = {{32{Instruction[31]}},Instruction};
end
endmodule
