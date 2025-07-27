`include "alu_defines.sv"

class alu_scoreboard;

  // Transactions from Reference Model and Monitor
  alu_transaction ref_sb_txn;
  alu_transaction mon_sb_txn;

  // Mailboxes for communication
  mailbox #(alu_transaction) mbx_rs;  // Reference Model -> Scoreboard
  mailbox #(alu_transaction) mbx_ms;  // Monitor -> Scoreboard

  // Match / mismatch counters per field
  int res_match = 0, res_mismatch = 0;
  int err_match = 0, err_mismatch = 0;
  int cout_match = 0, cout_mismatch = 0;
  int oflow_match = 0, oflow_mismatch = 0;
  int g_match = 0, g_mismatch = 0;
  int l_match = 0, l_mismatch = 0;
  int e_match = 0, e_mismatch = 0;

  // Overall match/mismatch counters
  int overall_match = 0;
  int overall_mismatch = 0;

  // Constructor to bind mailboxes
  function new(mailbox #(alu_transaction) mbx_rs, mailbox #(alu_transaction) mbx_ms);
    this.mbx_rs = mbx_rs;
    this.mbx_ms = mbx_ms;
  endfunction

  // Task to run the scoreboard logic
  task start();
    for (int i = 0; i < `num_transactions; i++) begin
      // Create new transaction objects per iteration OUTSIDE fork
      ref_sb_txn = new();
      mon_sb_txn = new();

      fork
        begin
          // Get transactions from mailboxes (blocking)
          mbx_rs.get(ref_sb_txn);
          mbx_ms.get(mon_sb_txn);

          $display("\n--- Scoreboard Transaction #%0d ---", i + 1);
          $display("Reference Model: RES=%0d, COUT=%0d, ERR=%0d, OFLOW=%0d, G=%0d, L=%0d, E=%0d",
                   ref_sb_txn.RES, ref_sb_txn.COUT, ref_sb_txn.ERR, ref_sb_txn.OFLOW, ref_sb_txn.G, ref_sb_txn.L, ref_sb_txn.E);
          $display("Monitor        : RES=%0d, COUT=%0d, ERR=%0d, OFLOW=%0d, G=%0d, L=%0d, E=%0d",
                   mon_sb_txn.RES, mon_sb_txn.COUT, mon_sb_txn.ERR, mon_sb_txn.OFLOW, mon_sb_txn.G, mon_sb_txn.L, mon_sb_txn.E);
          $display("---------------------------------------------------");

          // Compare each field and update counters
          if (ref_sb_txn.RES == mon_sb_txn.RES) begin
            res_match++;
            $display("[PASS] RES match: %0d", ref_sb_txn.RES);
          end else begin
            res_mismatch++;
            $display("[FAIL] RES mismatch: Reference=%0d Monitor=%0d", ref_sb_txn.RES, mon_sb_txn.RES);
          end

          if (ref_sb_txn.ERR == mon_sb_txn.ERR) begin
            err_match++;
            $display("[PASS] ERR match: %0d", ref_sb_txn.ERR);
          end else begin
            err_mismatch++;
            $display("[FAIL] ERR mismatch: Reference=%0d Monitor=%0d", ref_sb_txn.ERR, mon_sb_txn.ERR);
          end

          if (ref_sb_txn.COUT == mon_sb_txn.COUT) begin
            cout_match++;
            $display("[PASS] COUT match: %0d", ref_sb_txn.COUT);
          end else begin
            cout_mismatch++;
            $display("[FAIL] COUT mismatch: Reference=%0d Monitor=%0d", ref_sb_txn.COUT, mon_sb_txn.COUT);
          end

          if (ref_sb_txn.OFLOW == mon_sb_txn.OFLOW) begin
            oflow_match++;
            $display("[PASS] OFLOW match: %0d", ref_sb_txn.OFLOW);
          end else begin
            oflow_mismatch++;
            $display("[FAIL] OFLOW mismatch: Reference=%0d Monitor=%0d", ref_sb_txn.OFLOW, mon_sb_txn.OFLOW);
          end

          if (ref_sb_txn.G == mon_sb_txn.G) begin
            g_match++;
            $display("[PASS] G match: %0d", ref_sb_txn.G);
          end else begin
            g_mismatch++;
            $display("[FAIL] G mismatch: Reference=%0d Monitor=%0d", ref_sb_txn.G, mon_sb_txn.G);
          end

          if (ref_sb_txn.L == mon_sb_txn.L) begin
            l_match++;
            $display("[PASS] L match: %0d", ref_sb_txn.L);
          end else begin
            l_mismatch++;
            $display("[FAIL] L mismatch: Reference=%0d Monitor=%0d", ref_sb_txn.L, mon_sb_txn.L);
          end

          if (ref_sb_txn.E == mon_sb_txn.E) begin
            e_match++;
            $display("[PASS] E match: %0d", ref_sb_txn.E);
          end else begin
            e_mismatch++;
            $display("[FAIL] E mismatch: Reference=%0d Monitor=%0d", ref_sb_txn.E, mon_sb_txn.E);
          end

          // Overall transaction-level match check
          if ((ref_sb_txn.RES == mon_sb_txn.RES) &&
              (ref_sb_txn.ERR == mon_sb_txn.ERR) &&
              (ref_sb_txn.COUT == mon_sb_txn.COUT) &&
              (ref_sb_txn.OFLOW == mon_sb_txn.OFLOW) &&
              (ref_sb_txn.G == mon_sb_txn.G) &&
              (ref_sb_txn.L == mon_sb_txn.L) &&
              (ref_sb_txn.E == mon_sb_txn.E)) begin
            overall_match++;
            $display("\n[OVERALL PASS] Transaction #%0d matches perfectly!", i + 1);
          end else begin
            overall_mismatch++;
            $display("\n[OVERALL FAIL] Transaction #%0d has mismatches.", i + 1);
          end

          $display("---------------------------------------------------\n");
        end
      join
    end

    // Final summary output
    $display("=========== Scoreboard Summary ===========");
    $display("Total Transactions = %0d", `num_transactions);
    $display("RES Matches = %0d, Mismatches = %0d", res_match, res_mismatch);
    $display("ERR Matches = %0d, Mismatches = %0d", err_match, err_mismatch);
    $display("COUT Matches = %0d, Mismatches = %0d", cout_match, cout_mismatch);
    $display("OFLOW Matches = %0d, Mismatches = %0d", oflow_match, oflow_mismatch);
    $display("G Matches = %0d, Mismatches = %0d", g_match, g_mismatch);
    $display("L Matches = %0d, Mismatches = %0d", l_match, l_mismatch);
    $display("E Matches = %0d, Mismatches = %0d", e_match, e_mismatch);
    $display("Overall Matches = %0d", overall_match);
    $display("Overall Mismatches = %0d", overall_mismatch);
    $display("==========================================");
  endtask

endclass
