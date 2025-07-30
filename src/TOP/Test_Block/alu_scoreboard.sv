`include "alu_defines.sv"

class alu_scoreboard;
  alu_transaction ref_sb_txn;//from reference
  alu_transaction mon_sb_txn;//from monitor
  // mailbox for monitor and scoreboard
  mailbox #(alu_transaction) mbx_ms;
  // mailbox for ref model and scoreboard
  mailbox #(alu_transaction) mbx_rs;

  int MATCH = 0;
  int MISMATCH = 0;

//METHODS
  //Explicitly overriding the constructor to make mailbox connection from monitor
  //to scoreboard, to make mailbox connection from reference model to scoreboard
  function new(mailbox #(alu_transaction) mbx_rs,
	       mailbox #(alu_transaction) mbx_ms);
    this.mbx_ms = mbx_ms;
    this.mbx_rs = mbx_rs;
  endfunction

//Task which collects data_out from reference model and scoreboard 
//and sotres them in their respective memories
  task start();
    for(int i = 0; i < `num_transaction; i++) begin 
      ref_sb_txn = new();
      mon_sb_txn = new();
	begin
          $display(" ---------------------REFERENCE_MODEL----------------- ");
          mbx_ms.get(mon_sb_txn); 
          mbx_rs.get(ref_sb_txn); 

	  $display("%0t |INPUTS | OPA = %0d | OPB = %0d | CIN = %0d |INP_VALID == %2b | MODE = %0b | CMD = %4b",$time,ref_sb_txn.OPA,ref_sb_txn.OPB,ref_sb_txn.CIN,ref_sb_txn.INP_VALID,ref_sb_txn.MODE,ref_sb_txn.CMD);
          $display("");
          $display("%0t |MONITOR | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b |",$time,mon_sb_txn.RES,mon_sb_txn.OFLOW,mon_sb_txn.COUT,mon_sb_txn.G,mon_sb_txn.L,mon_sb_txn.E,mon_sb_txn.ERR);
          $display("");
          $display("%0t |REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b |",$time,ref_sb_txn.RES,ref_sb_txn.OFLOW,ref_sb_txn.COUT,ref_sb_txn.G,ref_sb_txn.L,ref_sb_txn.E,ref_sb_txn.ERR);
          $display("");
          compare_report();
          $display("");
        end   
    end
     
    $display(" ---------------------REFERENCE_MODEL----------------- ");
    $display("TOTAL MATCH : %0d | TOTAL MISMATCH : %0d",MATCH,MISMATCH);
  endtask


 task compare_report();
    if(
      mon_sb_txn.RES === ref_sb_txn.RES &&
      mon_sb_txn.OFLOW === ref_sb_txn.OFLOW &&
      mon_sb_txn.COUT === ref_sb_txn.COUT &&
      mon_sb_txn.G === ref_sb_txn.G &&
      mon_sb_txn.L === ref_sb_txn.L &&
      mon_sb_txn.E === ref_sb_txn.E &&
      mon_sb_txn.ERR === ref_sb_txn.ERR
    ) begin 
        MATCH = MATCH + 1;
        $display(" MATCH SUCCESSFUL | MATCH COUNT = %0d ",MATCH);
    end 
    else begin 
      MISMATCH = MISMATCH + 1;
      $display("MATCH FAILED | MISMATCH COUNT = %0d",MISMATCH);
    end 
  endtask

endclass
