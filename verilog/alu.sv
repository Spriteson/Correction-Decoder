
// ALU 8 bit

module alu (
    input logic [7:0] inA, inB,
    input logic [4:0] operation,

    output logic [7:0] rslt,
    output logic equal, less
);

always_comb begin
    case(operation)
		 5'b00000: // add
			rslt = inA + inB;
		 5'b00001: // sub
			rslt = inA - inB;
		 5'b00010: //and
			rslt = inA & inB;
		 5'b00011: // or
			rslt = inA | inB;
		 5'b00100: // Rxor
			rslt = ^inA;
		 5'b00101: // xor 
			rslt = inA ^ inB; 
		 5'b00110: // not
			rslt = !(inA);
		 5'b01110: // <<
			rslt = inA << inB;
		 5'b01111: // >>
			rslt = inA >> inB;
		 default     : rslt = 8'b11111111;    // error
    endcase
    equal = inA == inB;
    less  = inA <  inB;
end
endmodule