`include "alu_defines.sv"
class alu_environment;
//PROPERTIES
	//Virtual interfaces for driver, monitor and reference model
	virtual alu_if drv_vif;
	virtual alu_if mon_vif;
	virtual alu_if ref_vif;
	//Mailbox for generator to driver connection
  	mailbox #(alu_transaction) mbx_gd;
	//Mailbox for driver to reference model connection
	mailbox #(alu_transaction) mbx_dr;
	//Mailbox for reference model to scoreboard connection
	mailbox #(alu_transaction) mbx_rs;
	//Mailbox for monitor to scoreboard connection
	mailbox #(alu_transaction) mbx_ms;

	//Declaring handles for components 
	//generator, driver, monitor, reference model and scoreboard
 	alu_generator 		gen;
 	alu_driver 		drv;
 	alu_monitor 		mon;
 	alu_reference_model 	ref_sb;
 	alu_scoreboard 		scb;
  
//METHODS
	//Explicitly overriding the constructor to connect the virtual interfaces
	//from driver, monitor and reference model to test
	function new (virtual alu_if drv_vif,
		      virtual alu_if mon_vif,
		      virtual alu_if ref_vif);
	  this.drv_vif=drv_vif;
	  this.mon_vif=mon_vif;
	  this.ref_vif=ref_vif;
	endfunction

	//Task which creates objects for all the mailboxes and components
	task build();
	   begin
		//Creating objects for mailboxes
		mbx_gd=new();
		mbx_dr=new();
		mbx_rs=new();
		mbx_ms=new();

		//Creating objects for components and passing the arguments
		//in the function new() i.e the constructor
		gen=new(mbx_gd);
		drv=new(mbx_gd,mbx_dr,drv_vif);
		mon=new(mon_vif,mbx_ms);
		ref_sb=new(mbx_dr,mbx_rs,drv_vif);
		scb=new(mbx_rs,mbx_ms);
	  end
	endtask
   
	//Task which calls the start methods of each component 
	//and also calls the compare and report method
	task start();
		fork
			gen.start();
			drv.start();
			mon.start();
			ref_sb.start();
			scb.start();
		join
			//scb.compare_report();
	endtask
endclass
