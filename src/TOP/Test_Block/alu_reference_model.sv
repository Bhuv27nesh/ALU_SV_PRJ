`include "alu_defines.sv"

class alu_reference_model;
  // PROPERTIES
  // ALU transaction class handle
  alu_transaction alu_refmodel;
  
  // Mailbox for reference model to scoreboard connection
  mailbox #(alu_transaction) mbx_rs;
  //Mailbox for driver to reference model connection
  mailbox #(alu_transaction) mbx_dr;
  
  // Virtual interface with reference model modport and its instance
  virtual alu_if.DRV vif;
  
 // METHODS
 // Explicitly overriding the constructor to make mailbox connection from reference model to scoreboard and to connect the virtual interface from reference model to environment
 function new(mailbox #(alu_transaction) mbx_dr,
 	      mailbox #(alu_transaction) mbx_rs,
 	      virtual alu_if.DRV vif);
 this.mbx_dr= mbx_dr;
 this.mbx_rs= mbx_rs;
 this.vif=vif;
 endfunction
  
  // Task which mimics the functionality of the ALU
  task start();
    for(int i=0; i<`num_transactions; i++) 
	begin
      	 alu_refmodel = new();
	 //getting the driver transaction from mailbox
         mbx_dr.get(alu_refmodel);
      	 //Initializing all the output variables to zero
      	 repeat(1) @(vif.drv_cb)
       	    begin
       		alu_refmodel.RES = 0;
       		alu_refmodel.OFLOW = 0;
       		alu_refmodel.COUT = 0;
       		alu_refmodel.G = 0;
       		alu_refmodel.L = 0;
       		alu_refmodel.E = 0;
       		alu_refmodel.ERR = 0;
            end
    	 if(vif.drv_cb.reset == 1)
            begin
        	alu_refmodel.RES = 0;
        	alu_refmodel.OFLOW = 0;
       		alu_refmodel.COUT = 0;
        	alu_refmodel.G = 0;
        	alu_refmodel.L = 0;
        	alu_refmodel.E = 0;
        	alu_refmodel.ERR = 0;
      	   end
     	 else if (alu_refmodel.CE)
	   begin
	       if(alu_refmodel.MODE)                                    					// MODE == 1 | ARITHMETIC MODE
       		   begin
        	   if(alu_refmodel.INP_VALID == 2'b00)             						// INP_VALID == 0
        	      begin 
          		alu_refmodel.RES = alu_refmodel.RES;
			alu_refmodel.OFLOW = 0;
       			alu_refmodel.COUT = 0;
        		alu_refmodel.G = 0;
        		alu_refmodel.L = 0;
        		alu_refmodel.E = 0;
        		alu_refmodel.ERR = 1;
         	      end
        	   else if((alu_refmodel.INP_VALID == 2'b01) && (alu_refmodel.CMD == 4'b0100 || alu_refmodel.CMD == 4'b0101))       	// INP_VALID == 1
           	      begin
		      	case(alu_refmodel.CMD)
			            	4'b0100: begin								//INC_A
							alu_refmodel.RES = alu_refmodel.OPA + 1;
						 end
            				4'b0101: begin								//DEC_A
							alu_refmodel.RES = alu_refmodel.OPA - 1;
						 end
           	 		default: alu_refmodel.RES = 0;
          		endcase
		      end
         	   else if((alu_refmodel.INP_VALID == 2'b10) && (alu_refmodel.CMD == 4'b0110 || alu_refmodel.CMD == 4'b0111))       	// INP_VALID == 2 
		      begin
          		case(alu_refmodel.CMD)       			
            				4'b0110: begin								//INC_B
							alu_refmodel.RES = alu_refmodel.OPB + 1;
						 end
            				4'b0111: begin								//DEC_B
							alu_refmodel.RES = alu_refmodel.OPB - 1;
						 end
            			default: alu_refmodel.RES = 0;
            		endcase 
        	      end
        	   else                                                 					//INP_VALID == 3  
		     begin
			   int wait_cycles = 0;
    			   while (alu_refmodel.INP_VALID != 2'b11 && wait_cycles < 16) 
			     begin
				mbx_dr.get(alu_refmodel);
      				@(vif.drv_cb);
      				wait_cycles = wait_cycles + 1;
	     		     end		
			    if (alu_refmodel.INP_VALID != 2'b11) 
		  	      begin
      				alu_refmodel.ERR = 1; 
    		 	      end 
			    else 
			      begin
          			alu_refmodel.ERR = 0;
          			case(alu_refmodel.CMD)
            				4'b0000: begin								//ADD
							alu_refmodel.RES = alu_refmodel.OPA + alu_refmodel.OPB;
							alu_refmodel.COUT = alu_refmodel.RES[`DATA_WIDTH] ? 1 : 0;
						 end
            				4'b0001: begin								//SUB
							alu_refmodel.RES = alu_refmodel.OPA - alu_refmodel.OPB;
							alu_refmodel.OFLOW = (alu_refmodel.OPA < alu_refmodel.OPB) ? 1 : 0;
						 end
            				4'b0010: begin								//ADD_CIN
              						alu_refmodel.RES = alu_refmodel.OPA + alu_refmodel.OPB + alu_refmodel.CIN;
              					 	alu_refmodel.COUT = alu_refmodel.RES[`DATA_WIDTH] ? 1 : 0 ;
            					 end
            				4'b0011: begin								//SUB_CIN
							alu_refmodel.RES = alu_refmodel.OPA - alu_refmodel.OPB - alu_refmodel.CIN;
							alu_refmodel.OFLOW = ($signed(alu_refmodel.RES) < 0) ? 1 : 0;
						 end
			            	4'b0100: begin								//INC_A
							alu_refmodel.RES = alu_refmodel.OPA + 1;
						 end
            				4'b0101: begin								//DEC_A
							alu_refmodel.RES = alu_refmodel.OPA - 1;
						 end
            				4'b0110: begin								//INC_B
							alu_refmodel.RES = alu_refmodel.OPB + 1;
						 end
            				4'b0111: begin								//DEC_B
							alu_refmodel.RES = alu_refmodel.OPB - 1;
						 end
            				4'b1000: begin								//CMP
              						if(alu_refmodel.OPA > alu_refmodel.OPB) 
								begin
                							alu_refmodel.G = 1; alu_refmodel.L = 0; alu_refmodel.E = 0;
              							end
              						else if(alu_refmodel.OPA < alu_refmodel.OPB) 
								begin
                							alu_refmodel.G = 0; alu_refmodel.L = 1; alu_refmodel.E = 0;
              							end
              						else 
								begin
                							alu_refmodel.G = 0; alu_refmodel.L = 0; alu_refmodel.E = 1;
              							end
            					 end
            				4'b1001: begin								//INC_A * INC_B
							repeat(2) @(vif.drv_cb);
              						alu_refmodel.RES = (alu_refmodel.OPA + 1) * (alu_refmodel.OPB + 1);
            					 end
            				4'b1010: begin								//SHL1_A * OPB
							repeat(2) @(vif.drv_cb);
              						alu_refmodel.RES = (alu_refmodel.OPA << 1) * alu_refmodel.OPB;
            					end
            				default: alu_refmodel.RES = alu_refmodel.RES;
          			endcase
			      end
			end
	       end
      	       else 												// MODE == 0 | LOGICAL MODE
		  begin
        		if(alu_refmodel.INP_VALID == 2'b00) 
			  begin
				 alu_refmodel.RES = alu_refmodel.RES;
       			  end
        		else if((alu_refmodel.INP_VALID == 2'b01) && (alu_refmodel.CMD == 4'b0110 || alu_refmodel.CMD == 4'b1000 || alu_refmodel.CMD == 4'b1001)) 
			   begin
          			case(alu_refmodel.CMD)
           				4'b0110: begin
             						alu_refmodel.RES = ~alu_refmodel.OPA;			//NOT_A
						 end
           				4'b1000: begin
             						alu_refmodel.RES = alu_refmodel.OPA >> 1;		//SHR1_A
						 end
           				4'b1001: begin 
             						alu_refmodel.RES = alu_refmodel.OPA << 1;		//SHL1_A
						 end
            				default: alu_refmodel.RES = 0;
            			endcase 
        		   end
        		 else if((alu_refmodel.INP_VALID == 2'b10) && (alu_refmodel.CMD == 4'b0111 || alu_refmodel.CMD == 4'b1010 || alu_refmodel.CMD == 4'b1011))
			    begin
          			case(alu_refmodel.CMD)
           				4'b0111: begin
             						alu_refmodel.RES = ~alu_refmodel.OPB;			//NOT_B
						 end
            				4'b1010: begin
              						alu_refmodel.RES = alu_refmodel.OPB >> 1;		//SHR1_B
						 end
            				4'b1011: begin
              						alu_refmodel.RES = alu_refmodel.OPB << 1;		//SHL1_B
						 end
            				default: alu_refmodel.RES = 0;
            			endcase 
        		    end	  
			  else 
			     begin
			   	int wait_cycles = 0;
    			   	while (alu_refmodel.INP_VALID != 2'b11 && wait_cycles < 16) 
			     	   begin
      					@(vif.drv_cb);
      					wait_cycles = wait_cycles + 1;
	     		     	   end		
			      if (alu_refmodel.INP_VALID != 2'b11) 
		  	      	begin
      			       	   alu_refmodel.ERR = 1; 
    		 	      	end 
			      else 
			       begin
          			alu_refmodel.ERR = 0;
            				case(alu_refmodel.CMD) 
              					4'b0000: alu_refmodel.RES =  alu_refmodel.OPA & alu_refmodel.OPB;	//AND
              					4'b0001: alu_refmodel.RES = ~(alu_refmodel.OPA & alu_refmodel.OPB);	//NAND
              					4'b0010: alu_refmodel.RES = alu_refmodel.OPA | alu_refmodel.OPB;	//OR
              					4'b0011: alu_refmodel.RES = ~(alu_refmodel.OPA | alu_refmodel.OPB);	//NOR
              					4'b0100: alu_refmodel.RES = alu_refmodel.OPA ^ alu_refmodel.OPB;	//XOR
              					4'b0101: alu_refmodel.RES = ~(alu_refmodel.OPA ^ alu_refmodel.OPB);	//XNOR
              					4'b0110: alu_refmodel.RES = ~alu_refmodel.OPA;				//NOT_A
              					4'b0111: alu_refmodel.RES = ~alu_refmodel.OPB;				//NOT_B
              					4'b1000: alu_refmodel.RES = alu_refmodel.OPA >> 1;			//SHR1_A
              					4'b1001: alu_refmodel.RES = alu_refmodel.OPA << 1;			//SHL1_A
              					4'b1010: alu_refmodel.RES = alu_refmodel.OPB >> 1;			//SHR1_B
              					4'b1011: alu_refmodel.RES = alu_refmodel.OPB << 1;			//SHL1_B
              					4'b1100: begin								//ROL_A_B
								int shift = alu_refmodel.OPB % `DATA_WIDTH;
    								alu_refmodel.RES = (alu_refmodel.OPA << shift) | (alu_refmodel.OPA >> (`DATA_WIDTH - shift));
    								alu_refmodel.ERR = |(alu_refmodel.OPB >> $clog2(`DATA_WIDTH)) ? 1 : 0;
							 end
              					4'b1101: begin								//ROR_A_B
								int shift = alu_refmodel.OPB % `DATA_WIDTH;
    								alu_refmodel.RES = (alu_refmodel.OPA >> shift) | (alu_refmodel.OPA << (`DATA_WIDTH - shift));
    								alu_refmodel.ERR = |(alu_refmodel.OPB >> $clog2(`DATA_WIDTH)) ? 1 : 0;
							 end
				              	default: alu_refmodel.RES = alu_refmodel.RES;
					endcase
			       end
			     end
		  end
	   end
	 else
	   begin
		alu_refmodel.RES   = alu_refmodel.RES;
		alu_refmodel.OFLOW = alu_refmodel.OFLOW;
       		alu_refmodel.COUT  = alu_refmodel.COUT;
        	alu_refmodel.G     = alu_refmodel.G;
        	alu_refmodel.L     = alu_refmodel.L;
        	alu_refmodel.E     = alu_refmodel.E;
        	alu_refmodel.ERR   = alu_refmodel.ERR;


	   end
 	
	// Putting the reference model transaction to mailbox
      	mbx_rs.put(alu_refmodel);
      		$display("\n %0t |  REFERENCE MODEL PASSING THE DATA TO SCOREBOARD \nERR=%0d | RES=%0d | OFLOW=%0d | COUT=%0d | G=%0d | L=%0d | E=%0d ", $time, alu_refmodel.ERR,alu_refmodel.RES,alu_refmodel.OFLOW,alu_refmodel.COUT,alu_refmodel.G,alu_refmodel.L,alu_refmodel.E);
    end
  endtask
endclass	
