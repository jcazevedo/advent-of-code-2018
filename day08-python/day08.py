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

def value_of_root(tree):
    def aux(tree, i):
        n_nodes = tree[i]
        n_metadata = tree[i + 1]
        child_values = [0]
        n_i = i + 2
        for j in range(0, n_nodes):
            [n_i, c_value] = aux(tree, n_i)
            child_values.append(c_value)
        value = 0
        for j in range(0, n_metadata):
            c = tree[n_i + j]
            if n_nodes == 0:
                value += c
            elif (c < len(child_values)):
                value += child_values[c]
        return [n_i + n_metadata, value]
    return aux(tree, 0)[1]

tree = []
with open("08.input") as f:
    tree = [int(x) for line in f for x in line.split()]

print("Part 1: " + str(metadata_sum(tree)))
print("Part 2: " + str(value_of_root(tree)))
