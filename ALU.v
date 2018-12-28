/*
 *  Module: ALU
 *  Doet alles logische instructies uitvoeren.
 */

//iedere een isntructie een eigen 4 bit binaire code geven
//boek pagina 271.

`define ADD     4'b0010
`define SUB     4'b0110
`define AND     4'b0000
`define OR      4'b0001
`define LSL     4'b0011
`define LSR     4'b0100
`define PassB   4'b0111

 module ALU(Out, R1, R2, Mode, Zero);

    input   [63:0] R1, R2;  //invoer van de ALU
	input   [3:0] Mode;     //de 4bit instructie die boven gedefineerd is.

	output  [63:0] Out;     //uitvoer van de ALU
    reg     [63:0] Out;

	output  wire Zero; 
    
	always @(Mode or R1 or R2) 
        begin
		case(Mode)
			`AND: begin
			Out = R1 & R2;
			end
			`OR: begin
			Out = R1 | R2;
			end
			`ADD: begin
			Out = R1 + R2;
			end
			`LSL: begin
			Out = R1 << R2;
			end
			`LSR: begin
			Out = R1 >>> R2;
			end
			`SUB: begin
			Out = R1 - R2;
			end
			`PassB: begin
			Out = R2;
			end
		endcase
	end
	
	assign Zero = (Out == 64'b0);

endmodule