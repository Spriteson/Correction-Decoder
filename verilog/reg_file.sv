// cache memory/register file
// default address pointer width = 4, for 16 core
module reg_file #(parameter pw=4)(
  input[7:0] dat_in,
  input      clk, reset,
  input      wr_en,           // write enable
  input[pw-1:0] wr_addr,		  // write address pointer
              rd_addrA,		  // read address pointers
			  rd_addrB,
  output logic[7:0] datA_out, // read data
                    datB_out,
					regMem);

  logic[7:0] core[2**pw];    // 2-dim array  8 wide  16 deep

  logic[7:0] r0, r1, r2, r3, r4, r5, r6, r7, rA, rB, rC, rD,rL,rS, rM;

	assign r0 = core[4'b0000];
	assign r1 = core[4'b0001];
	assign r2 = core[4'b0010];
	assign r3 = core[4'b0011];
	assign r4 = core[4'b0100];
	assign r5 = core[4'b0101];
	assign r6 = core[4'b0110];
	assign r7 = core[4'b0111];	
	assign rA = core[4'b1000];
	assign rB = core[4'b1001];
	assign rC = core[4'b1010];
	assign rD = core[4'b1011];
	assign rL = core[4'b1100];
	assign rS = core[4'b1110];
	assign rM = core[4'b1111];
	

// reads are combinational
  assign datA_out = core[rd_addrA];
  assign datB_out = core[rd_addrB];
  assign regMem = rM;
// writes are sequential (clocked)
  always_ff @(posedge clk) begin
    if (reset) begin
      for (int i = 0; i < 16; i=i+1) core[i] <= 0;
    end
    else			   // anything but stores or no ops
      if (wr_en) core[wr_addr] <= dat_in; 
  end

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