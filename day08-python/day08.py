import sys

def metadata_sum(tree):
    def aux(tree, i):
        n_nodes = tree[i]
        n_metadata = tree[i + 1]
        metadata_sum = 0
        n_i = i + 2
        for j in range(0, n_nodes):
            [n_i, c_sum] = aux(tree, n_i)
            metadata_sum += c_sum
        for j in range(0, n_metadata):
            metadata_sum += tree[n_i + j]
        return [n_i + n_metadata, metadata_sum]
    return aux(tree, 0)[1]

tree = []
with open("08.input") as f:
    tree = [int(x) for line in f for x in line.split()]

print("Part 1: " + str(metadata_sum(tree)))
