extends Node3D

@export var floating_thought_packed: PackedScene

func _ready() -> void:
	var thoughts = get_tree().get_nodes_in_group("thought")
	
	var radius := 2.5
	for i in thoughts.size():
		var thought = thoughts[i]
		var angle := TAU * float(i) / thoughts.size()
		var y := radius * sin(angle)
		var z := radius * cos(angle)
		
		var instance = floating_thought_packed.instantiate()
		instance.set_info(thought.info)
		instance.position = Vector3(0, y, z)
		$FloatingThoughts.add_child(instance)

	spin_thoughts(360.0)

func spin_thoughts(duration: float):
	var tween = create_tween()
	var initial_rot = $FloatingThoughts.rotation_degrees
	var target_rot = initial_rot + Vector3(360, 0, 0)
	tween.tween_property(
		$FloatingThoughts, "rotation_degrees", target_rot, duration
	).set_trans(Tween.TRANS_LINEAR)
	tween.finished.connect(func(): spin_thoughts(duration))  # loop forever
