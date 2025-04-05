extends Node3D

@export var cam_anchor: Node3D
@export var patience_bar: PatienceBar

@export var end_info: Node

var _current_stage := -1
var pillar_height = 6
var stage_count = 4

func _process(delta: float) -> void:
	# Move camera when we swap to a new stage
	var min_stage = get_current_min_stage()
	if _current_stage < min_stage:
		_current_stage = min_stage
		to_current_stage()

func get_current_stage() -> int:
	return _current_stage

func get_current_min_stage():
	# Cannot 'go back' when running out of time,
	# (but can 'go forward' if all balls are onto the next stage)
	return max(get_min_stage_from_patience(), get_min_stage_from_thoughts())

func get_min_stage_from_patience():
	var percent = patience_bar.value / patience_bar.max_value
	var index := int((1.0 - percent) * 3)
	return clamp(index, 0, stage_count - 1)

func get_min_stage_from_thoughts() -> int:
	# Each 'thought' starts in the first stage with it's y
	# < -pillar_height / 2. When all thoughts fall through to
	# the next stage, we need to move the camera to that stage.
	# (however, the cam does not move 'back up') if any 'thoughts
	# are left behind.
	# I.e.: find the highest thought, find which 'stage' interval it is in
	# then  set the minimum stage to that. If the current stage is less
	# than that minimum, move to the current stage
	var thoughts := $"thought spawner".get_children()
	if thoughts.is_empty():
		return 0

	var highest_y = thoughts.map(func(t): return t.global_position.y).max()
	var offset_from_top = (pillar_height / 2.0) - highest_y
	var stage = int(floor(offset_from_top / pillar_height))
	return clamp(stage, 0, stage_count)

func to_current_stage():
	_tween_cam_to_stage(_current_stage)
	# TODO anything else?
	if _current_stage >= 3:
		_on_finish()

func _tween_cam_to_stage(stage_index: int):
	if not cam_anchor:
		return

	var target_pos := cam_anchor.position
	target_pos.y = -stage_index * pillar_height

	var tween := create_tween()
	tween.tween_property(cam_anchor, "position", target_pos, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
var finished = false
func _on_finish():
	if finished: return
	finished = true
	
	# TODO play some kind of noise - sfxr?
	
	end_info.visible = true
	for c in end_info.get_children():
		c.visible = true
	
	# After it 'settles' - remove all pegs
	# - but don't count these new ones as released
	await get_tree().create_timer(1).timeout
	var finish_area = $"bowl/FinishArea" as Area3D
	finish_area.monitoring = false
	get_tree().call_group("question", "handle_disappear")

func _on_try_again() -> void:
	get_tree().reload_current_scene()
	
func _input(event: InputEvent) -> void:
	# Just debug - when user presses 0,
	# fire off 'handle_disappear' on all nodes in the 'question' groun
	if event is InputEventKey and event.pressed and event.keycode == KEY_0:
		get_tree().call_group("question", "handle_disappear")
