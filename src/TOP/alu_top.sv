`include "alu_if.sv"
`include "alu_pkg.sv"
`include "alu.v"

module top;
  //Importing the alu package 
  import alu_pkg ::*;  
  //Declaring variables for clock and reset  
  bit clk;
  bit reset;
  bit CE; 

  //Generating the clock 
  initial 
    begin 
      clk = 0;
     forever #10 clk=~clk;  
    end 

  //Asserting and de-asserting the reset 
  initial begin  
    reset = 0;
    #10;
    CE = 0;
    reset = 1;
    #300;
    CE = 1;
    #200;
    reset = 0;
  end

//Instantiating the interface 
  alu_if intrf(clk,RST,CE);

//Instantiating the DUV
  ALU_DESIGN  DUT(   .CLK(clk),
                     .RST(reset),
                     .CE(CE),
                     .INP_VALID(intrf.INP_VALID),
                     .MODE(intrf.MODE),
                     .CMD(intrf.CMD),
                     .CIN(intrf.CIN),
                     .ERR(intrf.ERR),
                     .RES(intrf.RES),
                     .OPA(intrf.OPA),
                     .OPB(intrf.OPB),
                     .OFLOW(intrf.OFLOW),
                     .COUT(intrf.COUT),
                     .G(intrf.G),
                     .L(intrf.L),
                     .E(intrf.E)
               );
 
  //Instantiating the Test 
  alu_test tb = new(intrf.DRV,intrf.MON,intrf.REF_MOD);
  test_single_op_arith tb1 = new(intrf.DRV,intrf.MON,intrf.REF_MOD);
  test_two_op_arith tb2 = new(intrf.DRV,intrf.MON,intrf.REF_MOD);
  test_single_op_logic tb3 = new(intrf.DRV,intrf.MON,intrf.REF_MOD);
  test_two_op_logic tb4 = new(intrf.DRV,intrf.MON,intrf.REF_MOD);
  test_regression tb_regression = new(intrf.DRV,intrf.MON,intrf.REF_MOD);


//Calling the test's run task which starts the execution of the testbench architecture 

  initial begin
    tb_regression.run();
    //tb.run();
    //tb1.run();
    //tb2.run();
    //tb3.run();
    //tb4.run();

    #10;
    $finish;

  end

endmodule

  
