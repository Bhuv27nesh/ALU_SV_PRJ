`include "alu_defines.sv"

interface alu_if(input bit clk,reset);
//Declaring signals with width
  logic [`DATA_WIDTH-1:0] OPA,OPB;
  logic [(2*`DATA_WIDTH)-1:0] RES;
  logic CIN,CE,MODE;
  logic [1:0] INP_VALID;
  logic[`CMD_WIDTH-1:0] CMD;
  logic ERR,OFLOW,COUT,G,L,E;
  
 //Clocking block for driver
  clocking drv_cb@(posedge clk or posedge reset);
 //Specifying the values for input and output skews
  default input #0 output #0;
 //Declaring signals without widths, but specifying the direction
  output OPA,OPB,CIN,CE,MODE,INP_VALID,CMD;
  input reset;
  endclocking
  
 //Clocking block for monitor
  clocking mon_cb@(posedge clk or posedge reset);
  //Specifying the values for input and output skews
  default input #0 output #0;
  //Declaring signals without widths, but specifying the direction
  input ERR,RES,OFLOW,COUT,G,L,E;
  endclocking
  
 //clocking block for reference model
  clocking ref_cb@(posedge clk);
  //Specifying the values for input and output skews
  default input #0 output #0;
  input reset;
  endclocking
  
//modports for driver, monitor and reference model
 modport DRV(clocking drv_cb);
 modport MON(clocking mon_cb);
 modport REF_SB(clocking ref_cb);
endinterface
