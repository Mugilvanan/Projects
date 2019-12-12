"""
Author     : Mugilvanan Vinayagam, Kanna Lakshmanan.
Date       : 2/6/2019.
Description: Implementation of pipeline with forwarding logic.  
"""

import copy
# Global Variables
P_C          = 0
Stall_count  = 0
Stall_cycles = 0
clock        = 0
halt	     = 0
stall        = 0
branch       = 0
# Dictionary of opcode and instruction
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

# Registers
Reg = [0 for i in range(32)]
Reg_status = [0 for i in range(32)]

# Opening trace file
in_file = open("final_proj_trace.txt")

# Memory
mem = [int(c, 16) for c in in_file.read().splitlines()]
mem_status = [0 for i in range(len(mem))]

P_C = 0

# Class with all neccessary details
class packed:
	def __init__(self):
		self.instr  = 0
		self.opcode = 18
		self.R_s    = 0
		self.R_t    = 0
		self.R_d    = 0
		self.Imm    = 0
		self.e_addr = 0
		self.reg_o  = 0
		self.b_t    = 0
		self.reg_s  = 0
		self.reg_t  = 0
		self.reg    = 0
		self.f_reg  = 0

# Objects for each stage
i_s = packed()
d_s = packed()
e_s = packed()
m_s = packed()
w_s = packed()
nop = packed()

# Instructions counter
ins   = 0
a_ins = 0
c_ins = 0
l_ins = 0
m_ins = 0

# Execute stage funtion
def execute():
	global e_s, P_C, ins, a_ins, l_ins, c_ins, m_ins
	if e_s.opcode != 18:
		ins += 1
	if e_s.opcode == 0:
		e_s.reg_o = e_s.reg_s + e_s.reg_t
		a_ins += 1
	elif e_s.opcode == 1:
		e_s.reg_o = e_s.reg_s + e_s.reg_t
		a_ins += 1
	elif e_s.opcode == 2:
		e_s.reg_o = e_s.reg_s - e_s.reg_t
		a_ins += 1
	elif e_s.opcode == 3:
		e_s.reg_o = e_s.reg_s - e_s.reg_t
		a_ins += 1		
	elif e_s.opcode == 4:
		e_s.reg_o = e_s.reg_s * e_s.reg_t
		a_ins += 1
	elif e_s.opcode == 5:
		e_s.reg_o = e_s.reg_s * e_s.reg_t
		a_ins += 1	
	elif e_s.opcode == 6:
		e_s.reg_o = e_s.reg_s | e_s.reg_t
		l_ins += 1
	elif e_s.opcode == 7:
		e_s.reg_o = e_s.reg_s | e_s.reg_t
		l_ins += 1
	elif e_s.opcode == 8:
		e_s.reg_o = e_s.reg_s & e_s.reg_t
		l_ins += 1
	elif e_s.opcode == 9:
		e_s.reg_o = e_s.reg_s & e_s.reg_t
		l_ins += 1	
	elif e_s.opcode == 10:
		e_s.reg_o = e_s.reg_s ^ e_s.reg_t
		l_ins += 1
	elif e_s.opcode == 11:
		e_s.reg_o = e_s.reg_s ^ e_s.reg_t
		l_ins += 1
	elif e_s.opcode == 12:
		e_s.e_addr = (e_s.reg_s + e_s.reg_t) >> 2
		m_ins += 1
	elif e_s.opcode == 13:
		e_s.e_addr = (e_s.reg_s + e_s.reg_t) >> 2
		m_ins += 1
	elif e_s.opcode == 14:
		c_ins += 1
		if e_s.reg_s == 0:
			# print(P_C)
			P_C = P_C + e_s.reg_t - 3
			# print(P_C)
			e_s.b_t = 1
	elif e_s.opcode == 15:
		c_ins += 1
		# print(e_s.reg_s, " ", e_s.reg)
		if e_s.reg_s == e_s.reg:
			# print(P_C)
			P_C = P_C + e_s.reg_t - 3
			# print(P_C)
			e_s.b_t = 1
	elif e_s.opcode == 16:
		c_ins += 1
		# print(P_C, " ", e_s.reg_s)
		P_C = e_s.reg_s >> 2
		# print(P_C)
		e_s.b_t = 1	
	elif e_s.opcode == 17:
		c_ins += 1

