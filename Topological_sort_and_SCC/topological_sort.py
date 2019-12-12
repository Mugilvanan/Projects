class topological_sort:

	def __init__(self):
		self.nodes = {}
		self.vertices = {}
		self.stack = []

	# Read file and creates vertices & nodes dictionary
	def initialisation(self, filename):
		file = open(filename, "r")

		lines = file.readlines()

		for line in lines:
			edge = line.strip().split(',')
			self.nodes.setdefault(int(edge[0]), []).append(int(edge[1]))
			if int(edge[0]) not in self.vertices.keys():
				self.vertices[int(edge[0])] = False
			if int(edge[1]) not in self.vertices.keys():
				self.vertices[int(edge[1])] = False

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

topo_sort_8 = topological_sort()

print("Passing graph with 8 nodes....\n")

topo_sort_8.initialisation("graph_8.txt")

for v in topo_sort_8.vertices.keys():
	if topo_sort_8.vertices[v] == False:
		topo_sort_8.sort(v)
topo_sort_8.stack.reverse()
print("Topological order of the graph:")
print(topo_sort_8.stack)

topo_sort_13 = topological_sort()

print("\n\nPassing graph with 13 nodes....\n")

topo_sort_13.initialisation("graph_13.txt")

for v in topo_sort_13.vertices.keys():
	if topo_sort_13.vertices[v] == False:
		topo_sort_13.sort(v)
topo_sort_13.stack.reverse()
print("Topological order of the graph:")
print(topo_sort_13.stack)


