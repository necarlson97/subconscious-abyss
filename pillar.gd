extends Node3D

@export var question_scene: PackedScene
@export var num_questions := 10
@export_range(-5.0, 5.0) var y_offset_range := 0.5
@export_range(-1.0, 1.0) var xz_jitter_range := 0.5
@export_range(-10.0, 10.0) var tilt_degrees := 10.0

enum Strategies {PLANK, RANDOM}
@export var strategy: Strategies

@export_range(0, 10) var med_cost := 5
@export_range(0, 10) var high_cost := 3

func _ready():
	match strategy:
		Strategies.PLANK:
			add_plank_like()
		Strategies.RANDOM:
			add_randomly()
	
	_assign_question_costs()

func _assign_question_costs():
	var questions := get_children().filter(func(child): return child is Question)
	questions.shuffle()

	# Assign cost 2 to first N
	for q in questions.slice(0, med_cost):
		q.set_cost(2)

	# Assign cost 3 to next N
	for q in questions.slice(med_cost, med_cost + high_cost):
		q.set_cost(3)

func add_plank_like():	
	# Strategy for adding 'questions' that:
	# lays half of next to eachother x-aligned
	# lays the other half z-aligned
	# jitters each of them a bit on the y axis
	# tilts each of them a bit on the xz axes
	for i in num_questions:
		var instance = question_scene.instantiate()

		var y_offset = randf_range(-y_offset_range, y_offset_range)

		# Alternate between X and Z axis alignment
		var align_x_axis = i % 2 == 0
		var base_rotation = Basis() if align_x_axis else Basis(Vector3.UP, deg_to_rad(90))

		# Jitter rotation around Y (twist)
		var twist = 0 # deg_to_rad(randf_range(-tilt_degrees, tilt_degrees))
		var twist_rot = Basis(Vector3.UP, twist)

		# Apply small tilts on X and Z
		var tilt_x = deg_to_rad(randf_range(-tilt_degrees, tilt_degrees))
		var tilt_z = deg_to_rad(randf_range(-tilt_degrees, tilt_degrees))
		var tilt_basis = Basis().rotated(Vector3.RIGHT, tilt_x).rotated(Vector3.FORWARD, tilt_z)
		
		# Compose final transform
		var xz_offset = remap(i, 0, num_questions, -1, 1)
		xz_offset += randf_range(-xz_jitter_range, xz_jitter_range)
		
		var pos = Vector3(xz_offset, y_offset, 0)
		if !align_x_axis:
			pos = Vector3(0, y_offset, xz_offset)
		var rot = base_rotation * twist_rot * tilt_basis
		instance.transform = Transform3D(rot, pos)

		add_child(instance)

func add_randomly():
	# Strategy for adding 'questions' that is totall random
	for i in num_questions:
		var instance = question_scene.instantiate()

		# Randomize offsets
		var y_offset = randf_range(-y_offset_range, y_offset_range)
		var xz_offset = Vector3(randf_range(-xz_jitter_range, xz_jitter_range), 0,
								randf_range(-xz_jitter_range, xz_jitter_range))

		# Randomize rotation (Z rotation around the pillar's vertical axis)
		var tilt_x = deg_to_rad(randf_range(-tilt_degrees, tilt_degrees))
		var tilt_z = deg_to_rad(randf_range(-tilt_degrees, tilt_degrees))
		var rotate_y = deg_to_rad(randf_range(0, 360))

		instance.position = Vector3(xz_offset.x, y_offset, xz_offset.z)

		var basis = Basis()
		basis = basis.rotated(Vector3.RIGHT, tilt_x)
		basis = basis.rotated(Vector3.UP, rotate_y)
		basis = basis.rotated(Vector3.FORWARD, tilt_z)
		instance.transform = Transform3D(basis, instance.position)

		add_child(instance)
