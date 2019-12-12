
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

def instruction_decode(ins):
	global P_C
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
	elif opcode in opcode_i_dict.keys():
		Imm = ins & int('ffff', 16)
		if (Imm & int('8000', 16)) == int('8000', 16): 
			Imm = ((~Imm & int('ffff', 16)) + 1) * -1
		R_t = (ins >> 16) & 31
		R_s = (ins >> 21) & 31
	instruction_execute(opcode, R_s, R_t, R_d, Imm)
	return opcode

instructions = 0
a_ins = 0
l_ins = 0
c_ins = 0
m_ins = 0

Reg = [0 for i in range(32)]

def instruction_execute(opcode, R_s, R_t, R_d, Imm):
	global instructions, a_ins, l_ins, c_ins, m_ins, mem, P_C
	instructions += 1

	if(opcode == 0):
		Reg[R_d] = Reg[R_s] + Reg[R_t]
		P_C += 1
		a_ins += 1
	elif(opcode == 1):
		Reg[R_t] = Reg[R_s] + Imm
		P_C += 1
		a_ins += 1
	elif(opcode == 2):
		Reg[R_d] = Reg[R_s] - Reg[R_t]
		P_C += 1
		a_ins += 1
	elif(opcode == 3):
		Reg[R_t] = Reg[R_s] - Imm	
		P_C += 1
		a_ins += 1
	elif(opcode == 4):
		Reg[R_d] = Reg[R_s] * Reg[R_t]
		P_C += 1
		a_ins += 1
	elif(opcode == 5):
		Reg[R_t] = Reg[R_s] * Imm
		P_C += 1
		a_ins += 1
	elif(opcode == 6):
		Reg[R_d] = Reg[R_s] | Reg[R_t]
		P_C += 1
		l_ins += 1
	elif(opcode == 7):
		Reg[R_t] = Reg[R_s] | Imm	
		P_C += 1
		l_ins += 1
	elif(opcode == 8):
		Reg[R_d] = Reg[R_s] & Reg[R_t]
		P_C += 1
		l_ins += 1
	elif(opcode == 9):
		Reg[R_t] = Reg[R_s] & Imm
		P_C += 1
		l_ins += 1		
	elif(opcode == 10):
		Reg[R_d] = Reg[R_s] ^ Reg[R_t]
		P_C += 1
		l_ins += 1
	elif(opcode == 11):
		Reg[R_t] = Reg[R_s] ^ Imm
		P_C += 1
		l_ins += 1
	elif(opcode == 12):
		Reg[R_t] = mem[(Reg[R_s] + Imm) >> 2]
		if (Reg[R_t] & int('80000000', 16)) == int('80000000', 16):
			# print(Reg[R_t], ' ', hex(Reg[R_t])) 
			Reg[R_t] = ((~Reg[R_t] & int('ffffffff', 16)) + 1) * -1
			# print(Reg[R_t], ' ', hex(Reg[R_t])) 
		P_C += 1
		m_ins += 1
	elif(opcode == 13):
		mem[(Reg[R_s] + Imm) >> 2] = Reg[R_t]
		mem_status[(Reg[R_s] + Imm) >> 2] = 1
		P_C += 1
		m_ins += 1
	elif(opcode == 14):
		if(Reg[R_s] == 0):
			P_C += Imm
		else:
			P_C += 1
		c_ins += 1
	elif(opcode == 15):
		# print(R_s, R_t)
		if(Reg[R_s] == Reg[R_t]):
			P_C += Imm
		else:
			P_C += 1
		c_ins += 1
	elif(opcode == 16):
		P_C = Reg[R_s] >> 2
		c_ins += 1
	else:
		P_C += 1
		c_ins += 1

in_file = open("final_proj_trace.txt")
outfile = open("output_func.bin", "w")

mem = [int(c, 16) for c in in_file.read().splitlines()]

mem_status = [0 for i in range(len(mem))]

P_C = 0
count = 0

while instruction_decode(mem[P_C]) != 17:
	outfile.write(str(Reg))
	outfile.write("\n")
	# print(P_C)
	count += 1

print("Total Instructions: ", instructions)
print("Arithmetic instructions: ", a_ins)
print("Logical instruction: ", l_ins)
print("Memory instructions: ", m_ins)
print("Control instruction: ", c_ins)

print("\n\n")
in_file.close()
outfile.close()
for i in range(32):
	print("R", i, ": ", Reg[i])

print()

for i in range(len(mem)):
	if mem_status[i] == 1:
		print("mem ", i, ": ", mem[i])