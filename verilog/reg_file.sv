// cache memory/register file
// default address pointer width = 4, for 16 core
module reg_file #(parameter pw=4)(
  input[7:0] dat_in,
  input      clk,
  input      wr_en,           // write enable
  input[pw-1:0] wr_addr,		  // write address pointer
              rd_addrA,		  // read address pointers
			  rd_addrB,
			  regMem
  output logic[7:0] datA_out, // read data
                    datB_out);

  logic[7:0] core[2**pw];    // 2-dim array  8 wide  16 deep

	logic[7:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, rA, rB, rC, rD, rE, rX;

	assign r0 = core[4'b0000];
	assign r1 = core[4'b0001];
	assign r2 = core[4'b0010];
	assign r3 = core[4'b0011];
	assign r4 = core[4'b0100];
	assign r5 = core[4'b0101];
	assign r6 = core[4'b0110];
	assign r7 = core[4'b0111];
	assign r8 = core[4'b1000];
	assign r9 = core[4'b1001];
	assign rA = core[4'b1010];
	assign rB = core[4'b1011];
	assign rC = core[4'b1100];
	assign rD = core[4'b1101];
	assign rE = core[4'b1110];
	assign rX = core[4'b1111];

// reads are combinational
  assign datA_out = core[rd_addrA];
  assign datB_out = core[rd_addrB];
  regMem = rX;
// writes are sequential (clocked)
  always_ff @(posedge clk)
    if(wr_en)				   // anything but stores or no ops
      core[wr_addr] <= dat_in; 

endmodule
/*
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
*/