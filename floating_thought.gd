extends Node3D
@onready var camera: Camera3D = get_viewport().get_camera_3d()
var info = null

var hover_color := Color.html("f7cb3b")

func _ready() -> void:
	SignalBus.thought_released.connect(on_release)
	SignalBus.client_thought.connect(on_thought)
	
	global_rotation = Vector3.UP

func set_info(new_info):
	info = new_info
	$Released.text = info.released
	$Repressed.text = info.repressed
	$Released.visible = false
	
func on_release(rel_info):
	if rel_info != info:
		return
	$Released.visible = true
	
func _process(_delta):
	rot_to_camera()

func rot_to_camera():
	if not camera:
		return
	var target_basis = Transform3D().looking_at(global_position - camera.global_position, Vector3.UP).basis
	global_basis = global_basis.slerp(target_basis, 0.2)
	global_rotation.x = 0
	global_rotation.z = 0

var origional_color: Color
func on_thought(text: String):
	if origional_color == Color.BLACK:
		origional_color = $Repressed.modulate
	if text != $Repressed.text:
		$Repressed.modulate = origional_color
		return
	$Repressed.modulate = hover_color
