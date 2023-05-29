def convert(inFile, outFile1, outFile2):
	assembly_file = open(inFile, 'r')
	machine_file = open(outFile1, 'w')
	lut_file = open(outFile2, 'w')
	assembly = list(assembly_file.read().split('\n'))

	#keep track of index and file line number
	lineNum = 0;
	labelsNum = 0;

	#dictionaries to ease conversion of opcodes/operands to binary
	opcodes = {'Add' : '000000', 'Sub' : '000001', 'And' : '000010', 'Or' : '000011',
	'Xor' : '000100', 'RXor' : '000101', 'Not' : '000110', 'Ls' : '001000', 'Rs' : '001001', 
 	'Lw' : '001010', 'Sw' : '001011', 'Jump' : '010', 'Li' : '0110', 'Move' : '1', 'branchne' : '000111000',
  	'brancheq' : '000111001', 'branchslt' : '000111010', 'branchleq' : '000111011', 'branchjp' : '000111100'}
	registers = {'r0' : '000', 'r1' : '001', 'r2' : '010', 'r3' : '011',
	'r4' : '100', 'r5' : '101', 'r6' : '110', 'r7' : '111', 'rA' : '000', 
 	'rB' : '001', 'rC' : '010', 'rD' : '011', 'rS' : '110', 'rM' : '111'}
 
	#return register number
	def checkReg(reg):
		regOut = ''
		if (reg[1] >= "0" and reg[1] <= "7"):
			regOut += '0'
			regOut += registers[reg]
		elif (reg in registers):
			regOut += '1'
			regOut += registers[reg]
		return regOut


    #return immed value in bin
	def getImmed(immed):
		immedOut = ''
		if (immed >= "0" and immed<= "8"):
			immedOut += bin(int(instr[1]))[2:].zfill(5)
		#elif
		#TODO for other immed value that > 8, need to know what other immed is needed
		return immedOut


	#reads through assembly and collects labels to populate lookup table
	lut = {}
	for line in assembly:
		instr = line.split();
		lineNum += 1
		#check if it is a label or not
		if instr[0] not in opcodes:
			lut[instr[0].replace(':', '')] = labelsNum
			lut_file.write(str(lineNum) + '\n')
			labelsNum += 1
	
	#reads through file to convert instructions to machine code
	for line in assembly:
		output = ""
		instr = line.split(); #split to get instruction and different operands
		#make sure it is an instruction, skip over labels
		if instr[0] in opcodes:
			output += opcodes[instr[0]]
			del instr[0]
			if output[:3] is '000': #for add, sub, and, or, xor, rxor, not
				output += registers[instr[1]]
			elif output[0] is '1':
				#MOV
				reg1 = instr[1][1]
				reg2 = instr[2][1]
				output += checkReg(reg1)
				output += checkReg(reg2)
				#pad to 6 bits for the immediate
				#for i in range(0, 6-len(imm)):
				#	imm = '0'+imm
				#output += imm
			elif output[:3] is '001': #lw, sw, ls, rs
				if output[3:] is '010' or output[3:] is '011': #lw, sw
					output += registers[instr[1]]
				elif output[3:] is '000' or output[3:] is '001': #ls, rs
					output += getImmed(instr[1])[1:] #only need 3 bit
     
			elif output[:4] is '0110': #li
				immed = getImmed(instr[1])       #need all 5 bit
    
			#elif output[:3] is '010': #jump
				#TODO for the Label
    
			#branch already got all 9 bit machine code
				
			#write binary to machine code output file
			machine_file.write(str(output) + '\t// ' + line + '\n')

	assembly_file.close()
	machine_file.close()

#convert("assembly.txt", "machine.txt", "lut.txt")
convert("stringmatch.txt", "sm_machine.txt", "sm_lut.txt")
convert("cordic.txt", "c_machine.txt", "c_lut.txt")
convert("division.txt", "d_machine.txt", "d_lut.txt")