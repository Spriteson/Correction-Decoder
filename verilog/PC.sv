// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module PC #(parameter D=10)(
  input reset,					// synchronous reset
        clk,
		    absjump_en,             // abs. jump enable
  input       [D-1:0] target,	// how far/where to jump
  output logic[D-1:0] prog_ctr
);
	wire [D-1:0] target_temp;

  always_ff @(posedge clk)
    if(reset)
	    target_temp <= '0;
	  else if(absjump_en)
	    target_temp <= target;
	  else
	    target_temp <= prog_ctr + 'b1;
	assign prog_ctr = target_temp;

endmodule