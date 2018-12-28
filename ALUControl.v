/*
 *  Module: ALUControl
 *  Dit geeft instructies aan de alu via 11bit opcodes 2bit ALUOP en 4bit operation
 *  pagina 273 in het boek
 *  pagina 272 in het boekt geeft aan welke instrcutie nodig zijn + andere instructies in appendix C
 *
 */

// D-Type
`define LDUROPCODE 11'b11111000010
`define STUROPCODE 11'b11111000000

// B-Type
`define CBZOPCODE  11'b10110100???

// R-Type
`define ADDOPCODE  11'b10001011000
`define SUBOPCODE  11'b11001011000
`define ANDOPCODE  11'b10001010000
`define ORROPCODE  11'b10101010000
`define LSLOPCODE  11'b11010011011
`define LSROPCODE  11'b11010011010
`define BOPCODE    11'b000101?????

module ALUControl(Operation, ALUOP, OPCode);

input [1:0] ALUOP;                          //2bit ALUOP
input [10:0] OPCode;                        //11bit OPCode
output reg [3:0] Operation;                 //4bit operation

always @ (*)
begin
	Operation = 4'b1;                      // initialiseer
	if (ALUOP == 2'b00)                     // ALUOP[00] D-type
		Operation =  4'b0010;
	if (ALUOP == 2'b01)                     // ALUOP[01] B-type
		Operation =  4'b0111;
	if (ALUOP == 2'b10)                     // ALUOP[10] R-types
	begin
		if (OPCode == `ADDOPCODE)      		
			Operation =  4'b0010;

		if (OPCode == `SUBOPCODE)      		
			Operation =  4'b0110;

		if (OPCode == `ANDOPCODE)      
			Operation =  4'b0000;

		if (OPCode == `ORROPCODE)     
			Operation =  4'b0001;    

		if (OPCode == `LSLOPCODE)      
			Operation =  4'b0011;

		if (OPCode == `LSROPCODE)      
			Operation =  4'b0111;

		if (OPCode == `BOPCODE)      
			Operation = 4'b1111;		        
	end
end
endmodule