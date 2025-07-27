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
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        this.drv_vif = drv_vif;
        this.mon_vif = mon_vif;
        this.ref_vif = ref_vif;
    endfunction

    // Task which builds the object for environment handle and
    // calls the build and start methods of the environment
    task run();
        env = new(drv_vif, mon_vif, ref_vif);
        env.build;
        env.start;
    endtask
endclass


//--------------------------------------------------------------------------------------------------
class test1 extends alu_test;

    alu_add_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test2 extends alu_test;

    alu_sub_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test3 extends alu_test;

    alu_add_cin_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test4 extends alu_test;

    alu_sub_cin_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test5 extends alu_test;

    alu_inc_a_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test6 extends alu_test;

    alu_dec_a_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test7 extends alu_test;

    alu_inc_b_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test8 extends alu_test;

    alu_dec_b_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test9 extends alu_test;

    alu_cmp_gt_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test10 extends alu_test;

    alu_cmp_eq_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test11 extends alu_test;

    alu_cmp_ls_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test12 extends alu_test;

    alu_op_inc_mul_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test13 extends alu_test;

    alu_leftshift_mul_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test14 extends alu_test;

    alu_logical_two_operand_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test15 extends alu_test;

    alu_logical_a_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test16 extends alu_test;

    alu_logical_b_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test17 extends alu_test;

    alu_logical_error_check_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass

class test18 extends alu_test;

    alu_arithmetic_error_check_txn trans;  
    function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
    endfunction

    task run();
    	env=new(drv_vif,mon_vif,ref_vif);
    	env.build;
    	trans = new();
    	env.gen.blueprint= trans;
    	env.start;
    endtask

endclass
//--------------------------------------------------------------------------------------------------

class test_regression extends alu_test;
	alu_transaction  			trans0;
	alu_add_txn				trans1;
	alu_sub_txn				trans2;
	alu_add_cin_txn				trans3;
	alu_sub_cin_txn				trans4;
	alu_inc_a_txn				trans5;
	alu_dec_a_txn				trans6;
	alu_inc_b_txn				trans7;
	alu_dec_b_txn				trans8;	
	alu_cmp_gt_txn				trans9;
	alu_cmp_eq_txn				trans10;
	alu_cmp_ls_txn				trans11;
	alu_op_inc_mul_txn			trans12;
	alu_leftshift_mul_txn			trans13;
	alu_logical_two_operand_txn		trans14;
	alu_logical_a_txn			trans15;
	alu_logical_b_txn			trans16;
	alu_logical_error_check_txn		trans17;
	alu_arithmetic_error_check_txn		trans18;

	function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
	    	super.new(drv_vif,mon_vif,ref_vif);
  	endfunction

  	task run();
    		$display("child test");
    		env=new(drv_vif,mon_vif,ref_vif);
    		env.build;
///////////////////////////////////////////////////////
    begin 
    trans0 = new();
    env.gen.blueprint= trans0;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans1 = new();
    env.gen.blueprint= trans1;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans2 = new();
    env.gen.blueprint= trans2;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans3 = new();
    env.gen.blueprint= trans3;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans4 = new();
    env.gen.blueprint= trans4;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans5 = new();
    env.gen.blueprint= trans5;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans6 = new();
    env.gen.blueprint= trans6;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans7 = new();
    env.gen.blueprint= trans7;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans8 = new();
    env.gen.blueprint= trans8;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans9 = new();
    env.gen.blueprint= trans9;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans10 = new();
    env.gen.blueprint= trans10;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans11 = new();
    env.gen.blueprint= trans11;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans12 = new();
    env.gen.blueprint= trans12;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans13 = new();
    env.gen.blueprint= trans13;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans14 = new();
    env.gen.blueprint= trans14;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans15 = new();
    env.gen.blueprint= trans15;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans16 = new();
    env.gen.blueprint= trans16;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans17 = new();
    env.gen.blueprint= trans17;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans18 = new();
    env.gen.blueprint= trans18;
    end
    env.start;
//////////////////////////////////////////////////////

  endtask
endclass





