extends Node3D

@onready var label = $ValueLabel  # Ensure you have a Label3D node in SphereNode.tscn

func set_label(text: String):
	""" Sets the value label on the sphere """
	if label:
		label.text = text
	else:
		print("Error: ValueLabel node not found in SphereNode!")
