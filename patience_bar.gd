extends ProgressBar
class_name PatienceBar

signal patience_empty

@export_range(1, 60, 1) var duration_minutes := 5
@export var stage_colors: Array[Color] = [Color.html("929fd3"), Color.html("90548c"), Color.html("4e386d")]

var _elapsed := 0.0
var _duration := 0.0
var _tween: Tween

func _ready():
	_duration = duration_minutes * 60.0
	max_value = _duration
	value = _duration
	_tween = create_tween()
	_start_drain()

func _start_drain():
	_tween.tween_property(self, "value", 0.0, _duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	_tween.connect("finished", _on_drain_finished)

func _process(_delta):
	_update_color()
	
func _update_color():
	var index = get_node("/root/main").get_current_stage()
	index = clamp(index, 0, 2)
	var color := stage_colors[index]

	var fill_stylebox := StyleBoxFlat.new()
	fill_stylebox.bg_color = color
	add_theme_stylebox_override("fill", fill_stylebox)

func _on_drain_finished():
	emit_signal("patience_empty")
