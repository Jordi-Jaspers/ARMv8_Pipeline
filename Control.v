/*
 *  Module: Control
 *  Dit geeft instructies aan de alu via 11bit opcodes 2bit ALUOP en 4bit operation
 *  pagina 278 in het boek
 *  pagina 278 in het boekt geeft aan welke instrcutie nodig zijn + andere instructies in appendix C
 *  '?' of 'x' zijn don't care's in het systeem.
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

module Control(OPCode, Reg2Loc, Branch, MemRead, MemToReg, ALUOP, MemWrite, ALUSrc, RegWrite);

input [10:0] OPCode;                        //11bit OPCode zijn de 11 MSB van de instruction Code

output [1:0] ALUOP;                         //2bit ALUOP dit zijn de 2 MSB van de 11 bit OPCode
reg    [1:0] ALUOP;

output Reg2Loc;                           
output Branch;
output MemRead;
output MemToReg;
output MemWrite;
output ALUSrc;
output RegWrite;

reg Reg2Loc, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite;

always @ (*)
begin
    case(OPCode)
        `LDUROPCODE:                        // ALUOP[00] D-type (Load & Store)
            begin
                Reg2Loc     =  1'b0;    
                ALUSrc      =  1'b1;
                MemToReg    =  1'b1;
                RegWrite    =  1'b1;          
                MemRead     =  1'b1;
                MemWrite    =  1'b0;
                Branch      =  1'b0;
                ALUOP       =  2'b00;                       
            end
	    `STUROPCODE: 
            begin
                Reg2Loc     =  1'b1;    
                ALUSrc      =  1'b1;
                MemToReg    =  1'b0;
                RegWrite    =  1'b0;          
                MemRead     =  1'b0;
                MemWrite    =  1'b1;
                Branch      =  1'b0;
                ALUOP       =  2'b00;       
            end
        `CBZOPCODE:                         // ALUOP[01] B-type (CBZ)
            begin
                Reg2Loc     =  1'b1;    
                ALUSrc      =  1'b0;
                MemToReg    =  1'b0;
                RegWrite    =  1'b1;          
                MemRead     =  1'b0;
                MemWrite    =  1'b0;
                Branch      =  1'b1;
                ALUOP       =  2'b01;
            end
	    `ADDOPCODE:                         // ALUOP[10] R-types (AND & OR & ...)  
            begin
                Reg2Loc     =  1'b0;    
                ALUSrc      =  1'b0;
                MemToReg    =  1'b0;
                RegWrite    =  1'b1;          
                MemRead     =  1'b0;
                MemWrite    =  1'b0;
                Branch      =  1'b0;
                ALUOP       =  2'b10;
            end
	    `SUBOPCODE: 
            begin
                Reg2Loc     =  1'b0;   
                ALUSrc      =  1'b0;
                MemToReg    =  1'b0;
                RegWrite    =  1'b1;           
                MemRead     =  1'b0;
                MemWrite    =  1'b0;
                Branch      =  1'b0;
                ALUOP       =  2'b10;
            end
	    `ANDOPCODE: 
            begin
                Reg2Loc     =  1'b0;    
                ALUSrc      =  1'b0;
                MemToReg    =  1'b0;
                RegWrite    =  1'b1;           
                MemRead     =  1'b0;
                MemWrite    =  1'b0;
                Branch      =  1'b0;
                ALUOP       =  2'b10;
            end
	    `ORROPCODE: 
            begin
                Reg2Loc     =  1'b0;    
                ALUSrc      =  1'b0;
                MemToReg    =  1'b0;
                RegWrite    =  1'b1;           
                MemRead     =  1'b0;
                MemWrite    =  1'b0;
                Branch      =  1'b0;
                ALUOP       =  2'b10;
            end
	    `BOPCODE: 
            begin
                Reg2Loc     =  1'b0;    
                ALUSrc      =  1'b0;
                MemToReg    =  1'b0;
                RegWrite    =  1'b1;           
                MemRead     =  1'b0;
                MemWrite    =  1'b0;
                Branch      =  1'b0;
                ALUOP       =  2'b10;
            end 
	    `LSROPCODE: 
            begin
                Reg2Loc     =  1'b0;    
                ALUSrc      =  1'b0;
                MemToReg    =  1'b0;
                RegWrite    =  1'b1;           
                MemRead     =  1'b0;
                MemWrite    =  1'b0;
                Branch      =  1'b0;
                ALUOP       =  2'b10;
            end 
        `LSLOPCODE: 
            begin
                Reg2Loc     =  1'b0;    
                ALUSrc      =  1'b0;
                MemToReg    =  1'b0;
                RegWrite    =  1'b1;           
                MemRead     =  1'b0;
                MemWrite    =  1'b0;
                Branch      =  1'b0;
                ALUOP       =  2'b10;
            end   
        default:                                //RESET! alles op X
            begin
                Reg2Loc     =  1'b0;    
                ALUSrc      =  1'b0;
                MemToReg    =  1'b0;
                RegWrite    =  1'b0;           
                MemRead     =  1'b0;
                MemWrite    =  1'b0;
                Branch      =  1'b0;
                ALUOP       =  2'b00;
           end
        endcase       
    end
endmodule