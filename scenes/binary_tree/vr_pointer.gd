extends RayCast3D

# Called every frame
func _process(delta):
	if is_colliding():
		var target = get_collider()
		if target is Button and Input.is_action_just_pressed("ui_accept"):
			target.emit_signal("pressed")  # Simulates button press
