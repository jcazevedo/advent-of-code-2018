def go(tree, i = 0):
    n_nodes = tree[i]
    n_metadata = tree[i + 1]
    child_values = [0]
    metadata_sum = 0
    value = 0
    n_i = i + 2
    for _ in range(0, n_nodes):
        [n_i, c_sum, c_value] = go(tree, n_i)
        metadata_sum += c_sum
        child_values.append(c_value)
    for j in range(0, n_metadata):
        c = tree[n_i + j]
        metadata_sum += c
        if c < len(child_values):
            value += child_values[c]
    if n_nodes == 0:
        value = metadata_sum
    return [n_i + n_metadata, metadata_sum, value]

tree = []
with open("08.input") as f:
    tree = [int(x) for line in f for x in line.split()]

[_, metadata_sum, root_value] = go(tree)

print("Part 1: " + str(metadata_sum))
print("Part 2: " + str(root_value))
