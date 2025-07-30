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
  virtual alu_if.DRV drv_vif;
  covergroup drv_cg;
    MODE_cp 	 : coverpoint tx.MODE;
    INP_VALID_cp : coverpoint tx.INP_VALID;
    A_cp       : coverpoint tx.OPA {
      					bins all_zeros = {0};
      					bins max_val = {2**`DATA_WIDTH-1};
      					bins opa = {[(2**`DATA_WIDTH-1):0]};
   				   }
    B_cp : coverpoint tx.OPB {
      				bins all_zeros = {0};
      				bins max_val = {2**`DATA_WIDTH-1};
      				bins opb = {[(2**`DATA_WIDTH-1):0]};
   			    }
    CIN_cp : coverpoint tx.CIN;
    CMD_cp : coverpoint tx.CMD;    

    CMD_x_INP_VALID  : cross CMD_cp,INP_VALID_cp;
    MODE_x_INP_VALID : cross MODE_cp,INP_VALID_cp;
    MODE_x_CMD       : cross MODE_cp,CMD_cp;
  endgroup
    
    
    
  function new(mailbox #(alu_transaction) mbx_gd , 
			 mailbox #(alu_transaction) mbx_dr, 
			 virtual alu_if drv_vif);
    this.mbx_gd = mbx_gd;
    this.mbx_dr = mbx_dr;
    this.drv_vif = drv_vif;
    drv_cg = new();
  endfunction
  
  task drive_inputs();
    drv_vif.drv_cb.OPA <= tx.OPA;
    drv_vif.drv_cb.OPB <= tx.OPB;
    drv_vif.drv_cb.CIN <= tx.CIN;
    drv_vif.drv_cb.MODE <= tx.MODE;
    drv_vif.drv_cb.INP_VALID <=  tx.INP_VALID;
    drv_vif.drv_cb.CMD <= tx.CMD;
    drv_cg.sample();
  endtask


  task start();
    int single_op_arithmetic[] 	= {4,5,6,7};
    int single_op_logical[] 	= {6,7,8,9,10,11};
    int two_op_arithmetic[] 	= {0,1,2,3,8,9,10};
    int two_op_logical[] 	= {0,1,2,3,4,5,12,13};

    repeat(3)@(drv_vif.drv_cb);
    for(int i = 0; i < `num_transaction; i++) begin
      tx = new();
      mbx_gd.get(tx);

      tx.CMD.rand_mode(1);
      tx.MODE.rand_mode(1);

      if(tx.INP_VALID == 2'b11 || tx.INP_VALID == 2'b00) begin 
        $display("%0t| DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,tx.MODE,tx.INP_VALID,tx.CMD, tx.OPA,tx.OPB,tx.CIN);
    	drive_inputs();
        if(((tx.MODE == 1)) && (tx.CMD == 4'b1010 || tx.CMD == 4'b1001))
          repeat(2)@(drv_vif.drv_cb);
        else
          repeat(1)@(drv_vif.drv_cb);
        mbx_dr.put(tx); //putting in reference model mailbox

      end 

      else begin 
        if(tx.INP_VALID == 2'b01 || tx.INP_VALID == 2'b10) begin
          if(tx.MODE == 0) begin 
            if(tx.CMD inside{single_op_logical}) begin 
              $display("%0t  | DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,tx.MODE,tx.INP_VALID,tx.CMD, tx.OPA,tx.OPB,tx.CIN);
              drive_inputs();
              repeat(1)@(drv_vif.drv_cb);
              mbx_dr.put(tx);
            end 
            else begin 
               $display("%0t | DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,tx.MODE,tx.INP_VALID,tx.CMD, tx.OPA,tx.OPB,tx.CIN);
              drive_inputs();

              tx.MODE.rand_mode(0);
              tx.CMD.rand_mode(0);

              mbx_dr.put(tx);
              for(int i =0; i < 16; i++) begin 
                repeat(1)@(drv_vif.drv_cb);
                void'(tx.randomize());
                drive_inputs();
                $display(" %0d |%0t   DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",i,$time,tx.MODE,tx.INP_VALID,tx.CMD, tx.OPA,tx.OPB,tx.CIN);
                mbx_dr.put(tx);
                if(tx.INP_VALID == 2'b11) begin 
                  break;
                end 
              end 

            end 

          end 

          else begin 
            if(tx.CMD inside {single_op_arithmetic}) begin 
              $display("%0t DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,tx.MODE,tx.INP_VALID,tx.CMD, tx.OPA,tx.OPB,tx.CIN);
              drive_inputs();
              mbx_dr.put(tx);
            end 
            else begin 
              $display("%0t DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,tx.MODE,tx.INP_VALID,tx.CMD, tx.OPA,tx.OPB,tx.CIN);
              tx.MODE.rand_mode(0);
              tx.CMD.rand_mode(0);
              drive_inputs();
              mbx_dr.put(tx);
              for(int i = 0; i < 16; i++) begin 
                repeat(1)@(drv_vif.drv_cb);
                void'(tx.randomize());
                drive_inputs();
                $display("%0d |[%0t] DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",i,$time,tx.MODE,tx.INP_VALID,tx.CMD, tx.OPA,tx.OPB,tx.CIN);
                mbx_dr.put(tx);
                if(tx.INP_VALID == 2'b11) begin 
                  if(tx.CMD == 9 || tx.CMD == 10)
                    repeat(1)@(drv_vif.drv_cb);
                  break;
                end 
              
              end 
            end 

          end 
        end 
      end 
      if((tx.CMD == 4'b1010 || tx.CMD == 4'b1001) && tx.MODE == 1)begin
        repeat(1)@(drv_vif.drv_cb);
      end
      repeat(1)@(drv_vif.drv_cb);
    end
  endtask
endclass
