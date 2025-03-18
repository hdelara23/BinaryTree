extends Node3D

var sphere_scene = preload("res://scenes/binary_tree/GameModes/SphereNode.tscn")

func render_tree(root, parent_node, depth=0, x_offset=0.0):
	""" Recursively generates and positions tree nodes in 3D """
	if root == null:
		return

	# Create a new sphere node
	var sphere = sphere_scene.instantiate()
	sphere.position = Vector3(x_offset, -depth * 2.0, 0)
	
	# Ensure SphereNode has a method to set the label
	if sphere.has_method("set_label"):
		sphere.set_label(str(root.value))  # Set number on node
	
	parent_node.add_child(sphere)

	# Recursively create left & right child nodes
	if root.left:
		var left_sphere = render_tree(root.left, sphere, depth + 1, x_offset - 2.0)
		connect_nodes(sphere.position, left_sphere.position, parent_node)

	if root.right:
		var right_sphere = render_tree(root.right, sphere, depth + 1, x_offset + 2.0)
		connect_nodes(sphere.position, right_sphere.position, parent_node)

	return sphere

func connect_nodes(start_pos, end_pos, parent):
	""" Draws a line between two spheres to visualize tree structure """
	var line = MeshInstance3D.new()
	var mesh = ImmediateMesh.new()
	
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_add_vertex(start_pos)
	mesh.surface_add_vertex(end_pos)
	mesh.surface_end()

	line.mesh = mesh
	parent.add_child(line)
