extends Node

class TreeNode:
	var value: int
	var left: TreeNode = null
	var right: TreeNode = null
	var depth: int = 0  # Track depth to limit tree height

	func _init(val, depth_level=0):
		value = val
		depth = depth_level

func insert(root: TreeNode, value: int, depth: int) -> TreeNode:
	if root == null:
		return TreeNode.new(value, depth)

	if depth >= 4:  # Max depth of 4 means 5 levels total (root + 4 levels)
		return root  # Stop inserting deeper

	if value < root.value:
		root.left = insert(root.left, value, depth + 1)
	else:
		root.right = insert(root.right, value, depth + 1)

	return root

func generate_random_bst() -> TreeNode:
	var node_count = randi_range(10, 31)  # Random number of nodes (10 to 31)
	var root = TreeNode.new(randi_range(1, 99), 0)  # Root is at depth 0

	for i in range(node_count - 1):
		var new_value = randi_range(1, 99)
		root = insert(root, new_value, 0)

	return root