# Output log file
in_f = open("output_fin.bin", "w")	

stall_prev = 0
stall_next = 0
halt_de = 0

# Program runs till halt
while halt == 0:

	clock += 1
	# print("Clock: ", clock, " Stall: ", Stall_cycles, " PC: ", P_C)
	############ Instruction Fetch Stage
	if stall == 0 and halt_de == 0:
		i_s.instr = mem[P_C]
		P_C       = P_C + 1
	elif halt_de == 1:
		i_s.instr = 1207959552

	############ Instruction Decode Stage
	stall_prev = stall
	if d_s.instr != 0:
		d_s.opcode = d_s.instr >> 26
		if d_s.opcode in opcode_r_dict.keys():
			d_s.R_d = (d_s.instr >> 11) & 31
			d_s.R_t = (d_s.instr >> 16) & 31
			d_s.R_s = (d_s.instr >> 21) & 31
		elif d_s.opcode in opcode_i_dict.keys():
			d_s.Imm = d_s.instr & int('ffff', 16)
			if (d_s.Imm & int('8000', 16)) == int('8000', 16) and d_s.opcode not in [7, 9, 11]: 
				d_s.Imm = ((~d_s.Imm & int('ffff', 16)) + 1) * -1 
			d_s.R_t = (d_s.instr >> 16) & 31
			d_s.R_s = (d_s.instr >> 21) & 31

		if stall == 1:
			Stall_cycles += 1
		if e_s.opcode == 12 or stall == 1:
			if d_s.R_s == e_s.R_d and d_s.R_s != 0:
				stall = 1
				# print("here")
			elif d_s.R_s == e_s.R_t and d_s.R_s != 0:
				stall = 1
				# print("here1")
			elif d_s.R_t == e_s.R_d and d_s.R_t != 0:
				if d_s.opcode in opcode_r_dict.keys() or d_s.opcode == 15:
				# print("yes")
					stall = 1
				# print("here")
			elif d_s.R_t == e_s.R_t and d_s.R_t != 0:
				if d_s.opcode in opcode_r_dict.keys() or d_s.opcode == 15:
				# print("yes")
					stall = 1
				# print("here1")		
			else:
				stall = 0

			# print("Stall: ", stall)

		# Forwarding logic
		if stall == 0:
			if d_s.opcode in opcode_r_dict.keys() and stall == 0:
				d_s.reg_s = Reg[d_s.R_s]
				d_s.reg_t = Reg[d_s.R_t]
			elif d_s.opcode in opcode_i_dict.keys() and stall == 0:
				d_s.reg_s = Reg[d_s.R_s]
				d_s.reg_t = d_s.Imm
				d_s.reg = Reg[d_s.R_t]
			if d_s.R_s == w_s.R_d and d_s.R_s != 0:
				d_s.reg_s = w_s.f_reg
				# print("here")
			elif d_s.R_s == w_s.R_t and d_s.R_s != 0:
				d_s.reg_s = w_s.f_reg
				# print("here1")
			elif d_s.R_t == w_s.R_d and d_s.R_t != 0:
				if d_s.opcode in opcode_r_dict.keys():
					# print("yes")
					d_s.reg_t = w_s.f_reg
				if d_s.opcode == 15:
					d_s.reg = w_s.f_reg	
			elif d_s.R_t == w_s.R_t and d_s.R_t != 0:
				if d_s.opcode in opcode_r_dict.keys():
					# print("yes")
					d_s.reg_t = w_s.f_reg
				if d_s.opcode == 15:
					d_s.reg = w_s.f_reg				
			if d_s.R_s == m_s.R_d and d_s.R_s != 0:
				d_s.reg_s = m_s.f_reg
				# print("here")
			elif d_s.R_s == m_s.R_t and d_s.R_s != 0:
				d_s.reg_s = m_s.f_reg
				# print("here1")
			elif d_s.R_t == m_s.R_d and d_s.R_t != 0:
				if d_s.opcode in opcode_r_dict.keys():
					# print("yes")
					d_s.reg_t = m_s.f_reg
				if d_s.opcode == 15:
					d_s.reg = m_s.f_reg	
			elif d_s.R_t == m_s.R_t and d_s.R_t != 0:
				if d_s.opcode in opcode_r_dict.keys():
					# print("yes")
					d_s.reg_t = m_s.f_reg
				if d_s.opcode == 15:
					d_s.reg = m_s.f_reg	
		if d_s.opcode == 17:
			# clock += 1
			halt_de = 1
			P_C -= 1
	stall_next = stall

	if stall_next == 1 and stall_prev == 0:
		Stall_count += 1

	################### Execution Stage
	if e_s.opcode != 18:
		# Forwarding logic
		if e_s.R_s == m_s.R_d and e_s.R_s != 0:
			e_s.reg_s = m_s.f_reg
			# print("here")
		elif e_s.R_s == m_s.R_t and e_s.R_s != 0:
			e_s.reg_s = m_s.f_reg
			# print("here1")
		elif e_s.R_t == m_s.R_d and e_s.R_t != 0:
			if e_s.opcode in opcode_r_dict.keys():
				# print("yes")
				e_s.reg_t = m_s.f_reg
			if e_s.opcode == 15:
				e_s.reg = m_s.f_reg
		elif e_s.R_t == m_s.R_t and e_s.R_t != 0:
			if e_s.opcode in opcode_r_dict.keys() or e_s.opcode == 15:
				# print("yes")
				e_s.reg_t = m_s.f_reg
			if e_s.opcode == 15:
				e_s.reg = m_s.f_reg							
		if e_s.R_s == w_s.R_d and e_s.R_s != 0:
			e_s.reg_s = w_s.f_reg
			# print("here")
		elif e_s.R_s == w_s.R_t and e_s.R_s != 0:
			e_s.reg_s = w_s.f_reg
			# print("here1")
		elif e_s.R_t == w_s.R_d and e_s.R_t != 0:
			if e_s.opcode in opcode_r_dict.keys():
				# print("yes")
				e_s.reg_t = w_s.f_reg
			if e_s.opcode == 15:
				e_s.reg = w_s.f_reg	
		elif e_s.R_t == w_s.R_t and e_s.R_t != 0:
			if e_s.opcode in opcode_r_dict.keys():
				# print("yes")
				e_s.reg_t = w_s.f_reg
			if e_s.opcode == 15:
				e_s.reg = w_s.f_reg		
		execute()
		e_s.f_reg = e_s.reg_o
		if(e_s.b_t == 1):
			branch += 1

	################### Memory Stage
	if m_s.opcode != 18:	
		if m_s.opcode == 12:
			m_s.reg_o = mem[m_s.e_addr]
			if (m_s.reg_o & int('80000000', 16)) == int('80000000', 16):
				m_s.reg_o = ((~m_s.reg_o & int('ffffffff', 16)) + 1) * -1			
		elif m_s.opcode == 13:
			mem[m_s.e_addr] = Reg[m_s.R_t]
			mem_status[m_s.e_addr] = 1
		
		m_s.f_reg = m_s.reg_o

	################### WriteBack Stage
	if w_s.opcode != 18:
		if w_s.opcode in [0, 2, 4, 6, 8, 10]:
			Reg[w_s.R_d] = w_s.reg_o
			Reg_status[w_s.R_d] = 1
		elif w_s.opcode in [1, 3, 5, 7, 9, 11, 12]:
			Reg[w_s.R_t] = w_s.reg_o
			Reg_status[w_s.R_t] = 1

		w_s.f_reg = w_s.reg_o

		if w_s.opcode == 17:
			# clock += 1
			halt = 1

	# Logging current state of Each Stage
	in_f.write("**********************************************************************************************\n")
	in_f.write("Clock: %4d   Stall: %1d   P_C: %4d   Stall_count: %4d   Stall_cycles: %4d\n"%(clock, stall, P_C << 2, Stall_count, Stall_cycles))
	in_f.write("**********************************************************************************************\n")
	in_f.write("Instruction Fetch: \n")
	in_f.write(format("Instruction: %08x\n" %i_s.instr))
	in_f.write("Decode: \n")
	if d_s.opcode in opcode_r_dict.keys():
		in_f.write("Instruction: %08x Opcode: %4d R_s: %4d R_t: %4d R_d: %4d R_s_val: %4d R_t_val: %4d\n"%(d_s.instr, d_s.opcode, d_s.R_s, d_s.R_t, d_s.R_d, d_s.reg_s, d_s.reg_t))
	elif d_s.opcode in opcode_i_dict.keys():
		in_f.write("Instruction: %08x Opcode: %4d R_s: %4d R_t: %4d Imm: %4d R_s_val: %4d Imm_val: %4d\n"%(d_s.instr, d_s.opcode, d_s.R_s, d_s.R_t, d_s.Imm, d_s.reg_s, d_s.reg_t))
	in_f.write("Execution: \n")
	if e_s.opcode in opcode_r_dict.keys():
		in_f.write("Instruction: %08x Opcode: %4d R_s: %4d R_t: %4d R_d: %4d R_s_val: %4d R_t_val: %4d Reg_o: %4d Eff_addr: %4d b_t: %2d\n"%(e_s.instr, e_s.opcode, e_s.R_s, e_s.R_t, e_s.R_d, e_s.reg_s, e_s.reg_t, e_s.reg_o, e_s.e_addr, e_s.b_t))
	elif e_s.opcode in opcode_i_dict.keys():
		in_f.write("Instruction: %08x Opcode: %4d R_s: %4d R_t: %4d Imm: %4d R_s_val: %4d Imm_val: %4d Reg_o: %4d Eff_addr: %4d b_t: %2d\n"%(e_s.instr, e_s.opcode, e_s.R_s, e_s.R_t, e_s.Imm, e_s.reg_s, e_s.reg_t, e_s.reg_o, e_s.e_addr, e_s.b_t))


	in_f.write("Memory: \n")
	in_f.write("Instruction: %08x Opcode: %4d R_s: %4d R_t: %4d R_d: %4d R_s_val: %4d Imm_val: %4d Reg_o: %4d Eff_addr: %4d\n"%(m_s.instr, m_s.opcode, m_s.R_s, m_s.R_t, m_s.Imm, m_s.reg_s, m_s.reg_t, m_s.reg_o, m_s.e_addr))
	in_f.write("Write Back: \n")
	in_f.write("Instruction: %08x Opcode: %4d R_s: %4d R_t: %4d R_d: %4d R_s_val: %4d Imm_val: %4d Reg_o: %4d Eff_addr: %4d\n"%(w_s.instr, w_s.opcode, w_s.R_s, w_s.R_t, w_s.Imm, w_s.reg_s, w_s.reg_t, w_s.reg_o, w_s.e_addr))	
	in_f.write("\n")

	# Object Transfer
	if e_s.b_t == 1:
		d_s = copy.deepcopy(nop)
		stall = 0
		halt_de = 0

	w_s = copy.deepcopy(m_s)
	m_s = copy.deepcopy(e_s)
	if stall == 0 and e_s.b_t == 0:
		e_s = copy.deepcopy(d_s)
		d_s = copy.deepcopy(i_s)
	else:
		e_s = copy.deepcopy(nop)

# Printing Statistics
print()
print("Progrm Counter: ", P_C << 2)
print("Total number of instructions:",  ins)
print("Arithmetic instructions: ", a_ins)
print("Logical instructions: ", l_ins)
print("Memory access instructions: ", m_ins)
print("Control transfer instructions: ", c_ins)

print()

for i in range(32):
	if Reg_status[i] == 1:
		print("Reg ", i, ": ", Reg[i])

print()

for i in range(len(mem)):
	if mem_status[i] == 1:
		print("mem ", i, ": ", mem[i])

print()

print("clock: ", clock, "Stall_count: ", Stall_count, " Stall_cycles: ", Stall_cycles, "Stall_penality: ", float(1.0*Stall_cycles/Stall_count), " Branches: ", branch)

in_f.close()
in_file.close()
	