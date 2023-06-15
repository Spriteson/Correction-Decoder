// control decoder
module Control #(parameter opwidth = 9)(
  input [8:0] instr,    // subset of machine code (any width you need)
  output logic Branch, MemtoReg, MemWrite, ALUSrc, RegWrite, FlagWrite, Immed,
  output logic[2:0] Flag,
  output logic[3:0] rd_addrA, rd_addrB , w_addr,
  output logic[4:0] ALUOp);	   // for up to 32 ALU operations

  always_comb begin
  // defaults
    Branch 	=   'b0;   // 1: branch (jump)
    MemWrite  =	'b0;   // 1: store to memory
    ALUSrc 	 =	'b0;   // 1: immediate  0: second reg file output
    RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
    MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
    rd_addrA = 'b1000;  //default read from rA
    rd_addrB = 'b1001;  //default read from rB
    w_addr =   'b1111;  //default write rD
    ALUOp	   = 'b00000; // y = a+0;
    Immed     = 'b0;
    FlagWrite = 'b0;      // 1: update flag   0: keep flag bits the same
    Flag      = 'b000;    // flag bits
	 


  // sample values only -- use what you need
    if (instr[8:6] == 'b010) begin //jump
      Branch = 'b1;                 // instruction jumps
      Immed = 'b1;                // immediate needed to branch
    end
    else if (instr[8:3] == 'b000111) begin  // branch
      FlagWrite = 'b1;                // Writes Flag
      case(instr[2:0])
        'b000:                          
          Flag = instr[2:0];            //sbfne flag
        'b001:                          
          Flag = instr[2:0];            // sbfeg flag
        'b010:
          Flag = instr[2:0];            // sbflt flag
        'b011:
          Flag = instr[2:0];            // sbfle flag
        'b100:
          Flag = instr[2:0];            // sbfjp flag
      endcase
     end
    else if (instr[8:6] == 'b000) begin // Add, sub, ...
        w_addr = {1'b0, instr[2:0]}; // Writes into r0-7
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
    else if (instr[8:4] == 'b00100)begin // shifting
      w_addr = 'b1110;        //sets destination to rS
      ALUSrc = (instr[2:0] == 0) ? 1'b0 : 1'b1; 
      RegWrite = 'b1;
      case (instr[3])
        'b0:                          
          ALUOp = 'b01110;             // left shift 
        'b1:                         
          ALUOp = 'b01111;             // right shift
      endcase
    end
    else if (instr[8:4] == 'b00101) begin // load and store
          rd_addrA = {1'b0, instr[2:0]};       // Read from register given by last 3 bits
          rd_addrB = {1'b0, instr[2:0]};       // Read from register given by last 3 bits
          ALUOp = 'b00010; 
          case (instr[3])
            'b0:  begin                     //load                 
              w_addr = 'b1111;           // writes to register rM
              RegWrite = 'b1;               // write to register
              MemtoReg = 'b1;               // load (route memory to reg file)
            end
            'b1:
              MemWrite = 'b1;               // store
              
          endcase
     end
    else if (instr[8:5] == 'b0110) begin // li - use LUT
      //TODO
      Immed = 'b1;                 // sets to immediate
      RegWrite = 'b1;               // writes to register
      w_addr = 'b1111;           // writes to register rM
    end
    else if (instr[8] == 'b1) begin // mov
      rd_addrA = instr[3:0];
      rd_addrB = instr[3:0];
      w_addr = instr[7:4];
      ALUOp = 'b00010;
      RegWrite = 'b1;
    end
  end
endmodule