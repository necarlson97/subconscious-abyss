extends VBoxContainer

@export var release_log: Label
@onready var score = $Score

func _ready() -> void:
	release_log.text = " "
	SignalBus.thought_released.connect(_on_release)

func _on_release(info):
	release_log.text = "%s\n"%info.released + release_log.text
	set_score_text()

func set_score_text():
	var thoughts = get_tree().get_nodes_in_group("thought")
	var released = thoughts.filter(func(t): return t.released).size()
	var repressed = thoughts.size() - released
	score.text = "%s thoughts released from the depths!"%released
	score.text += "\n%s ruminations still repressed..."%repressed
