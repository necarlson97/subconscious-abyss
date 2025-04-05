extends ProgressBar
class_name PatienceBar

signal patience_empty

@export_range(1, 60, 1) var duration_minutes := 5
@export var stage_colors: Array[Color] = [Color.html("929fd3"), Color.html("90548c"), Color.html("4e386d")]

var _duration := 0.0
var _patience_empty_fired := false


func _ready():
	_duration = duration_minutes * 60.0
	max_value = _duration
	value = _duration
	
	SignalBus.question_asked.connect(question_asked)

func _process(delta):
	if _patience_empty_fired:
		return

	value -= delta
	_update_color()
	_update_particles()

	if value <= 0 and not _patience_empty_fired:
		_patience_empty_fired = true
		emit_signal("patience_empty")
	
func _update_color():
	var index = get_node("/root/main").get_current_stage()
	index = clamp(index, 0, 2)
	var color := stage_colors[index]

	var fill_stylebox := StyleBoxFlat.new()
	fill_stylebox.bg_color = color
	add_theme_stylebox_override("fill", fill_stylebox)
	
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

func question_asked(cost: int):
	# How many seconds to subtract per 'cost'
	# - we square cost, to make penalty more obvious
	var seconds_cost = 3.0
	value -= (cost * cost) * seconds_cost
	value = max(value, 0)	
