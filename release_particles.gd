extends Node2D

@export var release_particle: PackedScene
func _ready() -> void:
	SignalBus.thought_released.connect(create_particle)

func create_particle(_info):
	var pop = release_particle.instantiate()
	add_child(pop)
