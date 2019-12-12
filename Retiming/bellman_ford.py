# ----------------------------------------------------------------------------------
# -- Engineer Name : Mugilvanan Vinayagam
# -- Description   : Python implementaton of Bellman Ford algorithm to find the 
#                    shortest path from a particular node to all other nodes.  
# ----------------------------------------------------------------------------------


file = open("in_ch.txt", "r")

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

paths = [INT_MAX, INT_MAX, INT_MAX, INT_MAX, 0]

for i in range(1, 5):
	for ind, data in enumerate(src):
		previous = str(paths[dest[ind] - 1])
		temp = paths[src[ind] - 1] + weight[ind]
		paths[dest[ind] - 1] = min(paths[dest[ind] - 1], temp)
	print(paths)
		# print("Source: " + str(src[ind]) + " Dest: " + str(dest[ind]) + " Previous: " + str(previous) + " Now: " + str(paths[dest[ind] - 1]), paths)

print(paths)
