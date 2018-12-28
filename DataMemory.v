/*
 *  Module: DataMemory
 *  De opslagplaats van alles gegevens pagina 267 in het boek
 *
 */

module DataMemory(ReadData , Address , WriteData , MemoryRead , MemoryWrite , Clk);
   input [63:0] WriteData;
   input [63:0] Address;

   input MemoryRead, MemoryWrite;
   input Clk;

   output reg [63:0] ReadData;
          reg [7:0]  memBank[1023:0];   
          //16 verschillende memory blokken van 64bits --> 1024 of 128bit

    //de initialisatie taak: verdelen van de memorybanks
   task init;                           
      input [63:0] addr;
      input [63:0] data;

    begin
        memBank[addr]   =  data[63:56]; 
        memBank[addr+1] =  data[55:48];
        memBank[addr+2] =  data[47:40];
        memBank[addr+3] =  data[39:32];
        memBank[addr+4] =  data[31:24];
        memBank[addr+5] =  data[23:16];
        memBank[addr+6] =  data[15:8];
        memBank[addr+7] =  data[7:0];
    end
    endtask

initial
     begin
	// Data instellen dat gebruikt wordt in instruction memory
	init( 64'h0,  64'h1);  			//Counter variable
	init( 64'h8,  64'ha);  			//deel van het masker
	init( 64'h10, 64'h5);  			//ander deel van een masker
	init( 64'h18, 64'h0ffbea7deadbeeff); 	//grote constante
	init( 64'h20, 64'h0); 			//delete
     end

    //Data uitlezen en ophalen
   always @(posedge Clk)
     begin
	if(MemoryRead)
	    begin
            ReadData[63:56]    = memBank[Address];
            ReadData[55:48]    = memBank[Address+1];
            ReadData[47:40]    = memBank[Address+2];
            ReadData[39:32]    = memBank[Address+3];
            ReadData[31:24]    = memBank[Address+4];
            ReadData[23:16]    = memBank[Address+5];
            ReadData[15:8]     = memBank[Address+6];
            ReadData[7:0]      = memBank[Address+7];
	    end
    end

   //Data schrijven en opslaan
   always @(posedge Clk)
     begin
	if(MemoryWrite)
	    begin
            memBank[Address]   = WriteData[63:56];
            memBank[Address+1] = WriteData[55:48];
            memBank[Address+2] = WriteData[47:40];
            memBank[Address+3] = WriteData[39:32];
            memBank[Address+4]= WriteData[31:24];
            memBank[Address+5] = WriteData[23:16];
            memBank[Address+6] = WriteData[15:8];
            memBank[Address+7] = WriteData[7:0];
	    end
    end
endmodule
