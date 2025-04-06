extends VBoxContainer

@export var release_log: Label
@onready var score = $Score

func _ready() -> void:
	release_log.text = " "
	SignalBus.thought_released.connect(_on_release)
	SignalBus.finished.connect(set_score_text)

func _on_release(info):
	release_log.text = "%s\n"%info.released + release_log.text

func set_score_text():
	var thoughts = get_tree().get_nodes_in_group("thought")
	var released = thoughts.filter(func(t): return t.released).size()
	var repressed = thoughts.size() - released
	var s = "%s thoughts released!"%released
	s += "\n%s ruminations repressed..."%repressed
	SignalBus.therapist_thought.emit(s)
	
	var consolations = [
		"I'm sorry I wan't more help...",
		"Hopefully you are feeling a bit better.",
		"Anything else I can do to assist?",
		"I'm glad I was able to help!",
	]
	var c_idx = remap(released,
		0, thoughts.size(),
		0, consolations.size()-1
	) as int
	var c = consolations[c_idx]
	SignalBus.therapist_speak.emit(c)
