`include "alu_defines.sv"
class alu_generator;
//PROPERTIES
//ALU transaction class handle 
 alu_transaction blueprint;
  
//Mailbox for generator to driver connection
  mailbox #(alu_transaction)mbx_gd;
  
//METHODS
//Explicitly overriding the constructor to make mailbox
//connection from generator to driver
 function new(mailbox #(alu_transaction)mbx_gd);
    this.mbx_gd = mbx_gd;
    blueprint = new();
 endfunction
  
//Task to generate the random stimuli
 task start();
  for(int i=0;i<`num_transactions;i++)
   begin
   //Randomizing the inputs
   void'(blueprint.randomize() == 1); 
   
   //Putting the randomized inputs to mailbox 
   mbx_gd.put(blueprint.copy()); 
     #1;
     $display("%0t GENERATOR Randomized transaction: OPA = %0d | OPB = %0d | CIN = %0d | CE = %0d | MODE = %0d | INP_VALID = %0d | CMD = %0d",$time,blueprint.OPA,blueprint.OPB, blueprint.CIN, blueprint.CE,blueprint.MODE,blueprint.INP_VALID,blueprint.CMD);
   end
 endtask
  
endclass
