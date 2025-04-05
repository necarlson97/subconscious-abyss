extends Node3D

@export var thought_scene: PackedScene
@export var num_thoughts := 40

func _ready():
	for i in num_thoughts:
		var instance = thought_scene.instantiate()

		# Randomize offsets
		var y_offset = i * 0.5
		var offset = Vector3(
			randf_range(-1, 1),
			y_offset,
			randf_range(-1, 1)
		)

		instance.position = position + offset
		add_child(instance)
