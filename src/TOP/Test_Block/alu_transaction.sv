`include "alu_defines.sv"

class alu_transaction;
  // Common INPUTS
  rand logic [`DATA_WIDTH-1 : 0] OPA;
  rand logic [`DATA_WIDTH-1 : 0] OPB;
  rand logic CIN;
  rand logic MODE;
  rand logic [1:0] INP_VALID;
  rand logic [`CMD_WIDTH-1 : 0] CMD;

  // OUTPUTS
  logic [`DATA_WIDTH : 0] RES;
  logic OFLOW;
  logic COUT;
  logic G;
  logic L;
  logic E;
  logic ERR;


  // Deep copy
  function alu_transaction copy ();
    copy = new();
    copy.OPA = this.OPA;
    copy.OPB = this.OPB;
    copy.CIN = this.CIN;
    copy.MODE = this.MODE;
    copy.INP_VALID = this.INP_VALID;
    copy.CMD = this.CMD;
  endfunction
endclass

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  class arithmetic_single_operand_operation extends alu_transaction;
    constraint single_operand  {CMD inside {4,5,6,7};}
    constraint arithmetic_mode {MODE == 1;}
    constraint inp_valid      {INP_VALID == 2'b11;}

    virtual function alu_transaction copy();
      arithmetic_single_operand_operation copy0;
      copy0 = new();
      copy0.OPA = this.OPA;
      copy0.OPB = this.OPB;
      copy0.CIN = this.CIN;
      copy0.MODE = this.MODE;
      copy0.INP_VALID = this.INP_VALID;
      copy0.CMD = this.CMD;
      return copy0;
    endfunction
  endclass
//--------------------------------------------------------------------------------------------------------------
  class arithmetic_two_operand_operation extends alu_transaction;
    constraint two_op_arith { CMD inside {[0:3], [8:10]};}
    constraint arith_mode {MODE == 1;}
    constraint validity {INP_VALID == 2'b11;}
    constraint dist_val {OPA dist {0 := 2, 255 := 2};}
    constraint dist_val_opb {OPB dist {0 := 2, 255 := 2};}

    function alu_transaction copy();
      arithmetic_two_operand_operation copy1;
      copy1 = new();
      copy1.OPA = this.OPA;
      copy1.OPB = this.OPB;
      copy1.CIN = this.CIN;
      copy1.MODE = this.MODE;
      copy1.INP_VALID = this.INP_VALID;
      copy1.CMD = this.CMD;
      return copy1;
    endfunction
  endclass
//--------------------------------------------------------------------------------------------------------------
  class logical_single_operand_operation extends alu_transaction;
    constraint single_op_logic {CMD inside {[6:11]};}
    constraint logic_mode {MODE == 0;}
    constraint inp_validity {INP_VALID inside {3};}
    
    function alu_transaction copy();
      logical_single_operand_operation copy2;
      copy2 = new();
      copy2.OPA = this.OPA;
      copy2.OPB = this.OPB;
      copy2.CIN = this.CIN;
      copy2.MODE = this.MODE;
      copy2.INP_VALID = this.INP_VALID;
      copy2.CMD = this.CMD;
      return copy2;
    endfunction
  endclass
//--------------------------------------------------------------------------------------------------------------
  class logical_two_operand_operation extends alu_transaction;
    constraint two_op_logic {CMD inside {[0:5],12,13};}
    constraint logic_mode {MODE == 0;}
    constraint inpValidity {INP_VALID inside {3};}

    function alu_transaction copy();
      logical_two_operand_operation copy3;
      copy3 = new();
      copy3.OPA = this.OPA;
      copy3.OPB = this.OPB;
      copy3.CIN = this.CIN;
      copy3.MODE = this.MODE;
      copy3.INP_VALID = this.INP_VALID;
      copy3.CMD = this.CMD;
      return copy3;
    endfunction
  endclass
//--------------------------------------------------------------------------------------------------------------
