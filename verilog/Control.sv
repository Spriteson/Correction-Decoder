// control decoder
module Control #(parameter opwidth = 9, mcodebits = 4)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  output logic RegDst, Branch, MemtoReg, MemWrite, ALUSrc, RegWrite, FlagWrite, Immed,
  output logic[2:0] Flag,
  output logic[3:0] rd_addrA, rd_addrB , w_addr,
  output logic[mcodebits:0] ALUOp);	   // for up to 32 ALU operations

always_comb begin
// defaults
  RegDst 	=   'b0;   // 1: not in place  just leave 0
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	'b0;   // 1: store to memory
  ALUSrc 	 =	'b0;   // 1: immediate  0: second reg file output
  RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  rd_addrA = 'b1000;  //default read from rA
  rd_addrB = 'b1001;  //default read from rB
  w_addr =   'b1011;  //default write rD
  ALUOp	   = 'b00000; // y = a+0;


// sample values only -- use what you need
if (instr[8:3] == b'000111) //branch
else if (instr[8:7] == b'00) begin // Add, sub, ...
  //todo
  if (instr[6] == 0) begin
    WriteAddr = {2'b00, instr[2:0]}; // Writes into r0-7
    RegWrite = 'b1;   
    case (instr[5:3])
      'b000:  
        ALUOp = 'b00000;               //Add
      'b001:                         
        ALUOp = 'b00001;             // sub
      'b010:                         
        ALUOp = 'b00010;             // and
      'b011:                        
        ALUOp = 'b00011;             // or
      'b100:                          
        ALUOp = 'b00100;             // xor
      'b101:                         
        ALUOp = 'b00101;             // rxor
      'b110:                         
        ALUOp = 'b00110;             // not
    endcase
  end
  else begin
    if (instr[6:5] == 00) begin \\ shifting
      WriteAddr = b'1110;        //sets destination to rS
      //TODO   ALUSrc = (instr[2:0] == 0) ? 0 : 1; 
      RegWrite = 'b1;   
      case (instr[4:3])
        'b00:                          
            ALUOp = 'b00100;             // left shift 
        'b01:                         
          ALUOp = 'b00101;             // right shift
      endcase
    end
    else begin \\ load and store
      rd_addrA = {1'b0, instr[2:0]};       // Read from register given by last 3 bits
      rd_addrB = {1'b0, instr[2:0]};       // Read from register given by last 3 bits
      ALUOp = 'b00000; 
      case (instr[4:3])
        'b10:  begin                     //load                 
          WriteAddr = 'b1111;           // writes to register rM
          RegWrite = 'b1;               // write to register
          MemtoReg = 'b1;               // load (route memory to reg file)
        end
        'b11:                         
          MemWrite = 'b1;               // store
      endcase
    end
  end
end
else if (instr[8:6] == b'010) begin  // jump
  Branch = 'b1;
  Immed = 'b1;
end
else if (instr[8:7] == b'0110) becgin // li - use LUT
  //TODO
end
else if (instr[8] == 1) becgin // mov
  ReadAddr1 = instr[3:0];
  ReadAddr2 = instr[3:0];
  WriteAddr = instr[7:4];
  ALUOp = 'b00000;
  RegWrite = 'b1;
end
	
endmodule