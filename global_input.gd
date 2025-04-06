extends Node

func _input(event: InputEvent) -> void:
	# TODO you do 'loose progress' in this case
	# - perhaps we should have a seperate overlay?
	# just for music volume...
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://menu.tscn")
