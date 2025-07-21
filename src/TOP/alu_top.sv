`include "alu_defines.sv"
`include "alu_design.v"
`include "alu_interface.sv"
`include "alu_package.sv"

module top(); 
    //Importing the alu package 
    import alu_package ::*; 
    //Declaring variables for clock and reset 
    bit clk; 
    bit reset; 
 
  //Generating the clock 
  initial 
    begin 
      clk = 0;
     forever #10 clk=~clk;  
    end 
 
  //Asserting and de-asserting the reset 
  initial 
    begin 
      reset=1; 
      #100; 
      reset=0;
      #300;
      reset = 1;
      #200;
      reset = 0;
    end
  
//Instantiating the interface 
  alu_if intrf(clk,reset); 
  
//Instantiating the DUV 
  alu DUV(.OPA(intrf.OPA), 
          .OPB(intrf.OPB), 
          .RES(intrf.RES), 
          .CIN(intrf.CIN), 
          .CE(intrf.CE),
          .MODE(intrf.MODE),
          .INP_VALID(intrf.INP_VALID),
          .CMD(intrf.CMD),
          .ERR(intrf.ERR),
          .OFLOW(intrf.OFLOW),
          .COUT(intrf.COUT),
          .G(intrf.G),
          .L(intrf.L),
          .E(intrf.E),
          .CLK(clk), 
          .RST(reset)
       ); 


  alu_test test;
  initial begin
    //Instantiating the Test  
      test = new(intrf.DRV,intrf.MON,intrf.REF_SB); 
  end

  initial 
   begin
   	test.run(); 
    	#500; 
    	$finish();
   end 
 
endmodule
