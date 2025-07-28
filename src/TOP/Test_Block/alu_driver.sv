`include "alu_defines.sv"

class alu_driver;

  // PROPERTIES
  alu_transaction tx;
  mailbox #(alu_transaction) mbx_gd;
  mailbox #(alu_transaction) mbx_dr;
  virtual alu_if.DRV alu_vif;

  // FUNCTIONAL COVERAGE
  covergroup drv_cg;
    A_cp             : coverpoint tx.OPA       { bins opa = {[0:2**`DATA_WIDTH-1]}; }
    B_cp             : coverpoint tx.OPB       { bins opb = {[0:2**`DATA_WIDTH-1]}; }
    CIN_cp           : coverpoint tx.CIN       { bins cin[] = {0,1}; }
    CE_cp            : coverpoint tx.CE        { bins ce[] = {0,1}; }
    MODE_cp          : coverpoint tx.MODE      { bins mode[] = {0,1}; }
    INP_VALID_cp     : coverpoint tx.INP_VALID { bins inp_valid[] = {0,1,2,3}; }
    CMD_1            : coverpoint tx.CMD       { bins cmd = {[0:10]} iff (tx.MODE == 1); }
    CMD_0            : coverpoint tx.CMD       { bins cmd = {[0:13]} iff (tx.MODE == 0); }
    MODE_x_CMD_1     : cross MODE_cp, CMD_1;
    MODE_x_CMD_0     : cross MODE_cp, CMD_0;
  endgroup

  // CONSTRUCTOR
  function new(mailbox #(alu_transaction) mbx_gd,
               mailbox #(alu_transaction) mbx_dr,
               virtual alu_if.DRV alu_vif);
    this.mbx_gd = mbx_gd;
    this.mbx_dr = mbx_dr;
    this.alu_vif = alu_vif;
    drv_cg = new();
  endfunction

  // DRIVER MAIN TASK
  task start();
    repeat (5) @(alu_vif.drv_cb);  

    for (int i = 0; i < `num_transactions; i++) begin

      mbx_gd.get(tx);


      if (alu_vif.drv_cb.reset == 1) begin
        @(alu_vif.drv_cb);
        alu_vif.drv_cb.OPA       <= '0;
        alu_vif.drv_cb.OPB       <= '0;
        alu_vif.drv_cb.CIN       <= 1'b0;
        alu_vif.drv_cb.CE        <= 1'b0;
        alu_vif.drv_cb.MODE      <= 1'b0;
        alu_vif.drv_cb.INP_VALID <= 2'b0;
        alu_vif.drv_cb.CMD       <= '0;
        mbx_dr.put(tx);
        $display("%0t | DRIVER: Reset applied", $time);
        continue;
      end


      if ((tx.MODE == 1 && !(tx.CMD inside {[0:10]})) ||
          (tx.MODE == 0 && !(tx.CMD inside {[0:13]})) ||
          (tx.INP_VALID == 2'b00)) begin

        tx.ERR  = 1'b1;
        tx.RES  = '0;
        tx.OFLOW = 0;
        tx.COUT = 0;
        tx.G = 0;
        tx.L = 0;
        tx.E = 0;

        @(alu_vif.drv_cb);
        alu_vif.drv_cb.OPA       <= tx.OPA;
        alu_vif.drv_cb.OPB       <= tx.OPB;
        alu_vif.drv_cb.CIN       <= tx.CIN;
        alu_vif.drv_cb.CE        <= tx.CE;
        alu_vif.drv_cb.MODE      <= tx.MODE;
        alu_vif.drv_cb.INP_VALID <= tx.INP_VALID;
        alu_vif.drv_cb.CMD       <= tx.CMD;
        mbx_dr.put(tx);

        $display("--------------------------------------------------------------------------------------------------------------");
        $display("%0t | DRIVER: A=%0d B=%0d CIN=%0d RST=%b CE=%0d MODE=%0d INP_VALID=%0d CMD=%0d ERR=%0d",
                 $time, tx.OPA, tx.OPB, tx.CIN, alu_vif.reset, tx.CE, tx.MODE, tx.INP_VALID, tx.CMD, tx.ERR);

        continue;
      end

      // Case 1: Single operand commands with specific INP_VALIDs
      if (((tx.MODE == 1) && (tx.INP_VALID == 2'b01) && (tx.CMD inside {4,5})) ||
          ((tx.MODE == 1) && (tx.INP_VALID == 2'b10) && (tx.CMD inside {6,7})) ||
          ((tx.MODE == 0) && (tx.INP_VALID == 2'b01) && (tx.CMD inside {6,8,9})) ||
          ((tx.MODE == 0) && (tx.INP_VALID == 2'b10) && (tx.CMD inside {7,10,11}))) begin

        @(alu_vif.drv_cb);
        alu_vif.drv_cb.OPA       <= tx.OPA;
        alu_vif.drv_cb.OPB       <= tx.OPB;
        alu_vif.drv_cb.CIN       <= tx.CIN;
        alu_vif.drv_cb.CE        <= tx.CE;
        alu_vif.drv_cb.MODE      <= tx.MODE;
        alu_vif.drv_cb.INP_VALID <= tx.INP_VALID;
        alu_vif.drv_cb.CMD       <= tx.CMD;
        mbx_dr.put(tx);

        $display("--------------------------------------------------------------------------------------------------------------");
        $display("%0t | DRIVER: A=%0d B=%0d CIN=%0d RST=%b CE=%0d MODE=%0d INP_VALID=%0d CMD=%0d",
                 $time, tx.OPA, tx.OPB, tx.CIN, alu_vif.reset, tx.CE, tx.MODE, tx.INP_VALID, tx.CMD);

        continue;
      end

      // Case 2: INP_VALID not 2'b11 or zero, wait or timeout handling
      if ((tx.INP_VALID != 2'b11) || (tx.INP_VALID == 2'b00)) begin

        @(alu_vif.drv_cb);
        alu_vif.drv_cb.OPA       <= tx.OPA;
        alu_vif.drv_cb.OPB       <= tx.OPB;
        alu_vif.drv_cb.CIN       <= tx.CIN;
        alu_vif.drv_cb.CE        <= tx.CE;
        alu_vif.drv_cb.MODE      <= tx.MODE;
        alu_vif.drv_cb.INP_VALID <= tx.INP_VALID;
        alu_vif.drv_cb.CMD       <= tx.CMD;
        mbx_dr.put(tx);

        $display("--------------------------------------------------------------------------------------------------------------");
        $display("%0t | DRIVER: A=%0d B=%0d CIN=%0d RST=%b CE=%0d MODE=%0d INP_VALID=%0d CMD=%0d",
                 $time, tx.OPA, tx.OPB, tx.CIN, alu_vif.reset, tx.CE, tx.MODE, tx.INP_VALID, tx.CMD);


        for (int j = 0; j < 16; j++) begin
          @(alu_vif.drv_cb);
          void'(tx.randomize());
          @(alu_vif.drv_cb);

          if (tx.INP_VALID == 2'b11) begin
            @(alu_vif.drv_cb);
            alu_vif.drv_cb.OPA       <= tx.OPA;
            alu_vif.drv_cb.OPB       <= tx.OPB;
            alu_vif.drv_cb.CIN       <= tx.CIN;
            alu_vif.drv_cb.CE        <= tx.CE;
            alu_vif.drv_cb.MODE      <= tx.MODE;
            alu_vif.drv_cb.INP_VALID <= tx.INP_VALID;
            alu_vif.drv_cb.CMD       <= tx.CMD;
            mbx_dr.put(tx);
            $display("--------------------------------------------------------------------------------------------------------------");
            $display("%0t | DRIVER: A=%0d B=%0d CIN=%0d RST=%b CE=%0d MODE=%0d INP_VALID=%0d CMD=%0d",
                     $time, tx.OPA, tx.OPB, tx.CIN, alu_vif.reset, tx.CE, tx.MODE, tx.INP_VALID, tx.CMD);
            break;
          end
        end

        drv_cg.sample();

        continue;
      end

      // Case 3: All other valid transactions

      @(alu_vif.drv_cb);
      alu_vif.drv_cb.OPA       <= tx.OPA;
      alu_vif.drv_cb.OPB       <= tx.OPB;
      alu_vif.drv_cb.CIN       <= tx.CIN;
      alu_vif.drv_cb.CE        <= tx.CE;
      alu_vif.drv_cb.MODE      <= tx.MODE;
      alu_vif.drv_cb.INP_VALID <= tx.INP_VALID;
      alu_vif.drv_cb.CMD       <= tx.CMD;
      mbx_dr.put(tx);

      $display("--------------------------------------------------------------------------------------------------------------");
      $display("%0t | DRIVER: A=%0d B=%0d CIN=%0d RST=%b CE=%0d MODE=%0d INP_VALID=%0d CMD=%0d",
               $time, tx.OPA, tx.OPB, tx.CIN, alu_vif.reset, tx.CE, tx.MODE, tx.INP_VALID, tx.CMD);

      drv_cg.sample();
      $display("INPUT FUNCTIONAL COVERAGE = %0.2f%%", drv_cg.get_coverage());

    end
  endtask

endclass
