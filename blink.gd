extends TextureRect

@export var closed_time = 0.13

func _ready() -> void:
	blink()

func blink():
	var open_time = randf_range(4.0, 6.0)
	
	visible = false
	await get_tree().create_timer(open_time).timeout
	visible = true
	await get_tree().create_timer(closed_time).timeout
	if randf() < 0.3:
		# woah - double blink!
		visible = false
		await get_tree().create_timer(closed_time).timeout
		visible = true
		await get_tree().create_timer(closed_time).timeout	
	blink()
