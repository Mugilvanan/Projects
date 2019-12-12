# Code by Kanna Lakshmanan and Mugilvanan Vinayagam
# Functional Simulator - Fetches instructions one by one and
# sends it to each stage of the pipeline.


# stage flags
fetch = 0
decode = 0 
exc = 0
memw = 0
wb = 0 
# temp register variables
R_rt = 0
R_ri = 0
P_C = 0
count = 0

# dictionary to hold instructions
opcode_r_dict = {
	0: "add",
	2: "sub",
	4: "mul",
	6: "or", 
	8: "and",
	10: "xor"
	}
opcode_i_dict = {
	1: "addi",
	3: "subi", 
	5: "muli", 
	7: "ori",
	9: "andi",
	11: "xori",
	12: "ldw",
	13: "stw",
	14: "bz",
	15: "beq",
	16: "jr",
	17: "halt"	 
}

# instruction decode - decodes the ins and calls the execution block 
def instruction_decode(ins,decode):
	global fetch,exc,memw,wb
	if(decode == 1):
		opcode = ins >> 26
		R_s = 0
		R_d = 0
		R_t = 0
		Imm = 0
		# print(hex(ins))
		if opcode in opcode_r_dict.keys():
			R_d = (ins >> 11) & 31
			R_t = (ins >> 16) & 31
			R_s = (ins >> 21) & 31
			# print(opcode_r_dict[opcode], " ", R_s, " ", R_t, " ", R_d)
		elif opcode in opcode_i_dict.keys():
			if (Imm & int('8000', 16)) == int('8000', 16): 
				Imm = ((~Imm & int('ffff', 16)) + 1) * -1
			R_t = (ins >> 16) & 31
			R_s = (ins >> 21) & 31
			# print(opcode_i_dict[opcode], " ", R_s, " ", R_t, " ", Imm)
		instruction_execute(opcode, R_s, R_t, R_d, Imm)
	exc = 1	
	decode = 0
	return opcode

# instruction count variables
instructions = 0
a_ins = 0 
l_ins = 0
c_ins = 0
m_ins = 0

Reg = [0 for i in range(32)]

# executes the instructions and saves register values to temp variables
def instruction_execute(opcode, R_s, R_t, R_d, Imm):
	global instructions, a_ins, l_ins, c_ins, m_ins, mem, P_C,R_ri,R_rt
	global fetch,decode,exc,memw,wb
	instructions += 1
	if (exc == 1):
		if(opcode == 0):
			Reg[R_rt] = Reg[R_s] + Reg[R_t]
			print(Reg[R_d], Reg[R_s], Reg[R_t])
			P_C += 1	
			a_ins += 1
		elif(opcode == 1):
			Reg[R_ri] = Reg[R_s] + Imm
			P_C += 1
			a_ins += 1
		elif(opcode == 2):
			Reg[R_rt] = Reg[R_s] - Reg[R_t]
			P_C += 1
			a_ins += 1
		elif(opcode == 3):
			Reg[R_ri] = Reg[R_s] - Imm	
			P_C += 1
			a_ins += 1
		elif(opcode == 4):
			Reg[R_rt] = Reg[R_s] * Reg[R_t]
			P_C += 1
			a_ins += 1
		elif(opcode == 5):
			Reg[R_ri] = Reg[R_s] * Imm
			P_C += 1
			a_ins += 1
		elif(opcode == 6):
			Reg[R_rt] = Reg[R_s] | Reg[R_t]
			P_C += 1
			l_ins += 1
		elif(opcode == 7):
			Reg[R_ri] = Reg[R_s] | Imm	
			P_C += 1
			l_ins += 1
		elif(opcode == 8):
			Reg[R_rt] = Reg[R_s] & Reg[R_t]
			P_C += 1
			l_ins += 1
		elif(opcode == 9):
			Reg[R_ri] = Reg[R_s] & Imm
			P_C += 1
			l_ins += 1		
		elif(opcode == 10):
			Reg[R_rt] = Reg[R_s] ^ Reg[R_t]
			P_C += 1
			l_ins += 1
		elif(opcode == 11):
			Reg[R_ri] = Reg[R_s] ^ Imm
			P_C += 1
			l_ins += 1
		elif(opcode == 12):
			Reg[R_ri] = mem[(Reg[R_s] + Imm) >> 2]
			if (Reg[R_ri] & int('80000000', 16)) == int('80000000', 16):
			# print(Reg[R_t], ' ', hex(Reg[R_t])) 
				Reg[R_ri] = ((~Reg[R_ri] & int('ffffffff', 16)) + 1) * -1
			P_C += 1
			m_ins += 1
		elif(opcode == 13):
			Reg[R_ri] = Reg[R_t]
			P_C += 1
			m_ins += 1
		elif(opcode == 14):
			if(Reg[R_s] == 0):
				P_C += Imm
			else:
				P_C += 1
			c_ins += 1
		elif(opcode == 15):
			if(Reg[R_s] == Reg[R_t]):
				P_C += Imm
			else:
				P_C += 1
			c_ins += 1
		elif(opcode == 16):
			P_C = Reg[R_s] >> 2
			c_ins += 1
			# print(P_C, ' ', R_s, ' ', Reg[R_s])
		else:
			P_C += 1
			c_ins += 1
		
	exc = 0
	memw = 1
	memory(R_s, R_ri,R_rt,R_d,R_t,Imm,opcode)

in_file = open("final_proj_trace.txt")

mem = [int(c, 16) for c in in_file.read().splitlines()]

# fetches instructions one by one and sends it to decode
def instruction_fetch():
	global fetch,exc,memw,wb,count,P_C
	decode = 1
	while instruction_decode(mem[P_C],decode) != 17:
		# print(mem)
		# print(mem[P_C])
		# op = instruction_decode(mem[P_C],decode) 
		# print("op",op)
		count += 1

	print("Total Instructions: ", instructions)
	print("Arithmetic instructionuctions: ", a_ins)
	print("Logical instruction: ", l_ins)
	print("Memory instructions: ", m_ins)
	print("Control instruction: ", c_ins)

	print("\n\n")

	for i in range(32):
		print("R", i, ": ", Reg[i])

# stores instructions to memory block
def memory(R_s, R_ri,R_rt,R_d,R_t,Imm,opcode):
	global fetch,decode,exc,memw,wb
	if(memw):
		# print("entered memw",memw)
		if(opcode == 13):
			mem[(Reg[R_s] + Imm) >> 2] = Reg[R_ri]	
			# print("rri",R_ri)
	wb = 1
	memw = 0
	# print("calling writeback")
	write_back(R_d,R_t,R_rt,R_ri,opcode)
	

# writes back the register values
def write_back(R_d,R_t,R_rt,R_ri,opcode):
	global fetch,decode,exc,memw,wb
	if(wb):
		# print("writeback entered",wb)
		if(opcode == 0 or opcode == 2 or opcode == 4 or opcode == 6 or opcode == 8 or opcode == 10):
			Reg[R_d] = Reg[R_rt]
			# print("rd",Reg[R_d])

		elif(opcode == 1 or opcode == 3 or opcode == 5 or opcode == 7 or opcode == 9 or opcode == 11 or opcode == 12
		or opcode == 14 or opcode == 15 or opcode == 16 or opcode == 17):
			Reg[R_t] = Reg[R_ri]
	wb = 0
	fetch = 1	


instruction_fetch() 
