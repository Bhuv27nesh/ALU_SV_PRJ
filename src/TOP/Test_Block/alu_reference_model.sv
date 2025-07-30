`include "alu_defines.sv"

class alu_reference_model;

  // PROPERTIES
  // ALU transaction class handle
  alu_transaction ref_trans;

  // Mailbox for reference model to scoreboard connection
  mailbox #(alu_transaction) mbx_rs;
  //Mailbox for driver to reference model connection
  mailbox #(alu_transaction) mbx_dr;

  // Virtual interface with reference model modport and its instance
  virtual alu_if.REF_MOD ref_vif;

 // METHODS
 // Explicitly overriding the constructor to make mailbox connection from reference model to scoreboard and to connect the virtual interface from reference model to environment
  function new(mailbox #(alu_transaction) mbx_dr, 
	       mailbox #(alu_transaction) mbx_rs, 
	       virtual alu_if.REF_MOD ref_vif);
    this.mbx_dr = mbx_dr;
    this.mbx_rs = mbx_rs;
    this.ref_vif = ref_vif;
  endfunction

  // Task which mimics the functionality of the ALU
  task start();

    int single_op_logical[]    = {6,7,8,9,10,11};
    int single_op_arithmetic[] = {4,5,6,7}; 
    int count =  0;
    int err_count = 1;
    
    repeat(3)@(ref_vif.ref_cb);
    
    for(int i = 0; i < `num_transaction; i++) begin 
      ref_trans = new();
      mbx_dr.get(ref_trans); 
     
      if(ref_trans.INP_VALID == 2'b11 || ref_trans.INP_VALID == 2'b00) begin 
        if((ref_trans.CMD == 9 || ref_trans.CMD == 10) && ref_trans.MODE == 1) begin 
          repeat(1)@(ref_vif.ref_cb);
          alu_operation();
          $display("");
          $display(" Ref [%0t] | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,ref_trans.MODE,ref_trans.INP_VALID,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.CIN);
          $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
          $display("");

        end 

        else begin 
          repeat(1)@(ref_vif.ref_cb);
          alu_operation();
          $display("");
          $display(" Ref [%0t] | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,ref_trans.MODE,ref_trans.INP_VALID,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.CIN);
          $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
          $display("");
        end 
      end 

      else begin 
        if(ref_trans.MODE == 0 && ref_trans.CMD inside {single_op_logical}) begin 
          repeat(1)@(ref_vif.ref_cb);
          alu_operation();
          $display("");
          $display(" Ref [%0t] | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,ref_trans.MODE,ref_trans.INP_VALID,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.CIN);
          $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
          $display("");
        end 
        else if(ref_trans.MODE == 1 && ref_trans.CMD inside{single_op_arithmetic}) begin         
          repeat(1)@(ref_vif.ref_cb);
          alu_operation();
          $display("");
          $display(" Ref [%0t] | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,ref_trans.MODE,ref_trans.INP_VALID,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.CIN);
          $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
          $display("");
        end 

        else begin 

          for(count = 0; count < 16; count++) begin 
            repeat(1)@(ref_vif.ref_cb);
            mbx_dr.get(ref_trans);

            if(ref_trans.INP_VALID == 2'b11) begin 
              ref_trans.ERR = 0;
              if((ref_trans.CMD == 9 || ref_trans.CMD == 10) && ref_trans.MODE == 1) begin 
                repeat(2)@(ref_vif.ref_cb);
                alu_operation();
                $display("");
                $display(" Ref [%0t] | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,ref_trans.MODE,ref_trans.INP_VALID,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.CIN);
                $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
                $display("");
              end 

              alu_operation();

              break;
              
            end 
          end 
          $display("COUNT = %0d",count);
          repeat(1)@(ref_vif.ref_cb);
          if(count == 16) begin 
            ref_trans.ERR = 1;
            ref_trans.RES = {(`DATA_WIDTH + 1){1'bz}};
            ref_trans.OFLOW = 1'bz;
            ref_trans.COUT = 1'bz;
            ref_trans.G = 1'bz;
            ref_trans.L = 1'bz;
            ref_trans.E = 1'bz;

            $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
          end 
          $display("");
           $display(" Ref [%0t] | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,ref_trans.MODE,ref_trans.INP_VALID,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.CIN);
          $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
          $display("");

        end 
      end 
      mbx_rs.put(ref_trans);
    end
endtask

  task alu_operation();
    if(ref_vif.ref_cb.reset) begin 	//RESET
          
           ref_trans.RES = {(`DATA_WIDTH + 1){1'bz}};
           ref_trans.OFLOW = 1'bz;
           ref_trans.COUT = 1'bz;
           ref_trans.G = 1'bz;
           ref_trans.L = 1'bz;
           ref_trans.E = 1'bz;
           ref_trans.ERR = 1'bz;
    end 

    else if(ref_vif.ref_cb.CE) begin
        
          //assigning default values
          ref_trans.RES = {(`DATA_WIDTH+1){1'bz}};
          ref_trans.OFLOW = 1'bz;
          ref_trans.COUT = 1'bz;
          ref_trans.G = 1'bz;
          ref_trans.L = 1'bz;
          ref_trans.E = 1'bz;
          ref_trans.ERR = 1'bz;

          if(ref_trans.MODE == 1) begin 						// MODE == 1 | ARITHMETIC MODE

              case(ref_trans.INP_VALID)
                2'b00 : begin 								// INP_VALID == 0
                  ref_trans.RES = 'bz;
                  ref_trans.ERR = 1;
                end
                2'b01 : begin								// INP_VALID == 1
                  case(ref_trans.CMD)
                    4'b0100 : begin						//INC_A
                      ref_trans.RES = ref_trans.OPA + 1;
                      ref_trans.COUT = ref_trans.RES[`DATA_WIDTH];
                    end
                    4'b0101 : begin						//DEC_A
                      ref_trans.RES = ref_trans.OPA - 1;
                      ref_trans.OFLOW = ref_trans.RES[`DATA_WIDTH];
                    end
                    default : begin
                      ref_trans.RES = 'bz;
                      ref_trans.ERR = 1;
                    end
                  endcase
                end
                2'b10 : begin								// INP_VALID == 2
                  case(ref_trans.CMD)
                    4'b0110 : begin						//INC_B
                      ref_trans.RES = ref_trans.OPB + 1;
                      ref_trans.COUT = ref_trans.RES[`DATA_WIDTH];
                    end
                    4'b0111 : begin						//DEC_B
                      ref_trans.RES = ref_trans.OPB - 1;
                      ref_trans.OFLOW = ref_trans.RES[`DATA_WIDTH];
                    end
                    default : begin
                      ref_trans.RES = 'bz;
                      ref_trans.ERR = 1;
                    end
                  endcase                
                end
                2'b11 : begin								// INP_VALID == 3
                  case(ref_trans.CMD)
                    4'b0000 : begin 						//ADD
                      ref_trans.RES = ref_trans.OPA + ref_trans.OPB;
                      ref_trans.COUT = ref_trans.RES[`DATA_WIDTH];
                    end
                    4'b0001 : begin 						//SUB
                      ref_trans.RES = ref_trans.OPA - ref_trans.OPB;
                      ref_trans.OFLOW = ref_trans.RES[`DATA_WIDTH];
                    end
                    4'b0010 : begin 						//ADD_CIN
                      ref_trans.RES = ref_trans.OPA + ref_trans.OPB + ref_trans.CIN;
                      ref_trans.COUT = ref_trans.RES[`DATA_WIDTH];
                    end
                    4'b0011 : begin 						//SUB_CIN
                      ref_trans.RES = ref_trans.OPA - ref_trans.OPB - ref_trans.CIN;
                      ref_trans.OFLOW = ref_trans.RES[`DATA_WIDTH];
                    end
                    4'b0100 : begin						//INC_A
                      ref_trans.RES = ref_trans.OPA + 1;
                      ref_trans.COUT = ref_trans.RES[`DATA_WIDTH];
                    end
                    4'b0101 : begin						//DEC_A
                      ref_trans.RES = ref_trans.OPA - 1;
                      ref_trans.OFLOW = ref_trans.RES[`DATA_WIDTH];
                    end
                   4'b0110 : begin						//INC_B
                      ref_trans.RES = ref_trans.OPB + 1;
                      ref_trans.COUT = ref_trans.RES[`DATA_WIDTH];
                    end
                    4'b0111 : begin						//DEC_B
                      ref_trans.RES = ref_trans.OPB - 1;
                      ref_trans.OFLOW = ref_trans.RES[`DATA_WIDTH];
                    end
                    4'b1000 : begin 						//CMP
                      if(ref_trans.OPA > ref_trans.OPB)
                        ref_trans.G = 1;
                      else if(ref_trans.OPA < ref_trans.OPB)
                        ref_trans.L = 1;
                      else
                        ref_trans.E = 1;
                    end
                    4'b1001 : begin 						//INC_A * INC_B
                      ref_trans.RES = (ref_trans.OPA + 1) * (ref_trans.OPB + 1);
                    end
                    4'b1010 : begin 						// SHL1_A * OPB
                      ref_trans.RES = (ref_trans.OPA << 1) * (ref_trans.OPB);
                    end
                    default : begin
                      ref_trans.RES = 'bz;
                      ref_trans.ERR = 1;
                    end
                  endcase
                end
                default : begin 
                  ref_trans.RES = 'bz;
                  ref_trans.ERR = 1;
                end
              endcase
          end

          else begin 								// MODE == 0 | LOGICAL MODE
            case(ref_trans.INP_VALID)
              2'b00 : begin 							// INP_VALID == 0
                ref_trans.RES = 'bz;
                ref_trans.ERR = 1;
              end 
              2'b01 : begin 							// INP_VALID == 1
                case(ref_trans.CMD)
                  4'b0110 : begin  						//NOT_A
                    ref_trans.RES = ~(ref_trans.OPA);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end 
                  4'b1000 : begin 						//SHR1_A
                    ref_trans.RES = (ref_trans.OPA >> 1);
                  end 
                  4'b1001 : begin 						//SHL1_A
                    ref_trans.RES = (ref_trans.OPA << 1);
                  end 
                  default : begin 
                    ref_trans.RES = 'bz;
                    ref_trans.ERR = 1;
                  end 
                endcase
              end 
              2'b10 : begin 							// INP_VALID == 2
                case(ref_trans.CMD)
                  4'b0111 : begin 						//NOT_B
                    ref_trans.RES = ~(ref_trans.OPB);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end 
                  4'b1010 : begin 						//SHR1_B
                    ref_trans.RES = (ref_trans.OPB >> 1);
                  end 
                  4'b1011 : begin 						//SHL1_B
                    ref_trans.RES = (ref_trans.OPB << 1);
                  end 
                  default : begin 
                    ref_trans.RES = 'bz;
                    ref_trans.ERR = 1;
                  end 
                endcase
              end 
              2'b11 : begin 							// INP_VALID == 3
                case(ref_trans.CMD)
                  4'b0000 : begin 						//AND
                    ref_trans.RES = ref_trans.OPA & ref_trans.OPB;
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end 
                  4'b0001 : begin 						//NAND
                    ref_trans.RES = ~(ref_trans.OPA & ref_trans.OPB);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end 
                  4'b0010 : begin 						//OR
                    ref_trans.RES = (ref_trans.OPA | ref_trans.OPB);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end 
                  4'b0011 : begin 						//NOR
                    ref_trans.RES = ~(ref_trans.OPA | ref_trans.OPB);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end 
                  4'b0100 : begin 						//XOR
                    ref_trans.RES = (ref_trans.OPA ^ ref_trans.OPB);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end 
                  4'b0101 : begin 						//XNOR
                    ref_trans.RES = ~(ref_trans.OPA ^ ref_trans.OPB);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end 
                  4'b0110 : begin 						//NOT_A
                    ref_trans.RES = ~(ref_trans.OPA);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end 
                  4'b0111 : begin 						//NOT_B
                    ref_trans.RES = ~(ref_trans.OPB);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end 
                  4'b1000 : begin 						//SHR1_A
                    ref_trans.RES = (ref_trans.OPA >> 1);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end 
                  4'b1001 : begin 						//SHL1_A
                    ref_trans.RES = (ref_trans.OPA << 1);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end        
                  4'b1010 : begin 						//SHR1_B
                    ref_trans.RES = (ref_trans.OPB >> 1);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end 
                  4'b1011 : begin 						//SHL1_B
                    ref_trans.RES = (ref_trans.OPB << 1);
                    ref_trans.RES[`DATA_WIDTH] = 0;
                  end  
                  4'b1100 : begin 						//ROL_A_B
                    if(| (ref_trans.OPB[`DATA_WIDTH-1 : `SHIFT_WIDTH + 1])) begin
                      ref_trans.ERR = 1;
                      ref_trans.RES = 'bz;
                    end
                    else
                      ref_trans.RES = (ref_trans.OPA << ref_trans.OPB[`SHIFT_WIDTH - 1:0]) | (ref_trans.OPA >> (`DATA_WIDTH - ref_trans.OPB[`SHIFT_WIDTH - 1: 0]));
                  end 
                  4'b1101 : begin 						//ROR_A_B
                    if(| (ref_trans.OPB[`DATA_WIDTH-1 : `SHIFT_WIDTH + 1])) begin
                      ref_trans.ERR = 1;
                      ref_trans.RES = 'bz;
                      end
                    else
                      ref_trans.RES = (ref_trans.OPA >> ref_trans.OPB[`SHIFT_WIDTH - 1:0]) | (ref_trans.OPA << (`DATA_WIDTH - ref_trans.OPB[`SHIFT_WIDTH - 1: 0]));

                  end 


                  default : begin 
                    ref_trans.RES = 'bz;
                    ref_trans.ERR = 1;
                  end 
                endcase
              end 
              default : begin   
                ref_trans.RES = 'bz;
                ref_trans.ERR = 1;
              end 
            endcase
          end 

        end 

  endtask

endclass



