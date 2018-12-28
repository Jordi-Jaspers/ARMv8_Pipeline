/*
 * Module: InstructionMemory
 *
 * In pipelinening introduceren we NOP. dit is een commando dat een instructie uitvoert die geen effect heeft. 
 * volgens het boek wordt het beschreven als: 
 * "what it is doing is executing instructions that have no effect: nops
 * 2 NOPs are needed to prevent Data hazards for R-types 3 are needed for loads"
 *
 * Eindresultaat moet het volgende zijn => 11111000010 000101000 00 11111 01010
 * 
*/

`define NOP 32'h8B1F03FF //dit staat aangegeven in het boek & de appendix A.

module InstructionMemory(Instruction, Address);
    input [63:0] Address;            //64bit adres-code

    output [31:0] Instruction;       //32bit instructiecode uitvoer

    reg [31:0] Instruction;
    
    always @ (Address) begin
        case(Address)
    	64'h000: Instruction = 32'hF84083EA; 	//LDUR X10, [XZR, 0x8]
    	64'h004: Instruction = 32'hF84103EB; 	//LDUR X11, [XZR, 0x10]
    	64'h008: Instruction = 32'hF84183EC; 	//LDUR X12, [XZR, 0x18]
		64'h00c: Instruction = 32'hF84003E9; 	//LDUR X9, [XZR, 0x0]
		64'h010: Instruction = 32'hF84203ED; 	//LDUR X13, [XZR, 0x20]
		64'h014: Instruction = 32'hAA0B014A; 	//ORR X10, X10, X11
		64'h018: Instruction = `NOP; 			//Stall
		64'h01c: Instruction = `NOP; 			//Stall dependency on X10
		64'h020: Instruction = 32'h8A0A018C; 	//AND X12, X12, X10
		64'h024: Instruction = `NOP; 			//Stall
		64'h028: Instruction = `NOP; 			//Stall dependency on X12
		64'h02c: Instruction = 32'hB400014C; 	//CBZ X12, end ; loop
		64'h030: Instruction = `NOP; 			//Stall
		64'h034: Instruction = `NOP; 			//Stall
		64'h038: Instruction = `NOP; 			//Stall Don't want to run the next instruction if we are branching
		64'h03c: Instruction = 32'h8B0901AD; 	//ADD X13, X13, X9
		64'h040: Instruction = 32'hCB09018C; 	//SUB X12, X12, X9
		64'h044: Instruction = 32'h17FFFFFA; 	//B loop
		64'h048: Instruction = `NOP; 			//Stall
		64'h04c: Instruction = `NOP; 			//Stall
		64'h050: Instruction = `NOP; 			//Stall Don't want to run the next instruction when we are branching
		64'h054: Instruction = 32'hF80203ED; 	//STUR X13, [XZR, 0x20] ; end
		64'h058: Instruction = 32'hF84203ED;  	//One last load to place stored value on memdbus for test checking.; LDUR X13,[XZR, 0x20]
		64'h05c: Instruction = `NOP;
		64'h060: Instruction = `NOP;
		64'h064: Instruction = `NOP;
		64'h068: Instruction = `NOP; 			//Add stalls to wait for the value to be placed on the MemBus in the WriteBack stage
		63'h06c: Instruction = 32'h8B1F03E9; // start of tests
		63'h070: Instruction = `NOP;
		63'h074: Instruction = `NOP;
		63'h078: Instruction = 32'hB2048D29; // 0x123
		63'h07c: Instruction = `NOP;
		63'h080: Instruction = `NOP;
		63'h084: Instruction = 32'hD37F3129; // shift
		63'h088: Instruction = `NOP;
		63'h08c: Instruction = `NOP;
		63'h090: Instruction = 32'hB2115929; // 0x456
		63'h094: Instruction = `NOP;
		63'h098: Instruction = `NOP;
		63'h09c: Instruction = 32'hD37F3129; // shift
		63'h0a0: Instruction = `NOP;
		63'h0a4: Instruction = `NOP;
		63'h0a8: Instruction = 32'hB21E2529; // 0x789
		63'h0ac: Instruction = `NOP;
		63'h0b0: Instruction = `NOP;
		63'h0b4: Instruction = 32'hD37F3129; // shift
		63'h0b8: Instruction = `NOP;
		63'h0bc: Instruction = `NOP;
		63'h0c0: Instruction = 32'hB22AF129; // 0xabc
		63'h0c4: Instruction = `NOP;
		63'h0c8: Instruction = `NOP;
		63'h0cc: Instruction = 32'hD37F3129; // shift
		63'h0d0: Instruction = `NOP;
		63'h0d4: Instruction = `NOP;
		63'h0d8: Instruction = 32'hB237BD29; // 0xdef
		63'h0dc: Instruction = `NOP;
		63'h0e0: Instruction = `NOP;
		63'h0e4: Instruction = 32'hD37F1129; // shift 4
		63'h0e8: Instruction = `NOP;
		63'h0ec: Instruction = `NOP;
		63'h0f0: Instruction = 32'hF80283E9; // stur
		63'h0f4: Instruction = `NOP;
		63'h0f8: Instruction = `NOP;
		63'h0fc: Instruction = `NOP;
		63'h100: Instruction = 32'hF84283EA; // ldur
		default: Instruction = `NOP;
        endcase
    end
endmodule   
