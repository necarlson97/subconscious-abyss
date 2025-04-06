extends CheckButton


func _ready() -> void:
	button_pressed = not Difficulty.freeze

func _on_toggled(toggled_on: bool) -> void:
	# If we are in a crisis, turn freeze off
	Difficulty.freeze = not toggled_on

func _on_mouse_entered() -> void:
	SignalBus.therapist_thought.emit("Her patience will be continually running out...")

func _on_mouse_exited() -> void:
	get_parent().set_score_text()
