extends RigidBody3D

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collider: CollisionShape3D = $CollisionShape3D

class ThoughtInfo:
	var repressed = "I'm angry"
	var released = "I've been hurt"
	
	func _init(repressed: String, released: String) -> void:
		self.repressed = repressed
		self.released = released
	
var ThoughtInfos = [
	ThoughtInfo.new(
		"repressed 1",
		"released 1"
	),
	ThoughtInfo.new(
		"repressed 2",
		"released 2"
	),
	ThoughtInfo.new(
		"repressed 3",
		"released 3"
	),
]
var info: ThoughtInfo

var is_hovering: bool = false
# TODO what colors?
var hover_color := Color(1.0, 0.8, 0.2)  # Goldish glow

var original_color: Color

func _ready():
	# Duplicate material for local use
	var mat := mesh.get_active_material(0)
	if mat:
		var unique_mat = mat.duplicate()
		mesh.set_surface_override_material(0, unique_mat)
		if mat is ShaderMaterial:
			original_color = unique_mat.get_shader_parameter("Color")
		elif  mat is StandardMaterial3D:
			original_color = unique_mat.albedo_color
			
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# TODO is there a nice clean way to get my 'index' here?
	# E.g. counts up with each new thought node created
	info = ThoughtInfos[get_index() % ThoughtInfos.size()]

func get_my_stage():
	var pillar_height = 6
	var offset_from_top = (pillar_height / 2.0) - global_position.y
	return int(floor(offset_from_top / pillar_height))

func _on_mouse_entered():
	is_hovering = true
	var mat := mesh.get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("Color", hover_color)
	elif  mat is StandardMaterial3D:
		mat.albedo_color = hover_color
	SignalBus.client_thought.emit(info.repressed)

func _on_mouse_exited():
	is_hovering = false
	var mat := mesh.get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("Color", original_color)
	elif  mat is StandardMaterial3D:
		mat.albedo_color = original_color
