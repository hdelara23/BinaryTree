extends Node3D

# Load BinaryTree script to generate the BST
var binary_tree = preload("res://scenes/binary_tree/Scripts/BinaryTree.gd").new()
var bst_root  # Stores the generated binary search tree

# UI Elements inside the Viewport
var viewport
var find_label
var arraylist_label
var new_tree_button
var undo_button
var exit_button

# Reference to TreeRenderer (for rendering BST in 3D)
@onready var tree_renderer = $TreeRenderer

var target_value: int
var arraylist = []

func _ready():
	print("Find scene loaded!")

	# Wait for everything to load before accessing nodes
	await get_tree().process_frame  

	# Get the FindMenu node (Viewport2DIn3D)
	viewport = $FindMenu  

	if viewport:
		var find_ui = viewport.get_child(0)  # Get FindUI.tscn instance

		if find_ui:
			# ✅ Ensure correct paths to UI elements
			find_label = find_ui.get_node("UI/VBoxContainer/FindLabel")
			arraylist_label = find_ui.get_node("UI/VBoxContainer/ArrayListLabel")
			new_tree_button = find_ui.get_node("UI/HBoxContainer/NewTreeButton")
			undo_button = find_ui.get_node("UI/HBoxContainer/UndoButton")
			exit_button = find_ui.get_node("UI/HBoxContainer/ExitButton")

			# ✅ Check nodes before connecting signals
			if exit_button:
				exit_button.pressed.connect(_on_exit_pressed)
			else:
				print("Error: ExitButton not found!")

			if new_tree_button:
				new_tree_button.pressed.connect(_on_new_tree_pressed)
			else:
				print("Error: NewTreeButton not found!")

			if undo_button:
				undo_button.pressed.connect(_on_undo_pressed)
			else:
				print("Error: UndoButton not found!")

			# ✅ Generate an initial tree when scene loads
			_generate_new_tree()
		else:
			print("Error: FindUI scene not found inside FindMenu!")
	else:
		print("Error: FindMenu not found in Find.tscn!")

func _on_exit_pressed():
	""" Exits Find mode and returns to the main scene. """
	get_tree().change_scene_to_file("res://scenes/binary_tree/XRTutorial/main.tscn")

func _on_new_tree_pressed():
	""" Generates a new random BST and updates the FindLabel. """
	_generate_new_tree()

func _on_undo_pressed():
	""" Removes the last selected node from the ARRAYLIST. """
	if arraylist.size() > 0:
		arraylist.pop_back()
		_update_arraylist_label()

func _generate_new_tree():
	""" Generates a new BST and displays it in 3D """
	bst_root = binary_tree.generate_random_bst()
	target_value = _pick_random_node(bst_root)  # Pick a random number from the BST

	if find_label:
		find_label.text = "FIND: " + str(target_value)  # Update FindLabel with target value

	arraylist.clear()
	_update_arraylist_label()

	# ✅ Clear previous tree before rendering a new one
	for child in tree_renderer.get_children():
		tree_renderer.remove_child(child)
		child.queue_free()

	# ✅ Render the new tree in 3D
	tree_renderer.render_tree(bst_root, tree_renderer)

func _pick_random_node(root):
	""" Picks a random node from the BST to be the target. """
	var nodes = _get_all_nodes(root)
	return nodes[randi() % nodes.size()] if nodes.size() > 0 else 0  # Avoid crash if tree is empty

func _get_all_nodes(root) -> Array:
	""" Retrieves all node values from the BST (in-order traversal). """
	if root == null:
		return []
	return _get_all_nodes(root.left) + [root.value] + _get_all_nodes(root.right)

func _update_arraylist_label():
	""" Updates the UI to show the selected path. """
	if arraylist_label:
		arraylist_label.text = "ARRAYLIST: " + ", ".join(arraylist)
