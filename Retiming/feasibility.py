# -----------------------------------------------------------------------------------------
# -- Engineer Name : Mugilvanan Vinayagam
# -- Description   : Python implementaton of Reiming a givan graph that can be used 
#                    in digital logic. The graph is formed from a small sequential circuit.  
# -----------------------------------------------------------------------------------------

# input file
file = open("input_c2.txt", "r")
# Read all lines and store in list
lines = file.readlines()
# Infinite value
INT_MAX = 2**30
#Defining Clock Period
C = 3

#Finding Number of Nodes
def unique(list1): 
    unique_list = [] 
    for x in list1: 
        if x not in unique_list: 
            unique_list.append(x) 
    return unique_list


# List created for storing edge details
src = []
dest = []
delay = []
weight = []
# Gathering edge details from each line
for line in lines:
	edge = line.strip().split(',')
	src.append(int(edge[0]))
	dest.append(int(edge[1]))
	delay.append(int(edge[2]))
	weight.append(int(edge[3]))
# Finding number of nodes and propagation delay of each node
source = []
delays = []
for i, d in enumerate(src):
	if src[i] not in source:
		source.append(src[i])
		delays.append(delay[i])
n = len(source)
dmax = max(delays)
M = n * dmax

print("n = " + str(n))
print("dmax = " + str(dmax))
print("M = " + str(M))

# Computing s'uv
new_weight = []

for i in range(len(src)):
	new_weight.append(M*weight[i] - delay[i])

print("Input constraint graph G': ")
for i in range(len(src)):
	print("Edge1: Source: " + str(src[i]) + " Destination: " + str(dest[i]) + " Weight: " + str(new_weight[i]))

# s'uv matrix to run Floyd Warshall algorithm on
paths = [[INT_MAX for x in range(len(source))] for y in range(len(source))] 

# Filling default weight information available
for edge in range(len(src)):
	paths[src[edge] - 1][dest[edge] - 1] = new_weight[edge]

# Making diagonals zero
for srcs in range(1, len(source) + 1):
	for dests in range(1, len(source) + 1):
		if srcs == dests:
			paths[srcs - 1][dests - 1] = 0

# Floyd Warshall Algorithm
for inter in range(1, len(source) + 1):
	for srcs in range(1, len(source) + 1):
		for dests in range(1, len(source) + 1):
			previous = str(paths[srcs - 1][dests - 1])			
			temp = paths[srcs - 1][inter - 1] + paths[inter - 1][dests - 1]
			paths[srcs - 1][dests - 1] = min(paths[srcs - 1][dests - 1], temp)

# Creating empty W and D matrix
W = [[0 for x in range(len(source))] for y in range(len(source))]
D = [[0 for x in range(len(source))] for y in range(len(source))] 

import math

# Computing W and D matrix index by index
for i in range(len(source)):
	for j in range(len(source)):
		W[i][j] = math.ceil(paths[i][j]/M)
		D[i][j] = M*W[i][j] + delays[j] - paths[i][j]
print("\nS'uv: ")
for x in range(len(paths)):
	print("\t")
	for y in range(len(paths)):
		print("\t", paths[x][y] ,end='\t')

print("\nW: ")
for x in range(len(W)):
	print("\t")
	for y in range(len(W)):
		print("\t", W[x][y] ,end='\t')

print("\nD: ")
for x in range(len(D)):
	print("\t")
	for y in range(len(D)):
		print("\t", D[x][y] ,end='\t')


while C > 0:
	flag = 0
	print("\nComputing for c = ", C)
	# List created for storing details for Constrained Graph Equations
	cg_source = []
	cg_destination = []
	cg_weight = []
	# creating constraint graph 
	for i in range(len(D)):
		for j in range(len(D[i])):
			if D[i][j]<=C:
				pass
			else: 
				cg_weight.append(((W[i][j])-1))
				cg_source.append(j+1)
				cg_destination.append(i+1)

	cg_source = cg_source + dest
	cg_destination = cg_destination + src
	cg_weight = cg_weight + weight

	print("Equations of Inequalities:")
	for i in range(len(cg_source)):
		print("r" + str(cg_destination[i]) + " - r" + str(cg_source[i]) + " <= " + str(cg_weight[i]))

	#adding extra node with weights 0 and no of nodes is destinatuion
	list_of_nodes = cg_source + cg_destination
	nodes = unique(list_of_nodes)

	short_distance = []

	for x in range(len(nodes)):
		cg_source.append((len(nodes))+1)
		cg_destination.append(nodes[x])
		cg_weight.append(0)
		short_distance.append(INT_MAX)
	short_distance.append(0)


	# Bellman Ford algorithm
	for i in range(len(nodes)):
		for j in range(len(cg_source)):
			if ((short_distance[(cg_source[j])-1] + cg_weight[j]) < (short_distance[(cg_destination[j])-1])):
				short_distance[(cg_destination[j])-1] = (short_distance[(cg_source[j])-1] + cg_weight[j])

	print("Solution: ", short_distance[0 : len(nodes)])

	# Finding if the solution is feasible
	for j in range(len(cg_source)):
		if ((short_distance[(cg_source[j])-1] + cg_weight[j]) < (short_distance[(cg_destination[j])-1])):
			print("Negative cycle found for c = ", C, " Not feasible")
			print("new: " + str((short_distance[(cg_source[j])-1] + cg_weight[j])) + " old: " + str((short_distance[(cg_destination[j])-1])))
			flag = 1
			break
		else:
			print("new: " + str((short_distance[(cg_source[j])-1] + cg_weight[j])) + " old: " + str((short_distance[(cg_destination[j])-1])))
	if flag == 1:
		break
	else:
		print("feasible for c = ", C)
		C = C - 1
