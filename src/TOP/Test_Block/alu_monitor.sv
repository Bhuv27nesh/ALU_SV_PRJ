`include "alu_defines.sv"

class alu_monitor;
 //ALU transaction class handle  
  alu_transaction mon_tran;
 //mailbox of monitor to scoreboard 
  mailbox #(alu_transaction) mbx_ms;
  //Virtual interfaces for  monitor
  virtual alu_if.MON vif;
  
  // Coverage model to cover DUV outputs
    covergroup mon_cov;
      ERROR : coverpoint mon_tran.ERR {bins error ={0,1};}
      RESULT: coverpoint mon_tran.RES {bins result = {[0:2**`DATA_WIDTH]};}
      OF_FLOW: coverpoint mon_tran.OFLOW{bins oflow={0,1};}
      GREATER: coverpoint mon_tran.G {bins greater={0,1};}
      LESSER:  coverpoint mon_tran.L {bins lesser={0,1};}
      EQUAL :  coverpoint mon_tran.E {bins equal={0,1};}
      RESxOF : cross RESULT,OF_FLOW;
    endgroup
  // alu_monitor class constructor
  function new( virtual alu_if.MON vif, mailbox #(alu_transaction) mbx_ms);
    this.vif=vif;
    this.mbx_ms=mbx_ms; 
    mon_cov=new();
  endfunction
  
  
  task start();
    repeat(6) @(vif.mon_cb); 
    for(int i=0;i<`num_transactions;i++)
      begin
        mon_tran=new();
        repeat(1) @(vif.mon_cb)
          begin
            mon_tran.ERR=vif.mon_cb.ERR;
            mon_tran.RES=vif.mon_cb.RES;
            mon_tran.OFLOW=vif.mon_cb.OFLOW;
            mon_tran.COUT=vif.mon_cb.COUT;
            mon_tran.G=vif.mon_cb.G;
            mon_tran.L=vif.mon_cb.L;
            mon_tran.E=vif.mon_cb.E;
          end
        $display("%0t | MONITOR PASSING THE DATA TO SCOREBOARD \nERR=%0d | RES=%0d | OFLOW=%0d | COUT=%0d | G=%0d | L=%0d | E=%0d ", $time, mon_tran.ERR,mon_tran.RES,mon_tran.OFLOW,mon_tran.COUT,mon_tran.G,mon_tran.L,mon_tran.E);
        
        //Putting the collected outputs to mailbox 
        mbx_ms.put(mon_tran);
        
        //Sampling the covergroup
        mon_cov.sample();
        //$display("\n OUTPUT FUNCTIONAL COVERAGE = %0d", mon_cov.get_coverage());
        repeat(1) @(vif.mon_cb);
      end
  endtask
  
endclass
