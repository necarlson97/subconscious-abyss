extends Camera3D

func _ready() -> void:
	get_tree().create_tween().tween_property(
		self, "position", Vector3(0, 0, 2), 1
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
