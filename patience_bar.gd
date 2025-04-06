extends ProgressBar
class_name PatienceBar

signal patience_empty

@export_range(1, 60, 1) var duration_minutes := 4.5
@export var stage_colors: Array[Color] = [
	Color.html("929fd3"), Color.html("90548c"), Color.html("4e386d")
]
@onready var cost_preview = $FollowParticles/CostPreview

var _duration := 0.0
var _patience_empty_fired := false

var freeze = true
func _ready():
	_duration = duration_minutes * 60.0
	max_value = _duration
	value = _duration
	
	SignalBus.question_asked.connect(question_asked)
	SignalBus.preview_cost.connect(preview_cost)
	SignalBus.finished.connect(on_finish)
	
	freeze = Difficulty.freeze

func _process(delta):
	if _patience_empty_fired:
		return
	
	if value <= 0 and not _patience_empty_fired:
		_patience_empty_fired = true
		emit_signal("patience_empty")

	
	if freeze:
		$FollowParticles.emitting = false
	else:
		value -= delta

	_update_color()
	_update_particles()
	
func _update_color():
	var index = get_node("/root/main").get_current_stage()
	index = clamp(index, 0, 2)
	var color := stage_colors[index]

	var fill_stylebox := StyleBoxFlat.new()
	fill_stylebox.bg_color = color
	add_theme_stylebox_override("fill", fill_stylebox)
	$FollowParticles.modulate = color
	
func _update_particles():
	if not $FollowParticles:
		return

	# Get fill ratio
	var ratio := value / max_value

	# Calculate bar height in pixels
	var bar_height := size.y  # If vertically filling
	var y_pos = lerp(0.0, bar_height, 1.0 - ratio)

	# Move particle node along the bar height
	$FollowParticles.position.y = y_pos

func get_value_cost(cost: int):
	# How many seconds to subtract per 'cost'
	# - we square cost, to make penalty more obvious
	var seconds_cost = 3.0
	return (cost * cost) * seconds_cost

func question_asked(cost: int):
	value -= get_value_cost(cost)
	value = max(value, 0)
	$FollowParticles/CostParticles.modulate = get_cost_color(cost)

func get_cost_color(cost: int):
	# TODO gross but for now I'm just duplicating cost
	# colors here cuz array const replacements are fussy
	var colors =[
		"80ffdb",
		"5e60ce",
		"d10f53"
	]
	return Color.html(colors[cost-1])
	
func preview_cost(cost: int):
	cost_preview.size.y = (get_value_cost(cost) / 300.0) * size.y
	cost_preview.color = get_cost_color(cost)
	
func on_finish():
	freeze = true
