// sample top level design
module top_level(
  input        clk, reset, 
  output logic done);
  parameter D = 10;             // program counter width
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  wire[7:0]   datA,datB,		  // from RegFile
              muxB, muxR, 
			  rslt,                // alu output
  			  mem_data, 
  			  muxOut,
              rM;
  wire[4:0] ALUOp;
  wire[2:0] Flag;
  wire  absj;                     // from control to PC; abs jump enable
  wire  aluEqual, aluLess;
  wire  RegWrite,
  		MemtoReg,
  		Branch,
        MemWrite,
        ALUSrc,
  		FlagWrite,
  		Immed;		              // immediate switch
  //wire[5:0] alu_cmd;
  wire[8:0] mach_code;          // machine code
  wire[3:0] rd_addrA, rd_addrB, wr_addr;    // address pointers to reg_file
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		 .absjump_en (absj),
		 .target           ,
		 .prog_ctr          );

// lookup table to facilitate jumps/branches
//  PC_LUT #(.D(D))
//    pl1 (.addr  (how_high),
//         .target          );   

// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

// control decoder
  Control  ctl1(.instr(mach_code),
  .Branch   , 
  .MemWrite , 
  .ALUSrc   , 
  .RegWrite   ,     
  .MemtoReg,
  .Flag,
  .FlagWrite,
  .Immed,
  .rd_addrA(rd_addrA),
  .rd_addrB(rd_addrB),
  .w_addr(wr_addr),
  .ALUOp);


  reg_file rf1(.dat_in(muxR),	   // loads, most ops
              .clk         ,
              .reset,
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (wr_addr),      // in place operation
              .datA_out(datA),
              .datB_out(datB),
              .regMem     (rM)); 

  assign muxB = ALUSrc? {5'b0, mach_code[2:0]} : datB;
  assign muxR = MemtoReg ? mem_data : muxOut;
  assign muxOut = Immed ? {3'b0, mach_code[4:0]} : rslt;

  alu alu1(
    	 .alu_cmd(ALUOp),
         .inA    (datA),
		 .inB    (muxB),
		 .rslt   (rslt),
         .beq   (aluEqual),
         .slt   (aluLess)
          );
           

  dat_mem dm1(.dat_in(rM)  ,  // from reg_file
         .clk,    
         .wr_en  (MemWrite), // stores
         .addr   (muxOut),
         .dat_out(mem_data));

  Branch br_inst(
    .clk,
    .reset,
    .equal       (aluEqual),
    .less        (aluLess),
    .w_flag      (FlagWrite),
    .flag_in     (Flag),
    .branch_instr(Branch),
    .immediate   (muxOut[4:0]),
    .address     (target),
    .branch      (absj)
  );

  assign done = prog_ctr == 1;
 
endmodule