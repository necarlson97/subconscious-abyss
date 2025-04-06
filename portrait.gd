extends TextureRect

var original_pos: Vector2

func bounce():
	if original_pos == Vector2.ZERO:
		original_pos = position
		
	var tween = create_tween()
	tween.tween_property(
		self, "position", original_pos + Vector2(0, -10), 0.1
	).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self, "position", original_pos, 0.1
	).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
