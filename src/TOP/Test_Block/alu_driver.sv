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
               virtual alu_if alu_vif);
    this.mbx_gd = mbx_gd;
    this.mbx_dr = mbx_dr;
    this.alu_vif = alu_vif;
    drv_cg = new();
  endfunction


  // DRIVER MAIN TASK
  task start();
    repeat (5) @(alu_vif.drv_cb);

    for (int i = 0; i < `num_transactions; i++) begin
      tx = new();
      mbx_gd.get(tx);
      tx.MODE.rand_mode(1);
      tx.CMD.rand_mode(1);


      // Handle Reset
      if (alu_vif.drv_cb.reset == 1) begin
        alu_vif.drv_cb.OPA       <= 'd0;
        alu_vif.drv_cb.OPB       <= 'd0;
        alu_vif.drv_cb.CIN       <= 'd0;
        alu_vif.drv_cb.CE        <= 'd0;
        alu_vif.drv_cb.MODE      <= 'd0;
        alu_vif.drv_cb.INP_VALID <= 'd0;
        alu_vif.drv_cb.CMD       <= 'd0;
        repeat (1) @(alu_vif.drv_cb);
        mbx_dr.put(tx);
        $display("%0t | DRIVER: Reset applied", $time);
      end

      // Proceed only if CE is active
      if (alu_vif.drv_cb.CE) begin

        if ((tx.MODE == 1 && !(tx.CMD inside {[0:10]})) || (tx.MODE == 0 && !(tx.CMD inside {[0:13]})) || (tx.INP_VALID == 2'b00)) begin
                tx.ERR  = 1'b1;
                tx.RES  = 'd0;
                tx.OFLOW = 'd0;
                tx.COUT         = 'd0;
                tx.G    = 'd0;
                tx.L    = 'd0;
                tx.E    = 'd0;

                alu_vif.drv_cb.OPA       <= tx.OPA;
                alu_vif.drv_cb.OPB       <= tx.OPB;
                alu_vif.drv_cb.CIN       <= tx.CIN;
                alu_vif.drv_cb.CE        <= tx.CE;
                alu_vif.drv_cb.MODE      <= tx.MODE;
                alu_vif.drv_cb.INP_VALID <= tx.INP_VALID;
                alu_vif.drv_cb.CMD       <= tx.CMD;

                repeat (1) @(alu_vif.drv_cb);
                mbx_dr.put(tx);
                $display("--------------------------------------------------------------------------------------------------------------");
                $display("%0t | DRIVER: A = %0d | B =%0d | CIN = %0d | RST = %d | CE = %0d | MODE =%0d | INPVALID = %0d | CMD = %0d", $time,
                    alu_vif.drv_cb.OPA, alu_vif.drv_cb.OPB, alu_vif.drv_cb.CIN,
                    alu_vif.drv_cb.reset, alu_vif.drv_cb.CE, alu_vif.drv_cb.MODE,
                    alu_vif.drv_cb.INP_VALID, alu_vif.drv_cb.CMD);

        end

        // Case 1: Single operand commands (INC/DEC A or B)
        if (((tx.MODE == 1) && (tx.INP_VALID == 2'b01) && (tx.CMD inside {4'b0100, 4'b0101})) ||
            ((tx.MODE == 1) && (tx.INP_VALID == 2'b10) && (tx.CMD inside {4'b0110, 4'b0111})) ||
            ((tx.MODE == 0) && (tx.INP_VALID == 2'b01) && (tx.CMD inside {4'b0110, 4'b1000, 4'b1001})) ||
            ((tx.MODE == 0) && (tx.INP_VALID == 2'b10) && (tx.CMD inside {4'b0111, 4'b1010, 4'b1011}))) begin

          alu_vif.drv_cb.OPA       <= tx.OPA;
          alu_vif.drv_cb.OPB       <= tx.OPB;
          alu_vif.drv_cb.CIN       <= tx.CIN;
          alu_vif.drv_cb.CE        <= tx.CE;
          alu_vif.drv_cb.MODE      <= tx.MODE;
          alu_vif.drv_cb.INP_VALID <= tx.INP_VALID;
          alu_vif.drv_cb.CMD       <= tx.CMD;
          repeat (1) @(alu_vif.drv_cb);
          mbx_dr.put(tx);
          $display("--------------------------------------------------------------------------------------------------------------");
          $display("%0t | DRIVER: A = %0d | B =%0d | CIN = %0d | RST = %d | CE = %0d | MODE =%0d | INPVALID = %0d | CMD = %0d", $time,
                    alu_vif.drv_cb.OPA, alu_vif.drv_cb.OPB, alu_vif.drv_cb.CIN,
                    alu_vif.drv_cb.reset, alu_vif.drv_cb.CE, alu_vif.drv_cb.MODE,
                    alu_vif.drv_cb.INP_VALID, alu_vif.drv_cb.CMD);
        end

        // Case 2: INP_VALID not 2'b11: wait till 2'b11 or timeout
        else if ((tx.INP_VALID != 2'b11) || (tx.INP_VALID == 2'b00)) begin
          alu_vif.drv_cb.OPA       <= tx.OPA;
          alu_vif.drv_cb.OPB       <= tx.OPB;
          alu_vif.drv_cb.CIN       <= tx.CIN;
          alu_vif.drv_cb.CE        <= tx.CE;
          alu_vif.drv_cb.MODE      <= tx.MODE;
          alu_vif.drv_cb.INP_VALID <= tx.INP_VALID;
          alu_vif.drv_cb.CMD       <= tx.CMD;
          @(alu_vif.drv_cb);
          tx.MODE.rand_mode(0);
          tx.CMD.rand_mode(0);
          mbx_dr.put(tx);
          $display("--------------------------------------------------------------------------------------------------------------");
          $display("%0t | DRIVER: A = %0d | B =%0d | CIN = %0d | RST = %d | CE = %0d | MODE =%0d | INPVALID = %0d | CMD = %0d", $time,
                    alu_vif.drv_cb.OPA, alu_vif.drv_cb.OPB, alu_vif.drv_cb.CIN,
                    alu_vif.drv_cb.reset, alu_vif.drv_cb.CE, alu_vif.drv_cb.MODE,
                    alu_vif.drv_cb.INP_VALID, alu_vif.drv_cb.CMD);

          for (int j = 0; j < 16; j++) begin
            @(alu_vif.drv_cb);
            void'(tx.randomize());
            @(alu_vif.drv_cb);

            if (tx.INP_VALID == 2'b11) begin
                alu_vif.drv_cb.OPA       <= tx.OPA;
                alu_vif.drv_cb.OPB       <= tx.OPB;
                alu_vif.drv_cb.CIN       <= tx.CIN;
                alu_vif.drv_cb.CE        <= tx.CE;
                alu_vif.drv_cb.MODE      <= tx.MODE;
                alu_vif.drv_cb.INP_VALID <= tx.INP_VALID;
                alu_vif.drv_cb.CMD       <= tx.CMD;
                @(alu_vif.drv_cb);
                mbx_dr.put(tx);
                $display("--------------------------------------------------------------------------------------------------------------");
                $display("%0t | DRIVER: A = %0d | B =%0d | CIN = %0d | RST = %d | CE = %0d | MODE =%0d | INPVALID = %0d | CMD = %0d", $time,
                    alu_vif.drv_cb.OPA, alu_vif.drv_cb.OPB, alu_vif.drv_cb.CIN,
                    alu_vif.drv_cb.reset, alu_vif.drv_cb.CE, alu_vif.drv_cb.MODE,
                    alu_vif.drv_cb.INP_VALID, alu_vif.drv_cb.CMD);
                break;
            end
          end

          drv_cg.sample();
          $display("--------------------------------------------------------------------------------------------------------------");
          $display("%0t | DRIVER: A = %0d | B =%0d | CIN = %0d | RST = %d | CE = %0d | MODE =%0d | INPVALID = %0d | CMD = %0d", $time,
                    alu_vif.drv_cb.OPA, alu_vif.drv_cb.OPB, alu_vif.drv_cb.CIN,
                    alu_vif.drv_cb.reset, alu_vif.drv_cb.CE, alu_vif.drv_cb.MODE,
                    alu_vif.drv_cb.INP_VALID, alu_vif.drv_cb.CMD);

        end

        // Case 3: Regular valid transaction
        else begin
          alu_vif.drv_cb.OPA       <= tx.OPA;
          alu_vif.drv_cb.OPB       <= tx.OPB;
          alu_vif.drv_cb.CIN       <= tx.CIN;
          alu_vif.drv_cb.CE        <= tx.CE;
          alu_vif.drv_cb.MODE      <= tx.MODE;
          alu_vif.drv_cb.INP_VALID <= tx.INP_VALID;
          alu_vif.drv_cb.CMD       <= tx.CMD;
          repeat(1) @(alu_vif.drv_cb);
          mbx_dr.put(tx);
          $display("--------------------------------------------------------------------------------------------------------------");
          $display("%0t | DRIVER: A = %0d | B =%0d | CIN = %0d | RST = %d | CE = %0d | MODE =%0d | INPVALID = %0d | CMD = %0d", $time,
                    alu_vif.drv_cb.OPA, alu_vif.drv_cb.OPB, alu_vif.drv_cb.CIN,
                    alu_vif.drv_cb.reset, alu_vif.drv_cb.CE, alu_vif.drv_cb.MODE,
                    alu_vif.drv_cb.INP_VALID, alu_vif.drv_cb.CMD);
          drv_cg.sample();
          $display("INPUT FUNCTIONAL COVERAGE = %0.2f%%", drv_cg.get_coverage());
        end
      end
    end

  endtask

endclass
