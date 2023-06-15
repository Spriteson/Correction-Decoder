def convert(inFile, outFile1, outFile2):
    assembly_file = open(inFile, 'r')
    machine_file = open(outFile1, 'w')
    lut_file = open(outFile2, 'w')
    assembly = list(assembly_file.read().split('\n'))

    #keep track of index and file line number
    lineNum = 0
    labelsNum = 0

    #dictionaries to ease conversion of opcodes/operands to binary
    opcodes = {'add' : '000000', 'sub' : '000001', 'and' : '000010', 'or' : '000011',
    'xor' : '000100', 'rxor' : '000101', 'not' : '000110', 'ls' : '001000', 'rs' : '001001', 
    'lw' : '001010', 'sw' : '001011', 'jump' : '010', 'li' : '0110', 'move' : '1', 'branch':'000111','ne' : '000',
    'eq' : '001', 'slt' : '010', 'eq' : '011', 'jp' : '100'}
    registers = {'r0' : '000', 'r1' : '001', 'r2' : '010', 'r3' : '011',
    'r4' : '100', 'r5' : '101', 'r6' : '110', 'r7' : '111', 'rA' : '000', 
    'rB' : '001', 'rC' : '010', 'rD' : '011', 'rS' : '110', 'rM' : '111'}
    lut = {'loop' : '00001', 'a2' : '00010', 'a3' : '00011',
    'a4' : '00100', 'partb' : '00101', 'c1' : '00110', 'c2' : '00111', 'c3' : '01000', 
    'c4' : '01001', 'count' : '01010', 'end' : '01011', 'loop2' : '01100', 'p0err' : '01101', 'fixLSW' : '01110','fixMSW' : '01111',
    'out': '10000',  'loop1' : '10001'}
 
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
        immedOut += format(int(immed),'05b')
        #elif
        #TODO for other immed value that > 8, need to know what other immed is needed
        return immedOut


    #reads through assembly and collects labels to populate lookup table     
    #reads through file to convert instructions to machine code
    for line in assembly:
        output = ""
        instr = line.split() #split to get instruction and different operands
        #make sure it is an instruction, skip over labels
        if instr[0] in opcodes:
            output += opcodes[instr[0]]
            #del instr[0]
            if output[:3] == '000' and output[3:6] != '111': #for add, sub, and, or, xor, rxor, not
                output += registers[instr[1]]
                if instr[1] < 'r0' or instr[1] > 'r7':
                    print("incorrect register for add....")
                    print(line)
            elif output[0] == '1':
                #MOV
                if instr[1] not in registers:
                    print("incorrect register for move")
                    print(line)
                reg1 = instr[1]
                reg2 = instr[2]
                output += checkReg(reg1)
                output += checkReg(reg2)
            elif output[:3] == '001': #lw, sw, ls, rs
                if output[3:] == '010' or output[3:] == '011': #lw, sw
                    output += registers[instr[1]]
                    if instr[1] < 'r0' or instr[1] > 'r7':
                        print("incorrect register for lw, sw")
                        print(line)
                elif output[3:] == '000' or output[3:] == '001': #ls, rs
                    output += getImmed(instr[1])[2:] #only need 3 bit
                    if instr[1] < '0' or instr[1] > '7':
                        print("incorrect number for lw, sw")
                        print(line)
     
            elif output[:4] == '0110': #li
                output += format(int(int(instr[1])),'05b')      #need all 5 bit
                if int(instr[1]) < 0 or int(instr[1]) > 32:
                    print("incorrect number for li")
                    print(line)
                    print(format(int(int(instr[1])),'05b'))
                 
    
            elif output[:3] == '010': #jump
                output += '0'
                output += lut[instr[1]]
                if instr[1] not in lut:
                        print("incorrect label for jummp")
                        print(line)
            elif instr[1] in opcodes: #branch
                output += opcodes[instr[1]]
                if instr[1] not in opcodes:
                        print("incorrect end for branch")
                        print(line)
    
            #branch already got all 9 bit machine code
                
            #write binary to machine code output file
            #machine_file.write(str(output) + '\t// ' + line + '\n')
            machine_file.write(str(output) +'\n')
    assembly_file.close()
    machine_file.close()

#convert("assembly.txt", "machine.txt", "lut.txt")
#convert("stringmatch.txt", "sm_machine.txt", "sm_lut.txt")
#convert("cordic.txt", "c_machine.txt", "c_lut.txt")
#convert("division.txt", "d_machine.txt", "d_lut.txt")
convert("program1NoComment.txt", "machine1No.txt", "lut.txt")
convert("prog2NoComment.txt", "machine2No.txt", "lut.txt")
convert("prog2NoComment.txt", "machine3No.txt", "lut.txt")