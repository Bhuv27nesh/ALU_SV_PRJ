`include "alu_defines.sv"

interface alu_if(input bit clk,reset,CE);
//Declaring signals with width
  logic [`DATA_WIDTH-1:0] OPA,OPB;
  logic [(2*`DATA_WIDTH)-1:0] RES;
  logic CIN,MODE;
  logic [1:0] INP_VALID;
  logic[`CMD_WIDTH-1:0] CMD;
  logic ERR,OFLOW,COUT,G,L,E;

 //Clocking block for driver
  clocking drv_cb @(posedge clk); 
    default input #0 output #0;
    output OPA,OPB,CIN,CE,MODE,INP_VALID,CMD;
    input reset;
  endclocking

 //Clocking block for monitor
  clocking mon_cb@(posedge clk); 
    default input #0 output #0;
    input RES,OFLOW,COUT,G,L,E,ERR;
    input OPA,OPB,CIN,CE,MODE,INP_VALID,CMD;
  endclocking

 //clocking block for reference model
  clocking ref_cb @(posedge clk);
    default input #0 output #0;
    input CE,reset,clk;
  endclocking

  modport DRV (clocking drv_cb);
  modport MON(clocking mon_cb);
  modport REF_MOD(clocking ref_cb);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// reset output assertions.
    property VERIFY_RESET;
      @(posedge clk) reset |=> (RES === 9'bzzzzzzzzz && ERR === 1'bz && E === 1'bz && G === 1'bz && L === 1'bz && COUT === 1'bz && OFLOW === 1'bz);
    endproperty

    assert property(VERIFY_RESET) $info($time, "passed");else $info($time, "ERROR");


// CLOCK EN check
property CE_ASSERT;
  @(posedge clk) !(CE) |-> ##[1:$] (CE);
endproperty

assert property(CE_ASSERT)
  $info("CLK_EN PASSED");
  else
    $info("CLK_EN FAILED");

// property for 16 cycle err
property TIMEOUT_16Clk;
    @(posedge clk) disable iff(reset)(CE && (INP_VALID == 2'b01 || INP_VALID == 2'b10)) |-> !(INP_VALID == 2'b11) [*16] |-> ##1 ERR;      
endproperty
  
  assert property (TIMEOUT_16Clk)
    	    $info("passed");
    else
            $info("failed");
    
// validity
property VALID_INPUTS_CHECK;
  @(posedge clk) disable iff(reset) CE |-> not($isunknown({OPA,OPB,INP_VALID,CIN,MODE,CMD}));
endproperty

assert property(VALID_INPUTS_CHECK)
    $info("inputs valid");
  else
    $info("inputs not valid");


endinterface
