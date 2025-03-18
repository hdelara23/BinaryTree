extends Node3D

var xr_interface: XRInterface

@onready var viewport: Node

func _ready():
	print("Main scene loaded!")

	xr_interface = XRServer.find_interface("OpenXR")
	
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully!")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")

	# Wait for one frame to ensure all nodes are properly loaded
	await get_tree().process_frame  

	# Get the Viewport2DIn3D node
	viewport = get_node_or_null("Viewport2DIn3D")  

	if viewport:
		var menu_scene = viewport.get_child(0)  # Get first child (BinaryTreeMenu.tscn)
		if menu_scene:
			menu_scene.find_pressed.connect(_on_find_pressed)  
		else:
			print("Error: BinaryTreeMenu scene not found inside Viewport2DIn3D!")
	else:
		print("Error: Viewport2DIn3D not found in Main.tscn!")

func _on_find_pressed():
	""" Handles Find button press to switch to Find.tscn """
	print("Find button pressed! Switching to Find game mode...")
	var find_scene = load("res://scenes/binary_tree/GameModes/Find.tscn").instantiate()
	get_tree().change_scene_to_packed(find_scene)
