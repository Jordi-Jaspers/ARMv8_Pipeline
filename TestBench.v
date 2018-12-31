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
	reg Clk;
    reg Rst;
    reg [63:0] startPC;
    reg [7:0] passed;
    reg [15:0] counter;

	// Outputs -- zie Pipeline.v
	wire [63:0] dMemOut;
	wire [63:0] FetchedPC;
	
	// Instantiate the Unit Under Test (UUT)
	Pipeline uut (
		.Clk(Clk), 
		.Rst(Rst), 
		.startPC(startPC), 
		.dMemOut(dMemOut),
		.FetchedPC(FetchedPC)
	);

    /* TestBench Waarden vergelijken */

	initial begin
		// Initialize Inputs && even wachten dat alles gereset is.
		Rst = 1'b1;
		startPC = 64'b0;
		passed = 8'b0;
		counter = 16'b0;
		#300

		Rst = 1'b0;
		
		$display("Current FetchedPC: 0x%H", FetchedPC);
		#60
		while(FetchedPC < 64'h058)
		begin
			$display("Current FetchedPC: 0x%H", FetchedPC);
			#60;	
		end
		
		/* wachten totdat we in de writeback stadium zijn. anders kreeg ik fout addressen. */
		#240

        Test(dMemOut, 64'hF, "Results of Program 1", passed);
        while (FetchedPC < 64'h100)
        begin
            #60
            $display("CurrentPC:%h",FetchedPC);
        end
        
        #240

        Test(dMemOut, 64'h123456789abcdef0, "Results of Program 2", passed);
        
        isGeslaagd(passed, 2);
        $finish;
	end
	  

    /* Infinite Loop detection */
    initial begin
        Clk = 0;
    end
    always
    begin
        #30 Clk = ~Clk;
        counter = counter + 1;
    end

        always@(*)
        begin
            if(counter >= 16'hFFFF)
            begin
                $display("Counter Timer Expired - Possible Infinite Loop");
                $finish;
            end
        end
endmodule