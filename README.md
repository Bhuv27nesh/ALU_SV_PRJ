# ALU_SV_PRJ
-----------------------------------------------------------------------------------------

## Project Overview:
The project focuses on the verification of a parameterized Arithmetic Logic Unit (ALU) 
which supports a wide range of arithmetic and logical operations. ALU are an integral part 
of any SOC that performs Arithmetic and logical operations. The ALU supports variety of 
functions including arithmetic operations such as addition, subtraction, increment, 
decrement, and multiplication, as well as logical operations such as AND, OR, XOR, NOT, 
NAND, NOR, and XNOR. In addition, it supports shift and rotate operations. The design 
also has comparator functions and error checking for invalid command conditions. 

## Verification Objective
->Verify functional correctness of all ALU operations — including arithmetic, logical, 
comparison, and shift/rotate — as determined by CMD and MODE.  
->Ensure input protocol compliance by checking that INP_VALID reflects operand 
availability (2'b01, 2'b10, or 2'b11) and operations proceed only when valid.   
->Verify that when only one operand is valid (INP_VALID = 2'b01 or 2'b10), the ALU 
waits up to 16 clock cycles for the second operand, and asserts ERR if it doesn’t 
arrive.   
->Confirm timing behaviour, ensuring results are available after 1 or 2 clock cycles, 
depending on the operation.   
->Apply constrained-random testing and functional coverage to explore all 
valid/invalid input combinations, including edge cases like overflow, underflow, and 
invalid rotate commands.   
