# ----------------------------------------------------------------------------------
# -- Engineer Name : Mugilvanan Vinayagam
# -- Description   : Python implementaton of strongly connected components algorithm  
#                    using Recursion.  
# ----------------------------------------------------------------------------------

class SCC:

	def __init__(self):
		self.nodes = {}
		self.vertices = {}
		self.nodes_t = {}
		self.vertices_t = {}
		self.stack = []
		self.stack_t = {}
		self.out_key = 0

	# Read file and creates vertices & nodes dictionary
	def initialisation(self, filename):
		file = open(filename, "r")

		lines = file.readlines()

		for line in lines:
			edge = line.strip().split(',')
			self.nodes.setdefault(int(edge[0]), []).append(int(edge[1]))
			self.nodes_t.setdefault(int(edge[1]), []).append(int(edge[0]))
			if int(edge[0]) not in self.vertices.keys():
				self.vertices[int(edge[0])] = False
			if int(edge[1]) not in self.vertices.keys():
				self.vertices[int(edge[1])] = False
			if int(edge[0]) not in self.vertices_t.keys():
				self.vertices_t[int(edge[0])] = False
			if int(edge[1]) not in self.vertices_t.keys():
				self.vertices_t[int(edge[1])] = False

	# Recursive function to do Depth First Search
	def sort(self, vertex):
		self.vertices[vertex] = True
		
		if vertex in self.nodes.keys():
			count = 0
			for v in self.nodes[vertex]:
				if self.vertices[v] == False:
					self.sort(v)
			self.stack.append(vertex)
		else:
			self.stack.append(vertex)

	# Recursive function to do DFS for trversed graph
	def sort_t(self, vertex):
		self.vertices_t[vertex] = True	
		if vertex in self.nodes_t.keys():
			count = 0
			for v in self.nodes_t[vertex]:
				if self.vertices_t[v] == False:
					self.sort_t(v)
			self.stack_t.setdefault(self.out_key, []).append(vertex)
		else:
			self.stack_t.setdefault(self.out_key, []).append(vertex)

	# Function that initiates DFS of normal graph
	def sort_init(self):
		for v in self.vertices.keys():
			if self.vertices[v] == False:
				self.sort(v)

	# Function to find SCCs in the graph
	def find_scc(self):
		self.sort_init()
		self.stack.reverse()
		for v in self.stack:
			if self.vertices_t[v] == False:
				self.sort_t(v)
				self.out_key = self.out_key + 1

	# Function to print SCCs
	def printing_scc(self):
		val_len = {}
		for key in self.stack_t.keys():
			val_len[key] = len(self.stack_t[key])
		import operator
		stack_t_sorted = sorted(val_len.items(), key=operator.itemgetter(1), reverse=True)
		import collections
		val_len = collections.OrderedDict(stack_t_sorted)
		for key in val_len.keys():
			for val in self.stack_t[key]:
				print(val, " ", end ='')
			print()

scc_10 = SCC()

print("Passing graph with 10 nodes....\n")

scc_10.initialisation("graph_10.txt")

scc_10.find_scc()
print("SCCs in the graph:")
scc_10.printing_scc()

scc_15 = SCC()

print("\n\nPassing graph with 15 nodes....\n")

scc_15.initialisation("graph_15.txt")

scc_15.find_scc()
print("SCCs in the graph:")
scc_15.printing_scc()




