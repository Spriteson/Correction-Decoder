// combinational -- no clock
// sample -- change as desired
module alu(
  input[4:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  output logic[7:0] rslt,
  output logic beq, slt
);

always_comb begin 
  rslt = 'b0;            
  case(alu_cmd)
    5'b00000: // add
      rslt = inA + inB;
    5'b00001: // sub
      rslt = inA - inB;
    5'b00010: //and
      rslt = inA & inB;
    5'b00011: // or
      rslt = inA | inB;
    5'b00100: // xor
      rslt = inA ^ inB;
    5'b00101: // rxor 
      rslt = ^inA;
    //5'b00110: // not
      //rslt = !(inA);
    5'b01110: // <<
      rslt = inA << inB;
    5'b01111: // >>
      rslt = inA >> inB;
    default rslt = 8'b01111111;
  endcase
    beq = inA == inB;
    slt  = inA <  inB;
end
   
endmodule