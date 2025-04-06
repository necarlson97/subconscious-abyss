extends HSlider

func _ready() -> void:
	value = 50
	
func _value_changed(new_value: float) -> void:
	MusicPlayer.volume_db = remap(new_value, 0, 100, -16, 0)
