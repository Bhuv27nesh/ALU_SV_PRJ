`include "alu_defines.sv"

class alu_test;
  // PROPERTIES
  // Virtual interfaces for driver, monitor, and reference model
  virtual alu_if drv_vif;
  virtual alu_if mon_vif;
  virtual alu_if ref_vif;

   // Declaring handle for environment
  alu_environment env;

  // METHODS
  // Explicitly overriding the constructor to connect the virtual
  // interfaces from driver, monitor, and reference model to test
  function new(virtual alu_if drv_vif, virtual alu_if mon_vif,virtual alu_if ref_vif);
    this.drv_vif = drv_vif;
    this.mon_vif = mon_vif;
    this.ref_vif = ref_vif;
  endfunction

  // Task which builds the object for environment handle and
  // calls the build and start methods of the environment
  task run();
    env = new(drv_vif, mon_vif, ref_vif);
    env.build();
    env.start();
  endtask

endclass

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

class test_single_op_arith extends alu_test;

  arithmetic_single_operand_operation trans1;

  function new(virtual alu_if drv_vif,virtual alu_if mon_vif, virtual alu_if ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    env = new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
      trans1 = new();
      env.gen.blueprint = trans1;
    end
    env.start();
  endtask
endclass

//--------------------------------------------------------------------------------------------------------------

class test_two_op_arith extends alu_test;
  arithmetic_two_operand_operation trans2;

  function new(virtual alu_if drv_vif,virtual alu_if mon_vif, virtual alu_if ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
     env = new(drv_vif,mon_vif,ref_vif);
     env.build;
     begin
      trans2 = new();
      env.gen.blueprint = trans2;
     end
     env.start();
  endtask
endclass

//--------------------------------------------------------------------------------------------------------------

class test_single_op_logic extends alu_test;
  logical_single_operand_operation trans3;

  function new(virtual alu_if drv_vif,virtual alu_if mon_vif, virtual alu_if ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
     env = new(drv_vif,mon_vif,ref_vif);
     env.build;
     begin
      trans3 = new();
      env.gen.blueprint = trans3;
     end
     env.start();
  endtask
endclass

//--------------------------------------------------------------------------------------------------------------

class test_two_op_logic extends alu_test;
  logical_two_operand_operation trans4;

  function new(virtual alu_if drv_vif,virtual alu_if mon_vif, virtual alu_if ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
     env = new(drv_vif,mon_vif,ref_vif);
     env.build;
     begin
      trans4 = new();
      env.gen.blueprint = trans4;
     end
     env.start();
  endtask
endclass

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

class test_regression extends alu_test;
  alu_transaction 				trans0;
  arithmetic_single_operand_operation 		trans1;
  arithmetic_two_operand_operation 		trans2;
  logical_single_operand_operation 		trans3;
  logical_two_operand_operation 		trans4;

  function new(virtual alu_if drv_vif,virtual alu_if mon_vif, virtual alu_if ref_vif);
     super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    env = new(drv_vif,mon_vif,ref_vif);
    env.build;

    trans0 = new();
    env.gen.blueprint = trans0;
    env.start;

    trans1 = new();
    env.gen.blueprint = trans1;
    env.start;

    trans2 = new();
    env.gen.blueprint = trans2;
    env.start;

    trans3 = new();
    env.gen.blueprint = trans3;
    env.start;

    trans4 = new();
    env.gen.blueprint = trans4;
    env.start;

  endtask

endclass

