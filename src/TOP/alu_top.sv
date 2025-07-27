`include "alu_design.v"
`include "alu_if.sv"
`include "alu_pkg.sv"

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
      @(posedge clk);
      reset=1;
      #10;
      reset=0;
      #300;
      reset = 1;
      #200;
      reset = 0;
    end

//Instantiating the interface
  alu_if intrf(clk,reset);

//Instantiating the DUV
  ALU_DESIGN DUV(.OPA(intrf.OPA),
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


  //Instantiating the Test
    alu_test tb = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test1 tb1   = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test2 tb2   = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test3 tb3   = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test4 tb4   = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test5 tb5   = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test6 tb6   = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test7 tb7   = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test8 tb8   = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test9 tb9   = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test10 tb10 = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test11 tb11 = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test12 tb12 = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test13 tb13 = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test14 tb14 = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test15 tb15 = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test16 tb16 = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test17 tb17 = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test18 tb18 = new(intrf.DRV,intrf.MON,intrf.REF_SB);
    test_regression tb_regression  = new(intrf.DRV,intrf.MON,intrf.REF_SB);


//Calling the test's run task which starts the execution of the testbench architecture
  initial
    begin
        tb_regression.run();
        tb.run();
        tb1.run();
        tb2.run();
        tb3.run();
        tb4.run();
        tb5.run();
        tb6.run();
        tb7.run();
        tb8.run();
        tb9.run();
        tb10.run();
        tb11.run();
        tb12.run();
        tb13.run();
        tb14.run();
        tb15.run();
        tb16.run();
        tb17.run();
        tb18.run();
        $finish();
   end

endmodule
