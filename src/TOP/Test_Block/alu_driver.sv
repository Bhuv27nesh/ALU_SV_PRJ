`include "alu_defines.sv"

class alu_driver;
//PROPERTIES  
  //ALU transaction class handle
  alu_transaction tx;
  //Mailbox for generator to driver connection
  mailbox #(alu_transaction) mbx_gd;
  //Mailbox for driver to reference model connection
  mailbox #(alu_transaction) mbx_dr;
  //Virtual interface with driver modport and it's instance 
  virtual alu_if.DRV alu_vif;
  //FUNCTIONAL COVERAGE for inputs
  covergroup drv_cg;
    A_cp           	: coverpoint tx.OPA       { bins opa = {[0:2**`DATA_WIDTH]};}
    B_cp           	: coverpoint tx.OPB       { bins opb = {[0:2**`DATA_WIDTH]};}
    CIN_cp        	: coverpoint tx.CIN       { bins cin[]= {0,1};}
    CE_cp          	: coverpoint tx.CE        { bins ce[]= {0,1};}
    MODE_cp        	: coverpoint tx.MODE      { bins mode[]= {0,1};}
    INP_VALID_cp   	: coverpoint tx.INP_VALID { bins inp_valid = {[0:`CMD_WIDTH]};}
    CMD_1         	: coverpoint tx.CMD       { bins cmd = {[0:10]} iff (tx.MODE == 1);}
    CMD_0         	: coverpoint tx.CMD       { bins cmd = {[0:13]} iff (tx.MODE == 0);}   
    
    MODE_cp_x_CMD_1    	: cross MODE_cp,CMD_1;
    MODE_cp_x_CMD_0    	: cross MODE_cp,CMD_0;

  endgroup

//METHODS
  //Explicitly overriding the constructor to make mailbox connection from driver
  //to generator, to make mailbox connection from driver to reference model and
  //to connect the virtual interface from driver to enviornment 
  // alu_drv class constructor
  function new (mailbox #(alu_transaction) mbx_gd,
    		mailbox #(alu_transaction) mbx_dr,
    		virtual alu_if alu_vif);
    this.mbx_gd = mbx_gd;
    this.mbx_dr = mbx_dr;
    this.alu_vif = alu_vif;
   //Creating the object for covergroup
    drv_cg=new();
  endfunction

  //Task to drive the stimuli to the interface
  task start ();
    repeat (5) @(alu_vif.drv_cb or alu_vif.reset);		//Asynchronous 
    for (int i = 0; i < `num_transactions; i++) 
     begin
      tx=new();
      //Getting the transaction from generator
      mbx_gd.get (tx);
      
      // on resetting 
      if (alu_vif.drv_cb.reset == 1) 
      begin
        repeat (1) @(alu_vif.drv_cb) 
	begin
          alu_vif.drv_cb.OPA       <= 'b0;
          alu_vif.drv_cb.OPB       <= 'b0;
          alu_vif.drv_cb.CIN       <= 'b0;
          alu_vif.drv_cb.CE        <= 'b0;
          alu_vif.drv_cb.MODE      <= 'b0;
          alu_vif.drv_cb.INP_VALID <= 'b0;
          alu_vif.drv_cb.CMD       <= 'b0;
          repeat (1) @(alu_vif.drv_cb); 
	  $display("--------------------------------------------------------------------------------------------------------------");          
          $display ("%0t | DRIVER: A = %0d | B =%0d | CIN = %0d | RST = %d | CE = %0d | MODE =%0d | INPVALID = %0d | CMD = %0d", $time,alu_vif.drv_cb.OPA, alu_vif.drv_cb.OPB, alu_vif.drv_cb.CIN, alu_vif.drv_cb.reset,alu_vif.drv_cb.CE, alu_vif.drv_cb.MODE, alu_vif.drv_cb.INP_VALID, alu_vif.drv_cb.CMD);
        end
      end
      else 
        repeat (1) @(alu_vif.drv_cb) 
	  begin
           	alu_vif.drv_cb.OPA       <= tx.OPA;
      		alu_vif.drv_cb.OPB       <= tx.OPB;
      		alu_vif.drv_cb.CIN       <= tx.CIN;
      		alu_vif.drv_cb.CE        <= tx.CE;
      		alu_vif.drv_cb.MODE      <= tx.MODE;
      		alu_vif.drv_cb.INP_VALID <= tx.INP_VALID;
      		alu_vif.drv_cb.CMD       <= tx.CMD;
      		repeat (1) @(alu_vif.drv_cb);
	  	$display("--------------------------------------------------------------------------------------------------------------");          
		$display ("%0t | DRIVER: A = %0d | B =%0d | CIN = %0d | RST = %d | CE = %0d | MODE =%0d | INPVALID = %0d | CMD = %0d", $time,alu_vif.drv_cb.OPA, alu_vif.drv_cb.OPB, alu_vif.drv_cb.CIN, alu_vif.drv_cb.reset,alu_vif.drv_cb.CE, alu_vif.drv_cb.MODE, alu_vif.drv_cb.INP_VALID, alu_vif.drv_cb.CMD);
      		mbx_dr.put(tx);
      		drv_cg.sample();
                $display("INPUT FUNCTIONAL COVERAGE = %0d", drv_cg.get_coverage());
      	 end
    end
  endtask
endclass
