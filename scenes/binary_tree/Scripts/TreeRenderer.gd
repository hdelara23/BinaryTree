extends Node3D

var sphere_scene = preload("res://scenes/binary_tree/GameModes/SphereNode.tscn")

# Constants for positioning
const PLATFORM_Z = -11.0  # ✅ Keep all nodes on the same Z
const START_HEIGHT = 14.0  # Higher starting root node
const LEVEL_HEIGHT = 3.0  # Moves each child downward
const INITIAL_SPACING = 6.0  # Initial horizontal spacing

func render_tree(root, parent_node, depth=0, x_offset=0.0, spacing=INITIAL_SPACING) -> Node3D:
	""" Recursively generates and positions tree nodes in 3D """
	if root == null:
		return null  # No node to render

	# Calculate new position for the node (✅ Ensures downward placement)
	var y_position = START_HEIGHT - (depth * LEVEL_HEIGHT)  # Moves children downward each level
	var x_position = x_offset * (spacing / (pow(0.5, depth)))  # Keeps correct horizontal spacing

	# Create and position the node
	var sphere = sphere_scene.instantiate()
	sphere.position = Vector3(x_position, y_position, PLATFORM_Z)  # ✅ Lock initial Z

	# Debug: Pre-frame check
	print("[NODE CREATED] Value:", root.value, "| Position:", sphere.position)

	# Add node to parent
	parent_node.add_child(sphere)

	# Ensure SphereNode has set_label() function before calling
	if sphere.has_method("set_label"):
		sphere.set_label(str(root.value))
	else:
		print("⚠ Warning: set_label() method not found in SphereNode!")

	# ✅ Wait for the engine to fully process the node placement
	await get_tree().process_frame

	# ✅ Override global Z after placement (prevents misalignment)
	var global_pos = sphere.global_transform.origin
	sphere.global_transform.origin = Vector3(global_pos.x, y_position, PLATFORM_Z)

	# Debugging: Post-frame check
	print("[POST FRAME] Node:", root.value, "| Final Global Position:", sphere.global_transform.origin)

	# Reduce spacing for the next level and calculate new offsets
	var next_spacing = spacing / 2.0
	var left_offset = -next_spacing  # Left child moves left
	var right_offset = next_spacing  # Right child moves right

	# Render children
	var left_sphere = null
	if root.left:
		left_sphere = await render_tree(root.left, sphere, depth + 1, left_offset, next_spacing)
		if left_sphere:
			await get_tree().process_frame
			connect_nodes(sphere.global_transform.origin, left_sphere.global_transform.origin, parent_node)

	var right_sphere = null
	if root.right:
		right_sphere = await render_tree(root.right, sphere, depth + 1, right_offset, next_spacing)
		if right_sphere:
			await get_tree().process_frame
			connect_nodes(sphere.global_transform.origin, right_sphere.global_transform.origin, parent_node)

	return sphere  # Return node for connections

func connect_nodes(start_pos, end_pos, parent):
	""" Draws a line between two spheres to visualize the tree structure """
	var line = MeshInstance3D.new()
	var mesh = ImmediateMesh.new()

	# ✅ Use start_pos and end_pos directly (no to_global conversion)
	var global_start = Vector3(start_pos.x, start_pos.y, PLATFORM_Z)
	var global_end = Vector3(end_pos.x, end_pos.y, PLATFORM_Z)

	# 🔍 Debugging: Print connecting positions
	print("[CONNECT NODES] Drawing Line | Start:", global_start, "| End:", global_end)

	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_add_vertex(global_start)
	mesh.surface_add_vertex(global_end)
	mesh.surface_end()

	line.mesh = mesh

	# ✅ Attach to self instead of parent_node to avoid misalignment
	self.add_child(line)
