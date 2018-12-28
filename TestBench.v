module TestBench;
   task Test;
      input [63:0]   GekregenWaarde;
      input [63:0]   VerwachteWaarde;
      input [256:0]  testType;
      inout [7:0]    passed;
      
      if(GekregenWaarde == VerwachteWaarde)
      begin 
         $display ("%s passed", testType); 
         passed = passed + 1; 
      end
      else  
         $display ("%s failed: 0x%x should be 0x%x", testType, GekregenWaarde, VerwachteWaarde);
   endtask
   
   task isGeslaagd;
      input [7:0] passed;
      input [7:0] aantalTests;
      
      if(passed == aantalTests)
         $display ("All tests passed");
      else 
         $display("Some tests failed: %d of %d passed", passed, aantalTests);
   endtask
   
   // Inputs
   reg 		  		Clk;
   reg 		  		Rst;
   reg [63:0] 	  	startPC;
   reg [7:0] 	  	passed;
   reg [15:0] 	  	Counter;
 	  
   // Outputs
   wire [63:0] 	  dMemOut;
   wire [63:0] 	  currentPC;
 	  
   
   // Instantiate the Unit Under Test (UUT)
   SingleCycle TeTestenUnit (
		.Clk(Clk), 
		.Rst(Rst), 
	   .startPC(startPC),
		.currentPC(currentPC),
		.dMemOut(dMemOut)
	);
   
   initial 
   begin
      // Initialize Inputs
      Rst = 1;
      startPC = 0;
      passed = 0;

      // Initialize Watchdog timer
      Counter = 0;
      
      
      // Wait for global reset
      #120
      
      #1
      Rst = 0; 
      startPC = 0;

      #120
	
      // ***********************************************************
      // Hier blijft de unit testen tot de laatste instructie is 
      // geweest en als het in een ondeindige loop terecht zou komen
      // dan slaat de counter in de het hele systeem na 64 000
      // cycles stopt.
      // ***********************************************************

   while (currentPC < 64'h30)
	begin
	   #120
	   $display("CurrentPC:%h", currentPC);
	   
	end
      #120	
      Test(dMemOut, 64'h2, "Results of Program 1", passed);
      isGeslaagd(passed, 1); 	
      $finish;
   end
   
   initial 
   begin
      Clk = 0;
   end
   
   always 
   begin
      #60 Clk = ~Clk;
      #60 Clk = ~Clk;
      Counter = Counter + 1;
     
   end

   always @*
     if (Counter == 16'hFFFF)
     begin
     	$display("Infinite loop, programma sluiten!!");
      $finish;
     end
   
endmodule


