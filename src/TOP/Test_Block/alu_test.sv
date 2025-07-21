`include "alu_defines.sv"

class alu_test;
    // PROPERTIES
    // Virtual interfaces for driver, monitor, and reference model
    virtual alu_inf drv_vif;
    virtual alu_inf mon_vif;
    virtual alu_inf ref_vif;

    // Declaring handle for environment
    alu_environment env;

    // METHODS
    // Explicitly overriding the constructor to connect the virtual
    // interfaces from driver, monitor, and reference model to test
    function new(virtual alu_inf drv_vif, virtual alu_inf mon_vif, virtual alu_inf ref_vif);
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
      $display("\n INPUT FUNCTIONAL COVERAGE = %0d", env.drv.drv_cg.get_coverage());
      $display("\n OUTPUT FUNCTIONAL COVERAGE = %0d\n", env.mon.mon_cov.get_coverage());
      $display("------------------------------------------------------------------");
    endtask
endclass
