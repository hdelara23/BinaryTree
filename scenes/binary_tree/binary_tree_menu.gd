extends Control


func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://scenes/binary_tree/GameModes/Tutorial.tscn")


func _on_insert_pressed():
	get_tree().change_scene_to_file("res://scenes/binary_tree/GameModes/Insert.tscn")


func _on_find_pressed():
	get_tree().change_scene_to_file("res://scenes/binary_tree/GameModes/Find.tscn")


func _on_delete_pressed():
	get_tree().change_scene_to_file("res://scenes/binary_tree/GameModes/Delete.tscn")


func _on_playground_pressed():
	get_tree().change_scene_to_file("res://scenes/binary_tree/GameModes/Playground.tscn")
