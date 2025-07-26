`include "alu_defines.sv"

class alu_transaction;
  // Common INPUTS
  rand logic [`DATA_WIDTH-1:0] OPA;
  rand logic [`DATA_WIDTH-1:0] OPB;
  rand bit CIN;
  rand bit CE;
  rand bit MODE;
  rand bit [1:0] INP_VALID;
  rand bit [`CMD_WIDTH-1:0] CMD;

  // OUTPUTS
  logic ERR;
  logic [2*`DATA_WIDTH - 1 : 0] RES;
  logic OFLOW;
  logic COUT;
  logic G;
  logic L;
  logic E;

  // Common constraints
  constraint ce_c  { CE == 1; }
  constraint input_value { INP_VALID == 2'b11; }
  constraint cmd_value {
    			if (MODE == 1)
      				CMD inside {[0:10]};  // Arithmetic
    			else
      				CMD inside {[0:13]};  // Logical
  }
  constraint range {
        		        OPA inside {[0:(2**`DATA_WIDTH) - 1]};
        		        OPB inside {[0:(2**`DATA_WIDTH) - 1]};
  }

  // Deep copy
  virtual function alu_transaction copy();
    alu_transaction copy_inst = new();
    copy_inst.OPA = this.OPA;
    copy_inst.OPB = this.OPB;
    copy_inst.CIN = this.CIN;
    copy_inst.CE = this.CE;
    copy_inst.MODE = this.MODE;
    copy_inst.INP_VALID = this.INP_VALID;
    copy_inst.CMD = this.CMD;
    return copy_inst;
  endfunction
endclass

//---------------------------------------------------------------------------------------------
// Arithmetic transaction
//---------------------------------------------------------------------------------------------
class alu_add_txn extends alu_transaction;
  constraint add_mode  { MODE == 1; }
  constraint add_valid { INP_VALID == 2'b11; }
  constraint add_cmd   { CMD == 0; }

  virtual function alu_transaction copy();
    alu_add_txn c = new();
    c.OPA = this.OPA;
    c.OPB = this.OPB;
    c.CIN = this.CIN;
    c.CE = this.CE;
    c.MODE = this.MODE;
    c.INP_VALID = this.INP_VALID;
    c.CMD = this.CMD;
    return c;
  endfunction
endclass

class alu_sub_txn extends alu_transaction;
  constraint sub_mode  { MODE == 1; }
  constraint sub_valid { INP_VALID == 2'b11; }
  constraint sub_cmd   { CMD == 1; }

  virtual function alu_transaction copy();
    alu_sub_txn c1 = new();
    c1.OPA = this.OPA;
    c1.OPB = this.OPB;
    c1.CIN = this.CIN;
    c1.CE = this.CE;
    c1.MODE = this.MODE;
    c1.INP_VALID = this.INP_VALID;
    c1.CMD = this.CMD;
    return c1;
  endfunction
endclass

class alu_add_cin_txn extends alu_transaction;
  constraint add_cin_mode  { MODE == 1; }
  constraint add_cin_valid { INP_VALID == 2'b11; }
  constraint add_cin_cmd   { CMD == 2; }

  virtual function alu_transaction copy();
    alu_add_cin_txn c2 = new();
    c2.OPA = this.OPA;
    c2.OPB = this.OPB;
    c2.CIN = this.CIN;
    c2.CE = this.CE;
    c2.MODE = this.MODE;
    c2.INP_VALID = this.INP_VALID;
    c2.CMD = this.CMD;
    return c2;
  endfunction
endclass

class alu_sub_cin_txn extends alu_transaction;
  constraint sub_mode  { MODE == 1; }
  constraint sub_valid { INP_VALID == 2'b11; }
  constraint sub_cmd   { CMD == 3; }

  virtual function alu_transaction copy();
    alu_sub_cin_txn c3 = new();
    c3.OPA = this.OPA;
    c3.OPB = this.OPB;
    c3.CIN = this.CIN;
    c3.CE = this.CE;
    c3.MODE = this.MODE;
    c3.INP_VALID = this.INP_VALID;
    c3.CMD = this.CMD;
    return c3;
  endfunction
endclass

class alu_inc_a_txn extends alu_transaction;
  constraint inc_a_mode  { MODE == 1; }
  constraint inc_a_valid { INP_VALID inside {2'b01, 2'b11}; }
  constraint inc_a_cmd   { CMD == 4; }

  virtual function alu_transaction copy();
    alu_inc_a_txn c4 = new();
    c4.OPA = this.OPA;
    c4.OPB = this.OPB;
    c4.CIN = this.CIN;
    c4.CE = this.CE;
    c4.MODE = this.MODE;
    c4.INP_VALID = this.INP_VALID;
    c4.CMD = this.CMD;
    return c4;
  endfunction
endclass

class alu_dec_a_txn extends alu_transaction;
  constraint dec_a_mode  { MODE == 1; }
  constraint dec_a_valid { INP_VALID inside {2'b01, 2'b11}; }
  constraint dec_a_cmd   { CMD == 5; }

  virtual function alu_transaction copy();
    alu_dec_a_txn c5 = new();
    c5.OPA = this.OPA;
    c5.OPB = this.OPB;
    c5.CIN = this.CIN;
    c5.CE = this.CE;
    c5.MODE = this.MODE;
    c5.INP_VALID = this.INP_VALID;
    c5.CMD = this.CMD;
    return c5;
  endfunction
endclass

class alu_inc_b_txn extends alu_transaction;
  constraint inc_b_mode  { MODE == 1; }
  constraint inc_b_valid { INP_VALID inside {2'b10, 2'b11}; }
  constraint inc_b_cmd   { CMD == 6; }

  virtual function alu_transaction copy();
    alu_inc_b_txn c6 = new();
    c6.OPA = this.OPA;
    c6.OPB = this.OPB;
    c6.CIN = this.CIN;
    c6.CE = this.CE;
    c6.MODE = this.MODE;
    c6.INP_VALID = this.INP_VALID;
    c6.CMD = this.CMD;
    return c6;
  endfunction
endclass

class alu_dec_b_txn extends alu_transaction;
  constraint dec_b_mode  { MODE == 1; }
  constraint dec_b_valid { INP_VALID inside {2'b10, 2'b11}; }
  constraint dec_b_cmd   { CMD == 7; }

  virtual function alu_transaction copy();
    alu_dec_b_txn c7 = new();
    c7.OPA = this.OPA;
    c7.OPB = this.OPB;
    c7.CIN = this.CIN;
    c7.CE = this.CE;
    c7.MODE = this.MODE;
    c7.INP_VALID = this.INP_VALID;
    c7.CMD = this.CMD;
    return c7;
  endfunction
endclass


class alu_cmp_gt_txn extends alu_transaction;
  constraint cmp_mode  { MODE == 1; }
  constraint cmp_valid { INP_VALID == 2'b11; }
  constraint cmp_cmd   { CMD == 8; }
  constraint opa_gt_opb{ OPA > OPB; }

  virtual function alu_transaction copy();
    alu_cmp_gt_txn c8 = new();
    c8.OPA = this.OPA;
    c8.OPB = this.OPB;
    c8.CIN = this.CIN;
    c8.CE = this.CE;
    c8.MODE = this.MODE;
    c8.INP_VALID = this.INP_VALID;
    c8.CMD = this.CMD;
    return c8;
  endfunction
endclass

class alu_cmp_eq_txn extends alu_transaction;
  constraint cmp_mode  { MODE == 1; }
  constraint cmp_valid { INP_VALID == 2'b11; }
  constraint cmp_cmd   { CMD == 8; }
  constraint opa_eq_opb{ OPA == OPB; }

  virtual function alu_transaction copy();
    alu_cmp_eq_txn c8_1 = new();
    c8_1.OPA = this.OPA;
    c8_1.OPB = this.OPB;
    c8_1.CIN = this.CIN;
    c8_1.CE = this.CE;
    c8_1.MODE = this.MODE;
    c8_1.INP_VALID = this.INP_VALID;
    c8_1.CMD = this.CMD;
    return c8_1;
  endfunction
endclass

class alu_cmp_ls_txn extends alu_transaction;
  constraint cmp_mode  { MODE == 1; }
  constraint cmp_valid { INP_VALID == 2'b11; }
  constraint cmp_cmd   { CMD == 8; }
  constraint opa_ls_opb{ OPA < OPB; }

  virtual function alu_transaction copy();
    alu_cmp_ls_txn c8_2 = new();
    c8_2.OPA = this.OPA;
    c8_2.OPB = this.OPB;
    c8_2.CIN = this.CIN;
    c8_2.CE = this.CE;
    c8_2.MODE = this.MODE;
    c8_2.INP_VALID = this.INP_VALID;
    c8_2.CMD = this.CMD;
    return c8_2;
  endfunction
endclass

class alu_op_inc_mul_txn extends alu_transaction;
  constraint mul_mode  { MODE == 1; }
  constraint mul_valid { INP_VALID == 2'b11; }
  constraint mul_cmd   { CMD == 9; }
  constraint op_range  { OPA < (2*`DATA_WIDTH -1); OPB < (2*`DATA_WIDTH -1); }

  virtual function alu_transaction copy();
    alu_op_inc_mul_txn c9 = new();
    c9.OPA = this.OPA;
    c9.OPB = this.OPB;
    c9.CIN = this.CIN;
    c9.CE = this.CE;
    c9.MODE = this.MODE;
    c9.INP_VALID = this.INP_VALID;
    c9.CMD = this.CMD;
    return c9;
  endfunction
endclass

class alu_leftshift_mul_txn extends alu_transaction;
  constraint mul_mode  { MODE == 1; }
  constraint mul_valid { INP_VALID == 2'b11; }
  constraint mul_cmd   { CMD == 10; }
  constraint op_range  { OPA < (2*`DATA_WIDTH -1); OPB < (2*`DATA_WIDTH -1); }

  virtual function alu_transaction copy();
    alu_leftshift_mul_txn c10 = new();
    c10.OPA = this.OPA;
    c10.OPB = this.OPB;
    c10.CIN = this.CIN;
    c10.CE = this.CE;
    c10.MODE = this.MODE;
    c10.INP_VALID = this.INP_VALID;
    c10.CMD = this.CMD;
    return c10;
  endfunction
endclass

///////////////////////////////////////////////////////////////////////////////////////////////////


//---------------------------------------------------------------------------------------------
// Logical transaction
//---------------------------------------------------------------------------------------------

class alu_logical_two_operand_txn extends alu_transaction;
  constraint two_operand_mode  { MODE == 0; }
  constraint two_operand_valid { INP_VALID == 2'b11; }
  constraint two_operand_cmd   { CMD inside {0,1,2,3,4,5,12,13}; }

  virtual function alu_transaction copy();
    alu_logical_two_operand_txn l = new();
    l.OPA = this.OPA;
    l.OPB = this.OPB;
    l.CIN = this.CIN;
    l.CE = this.CE;
    l.MODE = this.MODE;
    l.INP_VALID = this.INP_VALID;
    l.CMD = this.CMD;
    return l;
  endfunction
endclass

class alu_logical_a_txn extends alu_transaction;
  constraint logical_a_mode  { MODE == 0; }
  constraint logical_a_valid { INP_VALID inside {2'b01, 2'b11}; }
  constraint logical_a_cmd   { CMD inside {6,8,9}; }

  virtual function alu_transaction copy();
    alu_logical_a_txn l1 = new();
    l1.OPA = this.OPA;
    l1.OPB = this.OPB;
    l1.CIN = this.CIN;
    l1.CE = this.CE;
    l1.MODE = this.MODE;
    l1.INP_VALID = this.INP_VALID;
    l1.CMD = this.CMD;
    return l1;
  endfunction
endclass

class alu_logical_b_txn extends alu_transaction;
  constraint logical_b_mode  { MODE == 0; }
  constraint logical_b_valid { INP_VALID inside {2'b10, 2'b11}; }
  constraint logical_b_cmd   { CMD inside {7,10,11}; }

  virtual function alu_transaction copy();
    alu_logical_b_txn l2 = new();
    l2.OPA = this.OPA;
    l2.OPB = this.OPB;
    l2.CIN = this.CIN;
    l2.CE = this.CE;
    l2.MODE = this.MODE;
    l2.INP_VALID = this.INP_VALID;
    l2.CMD = this.CMD;
    return l2;
  endfunction
endclass

////////////////////////////////////////////////////////////////////////////////////////////


//---------------------------------------------------------------------------------------------
// Error cases transaction
//---------------------------------------------------------------------------------------------

class alu_logical_error_check_txn extends alu_transaction;
  constraint error_check_mode  { MODE == 0; }
  constraint error_check_valid { INP_VALID  inside {2'b10, 2'b01}; }
  constraint error_check_cmd   { CMD inside {0,1,2,3,4,5,12,13}; }

  virtual function alu_transaction copy();
    alu_logical_error_check_txn e = new();
    e.OPA = this.OPA;
    e.OPB = this.OPB;
    e.CIN = this.CIN;
    e.CE = this.CE;
    e.MODE = this.MODE;
    e.INP_VALID = this.INP_VALID;
    e.CMD = this.CMD;
    return e;
  endfunction
endclass

class alu_arithmetic_error_check_txn extends alu_transaction;
  constraint err_check_mode  { MODE == 1; }
  constraint err_check_valid { INP_VALID  inside {2'b10, 2'b01}; }
  constraint err_check_cmd   { CMD inside {0,1,2,3,8,9,10}; }

  virtual function alu_transaction copy();
    alu_arithmetic_error_check_txn e1 = new();
    e1.OPA = this.OPA;
    e1.OPB = this.OPB;
    e1.CIN = this.CIN;
    e1.CE = this.CE;
    e1.MODE = this.MODE;
    e1.INP_VALID = this.INP_VALID;
    e1.CMD = this.CMD;
    return e1;
  endfunction
endclass
