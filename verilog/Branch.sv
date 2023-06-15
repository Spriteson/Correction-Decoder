
// Branch

module Branch (
    input clk,                              // input clock
    input reset,
    input logic equal, less, w_flag,
    input logic [2:0] flag_in,              // flag bits to rewrite flag status register if 'change_flag' is 1
    input logic branch_instr,               // whether or not current instruction is a branch
    input logic [4:0] immediate,            // the 6-bit branch immediate
    output logic [9:0] address,             // the 9 bit branch address (immediate << 3)
    output logic branch                    // whether or not to branch
);

  logic [2:0] flag_register;

  // Check for every posedge clk to update the flag_register
  always_ff @(posedge clk) begin
      // Updates flag_register only if the w_flag is triggered
      if (w_flag)
          flag_register <= flag_in;
      if (reset)
          flag_register <= 3'b0;
  end

  // Checking the flag_register bits; Use equal, less, and branch_instr in order to determine if we branch
  // Add 3 zeroes to the end of the immediate to get the address and save it into address
  always_comb begin
      // Runs if next instruction is not a branch instruction
      //address = {2'b00, immediate, 3'b0};
      case(immediate)
        5'b00001: address = 9;
        5'b00010: address = 28;
        5'b00011: address = 40;
        5'b00100: address = 52;
        5'b00101: address = 62;
        5'b00110: address = 70;
        5'b00111: address = 98;
        5'b01000: address = 115;
        5'b01001: address = 132;
        5'b01010: address = 150;
        5'b01011: address = 160;
        5'b01100: address = 4;
        5'b01101: address = 125;
        5'b01110: address = 149;
        5'b01111: address = 165;
        5'b10000: address = 179;	
        5'b10001: address = 4;	
      endcase
    case(branch_instr)
      1'b0: branch = 'b0;
      1'b1: begin
          branch = 'b1;
          case (flag_register)
              3'b100: branch = 1'b1;
              3'b000: branch = !equal;
              3'b001: branch = equal;
              3'b010: branch = less;
              3'b011: branch = less | equal;
          endcase
      end
     endcase 
  end

endmodule