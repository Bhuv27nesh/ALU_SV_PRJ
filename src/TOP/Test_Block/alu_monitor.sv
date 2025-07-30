`include "alu_defines.sv"

class alu_monitor;
 //ALU transaction class handle
  alu_transaction mon_trans;
  // mailbox for monitor to scoreboard
  mailbox #(alu_transaction) mbx_ms;
 //Virtual interfaces for  monitor
  virtual alu_if.MON mon_vif;

   covergroup mon_cg;
      RESULT  : coverpoint mon_trans.RES {bins result = {[0:9'b111111111]};}
      ERROR   : coverpoint mon_trans.ERR;
      EQUAL   : coverpoint mon_trans.E {bins equal   = {1};}
      GREATER : coverpoint mon_trans.G {bins greater = {1};}
      LESSER  : coverpoint mon_trans.L {bins lesser  = {1};}
      OF_LOW  : coverpoint mon_trans.OFLOW;
      COUT_CP : coverpoint mon_trans.COUT;
  endgroup
 
 // alu_monitor class constructor
  function new(virtual alu_if.MON mon_vif, mailbox #(alu_transaction) mbx_ms);
    this.mbx_ms = mbx_ms;
    this.mon_vif = mon_vif;
    mon_cg = new();
  endfunction

  task signal_drive();
    mon_trans.RES   = mon_vif.mon_cb.RES;
    mon_trans.COUT  = mon_vif.mon_cb.COUT;
    mon_trans.OFLOW = mon_vif.mon_cb.OFLOW;
    mon_trans.G     = mon_vif.mon_cb.G;
    mon_trans.L     = mon_vif.mon_cb.L;
    mon_trans.E     = mon_vif.mon_cb.E;
    mon_trans.ERR   = mon_vif.mon_cb.ERR;
    //inputs
    mon_trans.OPA = mon_vif.mon_cb.OPA;
    mon_trans.OPB = mon_vif.mon_cb.OPB;
    mon_trans.CIN = mon_vif.mon_cb.CIN;
    mon_trans.CMD = mon_vif.mon_cb.CMD;
    mon_trans.MODE = mon_vif.mon_cb.MODE;
    mon_trans.INP_VALID = mon_vif.mon_cb.INP_VALID;
    mon_cg.sample();
  endtask

  task start();
    int single_op_arithmetic [] = {4,5,6,7};
    int single_op_logical [] = {6,7,8,9,10,11};
    int count = 0;
    
    repeat(4)@(mon_vif.mon_cb);
    for(int i = 0; i < `num_transaction; i++) begin 
      mon_trans = new();
      signal_drive();

      if((mon_trans.INP_VALID == 2'b11) || mon_trans.INP_VALID == 2'b00) begin 
        signal_drive();
        if((mon_trans.MODE == 1)&& ((mon_trans.CMD == 4'b1010) || (mon_trans.CMD == 4'b1001))) begin 
          repeat(2)@(mon_vif.mon_cb);
          signal_drive();
          $display("%0t | MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.MODE,mon_trans.INP_VALID, mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.CIN);
          $display("DUT OUTPUT RECIEVED : RES == %0d | ERR = %0d",mon_trans.RES,mon_trans.ERR);
        end 
        else begin 
          repeat(1)@(mon_vif.mon_cb);
          signal_drive();
          $display("%0t | MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.MODE,mon_trans.INP_VALID,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.CIN);
          $display("DUT OUTPUT RECIEVED : RES == %0d | ERR = %0d",mon_trans.RES,mon_trans.ERR);
        end 
      end 

      else begin 
        if((mon_trans.MODE == 0) && (mon_trans.CMD inside {single_op_logical})) begin 
          repeat(1)@(mon_vif.mon_cb);
          signal_drive();
          $display("%0t |MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.MODE,mon_trans.INP_VALID,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.CIN);                    
        end 
        else if ((mon_trans.MODE == 1) && mon_trans.CMD inside {single_op_arithmetic}) begin 
          repeat(1)@(mon_vif.mon_cb);
          signal_drive();
          $display("%0t | MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.MODE,mon_trans.INP_VALID,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.CIN);
        end 
        else begin 
          for(count = 0; count < 16; count ++) begin 
            repeat(1) @(mon_vif.mon_cb);
            signal_drive();
            if(mon_trans.INP_VALID == 2'b11) begin 
              if((mon_trans.MODE == 1)&& ((mon_trans.CMD == 9) || (mon_trans.CMD == 10))) begin
                signal_drive();
                $display("%0t | MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.MODE,mon_trans.INP_VALID,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.CIN);
                $display("%0t | DUT OUTPUT RECEIVED : RES == %0d | ERR = %0d",$time,mon_trans.RES,mon_trans.ERR);
              end
                else begin
                  signal_drive();
                  $display("%0t | MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.MODE,mon_trans.INP_VALID,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.CIN);
                  $display("%0t | DUT OUTPUT RECEIVED : RES == %0d | ERR = %0d",$time,mon_trans.RES,mon_trans.ERR);
                end 
              break;
            end 
          end 
          if(count == 16) begin 
            signal_drive();
            $display("%0t | !!!ERROR!!! |MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.MODE,mon_trans.INP_VALID,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.CIN);
            $display("DUT OUTPUT : RES =  %0d | ERR = %0d", mon_trans.RES,mon_trans.ERR);
          end 
 
        end 
      end 
      if((mon_trans.MODE == 1) && ((mon_trans.CMD == 4'b1001) || (mon_trans.CMD == 4'b1010))) begin
        repeat(1)@(mon_vif.mon_cb);
      end
      repeat(1) @(mon_vif.mon_cb);
      signal_drive();
      mbx_ms.put(mon_trans);
    end 
  endtask

endclass
