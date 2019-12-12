# ----------------------------------------------------------------------------------
# -- Engineer Name : Mugilvanan Vinayagam
# -- Description   : Python implementaton of Floyd Warshall algorithm to find the 
#                    shortest path from a each node to all other nodes.  
# ----------------------------------------------------------------------------------

file = open("in_c1.txt", "r")

lines = file.readlines()

INT_MAX = 2**30

src = []
dest = []
weight = []

for line in lines:
	edge = line.strip().split(',')
	src.append(int(edge[0]))
	dest.append(int(edge[1]))
	weight.append(int(edge[2]))

# Initialization

paths = []

for i in range(5):
	paths.append([INT_MAX, INT_MAX, INT_MAX, INT_MAX, INT_MAX])

for edge in range(len(src)):
	paths[src[edge] - 1][dest[edge] - 1] = weight[edge]

for srcs in range(1, 6):
	for dests in range(1, 6):
		if srcs == dests:
			paths[srcs - 1][dests - 1] = 0

print(paths)

for inter in range(1, 6):
	for srcs in range(1, 6):
		for dests in range(1, 6):
			previous = str(paths[srcs - 1][dests - 1])			
			temp = paths[srcs - 1][inter - 1] + paths[inter - 1][dests - 1]
			paths[srcs - 1][dests - 1] = min(paths[srcs - 1][dests - 1], temp)

print(paths)
	

