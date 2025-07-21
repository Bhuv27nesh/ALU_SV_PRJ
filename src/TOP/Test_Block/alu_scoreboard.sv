`include "alu_defines.sv"
class alu_scoreboard;
  alu_transaction  ref_sb_txn;
  alu_transaction  mon_sb_txn;
  //mailbox of reference to scoreboard
  mailbox #(alu_transaction) mbx_rs;
  //mailbox of monitor to scoreboard
  mailbox #(alu_transaction) mbx_ms;
  int MATCH=0;
  int MISMATCH=0;

//METHODS
  //Explicitly overriding the constructor to make mailbox connection from monitor
  //to scoreboard, to make mailbox connection from reference model to scoreboard
  function new(mailbox #(alu_transaction) mbx_rs, 
	       mailbox #(alu_transaction) mbx_ms );
    this.mbx_rs=mbx_rs;
    this.mbx_ms=mbx_ms;
  endfunction

//Task which collects data_out from reference model and scoreboard 
//and sotres them in their respective memories
  task start();
    for(int i=0;i<`num_transactions;i++)
      begin
        ref_sb_txn=new();
        mon_sb_txn=new();
        mbx_rs.get(ref_sb_txn);
        mbx_ms.get(mon_sb_txn); 
        $display("\n !!!Score Board!!!");
         $display("The count is %0d,reference RES=%d | reference COUT=%d | reference E=%d | reference G=%d | reference L=%d | reference ERR=%d \n ,",MATCH,ref_sb_txn.RES,ref_sb_txn.COUT,ref_sb_txn.E,ref_sb_txn.G,ref_sb_txn.L,ref_sb_txn.ERR );
        
        $display("The count is %0d,Scoreboard RES=%d | Scoreboard COUT=%d | Scoreboard E=%d | Scoreboard G=%d | Scoreboard L=%d | Scoreboard ERR=%d \n ,",MATCH,mon_sb_txn.RES,mon_sb_txn.COUT,mon_sb_txn.E,mon_sb_txn.G,mon_sb_txn.L,mon_sb_txn.ERR );
        
        assert(ref_sb_txn.RES == mon_sb_txn.RES && ref_sb_txn.COUT == mon_sb_txn.COUT && ref_sb_txn.ERR == mon_sb_txn.ERR && ref_sb_txn.G == mon_sb_txn.G && ref_sb_txn.L == mon_sb_txn.L && ref_sb_txn.E == mon_sb_txn.E)
          begin 
            MATCH++;
            $display("Match Count equal to %d",match);
            $display("The count is %0d | reference RES=%d |  reference COUT=%d | reference E=%d | reference G=%d | reference L=%d | reference ERR=%d \n ,",MATCH,ref_sb_txn.RES,ref_sb_txn.COUT,ref_sb_txn.E,ref_sb_txn.G,ref_sb_txn.L,ref_sb_txn.ERR );
          end
        else 
          begin 
             MISMATCH++;
             $info("Mismatch count equals to  %0d",MISMATCH);
         end
        $display("-------------------------------------------------------------------");
      end
    endtask
endclass  
