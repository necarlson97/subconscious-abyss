extends RigidBody3D
class_name Thought

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
		"I've just been hurt so much in the past.",
		"My expectation of pain has become a self-fufilling oroboros."
	),
	ThoughtInfo.new(
		"I feel so ugly in this ugly world.",
		"I not only inherited negative judgements of myself - but also the need to judge."
	),
	ThoughtInfo.new(
		"The loneliness is crippling.",
		"Some isolation is needed - to find myself, to heal."
	),
	ThoughtInfo.new(
		"I’m never going to be enough.",
		"I’ve been chasing someone else’s idea of 'enough'. Time to find my own."
	),
	ThoughtInfo.new(
		"I can’t stop comparing myself to others.",
		"It's just noise. Now I know that, and I can start to tune it out."
	),
	ThoughtInfo.new(
		"I'm so tired of pretending everything's okay.",
		"There are times for performance - but even more for real connection."
	),
	ThoughtInfo.new(
		"I’m too much for people.",
		"I'm afraid of my own intensity - it may not really be external at all."
	),
	ThoughtInfo.new(
		"I'm a burden.",
		"That belief was planted in me before I could speak — but I don't have to water it."
	),
	ThoughtInfo.new(
		"I can’t trust anyone.",
		"That was a survival lesson — but now I’m living, not just surviving."
	),
	ThoughtInfo.new(
		"I ruin everything good.",
		"I've run a successful self-sabotage campaign - but only because I believed I was unworthy."
	),
	ThoughtInfo.new(
		"I'm always alone when I need someone most.",
		"There is saftey in isolation - but even greater security in the right crowd."
	),
	ThoughtInfo.new(
		"My body is disgusting.",
		"Whose voice told me that - and what lead me to believing it?"
	),
	ThoughtInfo.new(
		"Nothing I do really matters.",
		"Maybe I've confused significance with spectacle."
	),
	ThoughtInfo.new(
		"I shouldn't be this angry.",
		"My anger cannot control every action - but it signals what matters deepest."
	),
	ThoughtInfo.new(
		"I can't let anyone see the real me.",
		"I can find reflections of myself even in the masks I make for others."
	),
	ThoughtInfo.new(
		"I'm weak for feeling this way.",
		"Feeling deeply is not weakness — it’s human."
	),
	ThoughtInfo.new(
		"I'm not enough to earn anyone's love.",
		"Love that must be earned was never truly love."
	),
	ThoughtInfo.new(
		"I'm always behind everyone else.",
		"There is no race. Only a rhythm."
	),
	ThoughtInfo.new(
		"I’ve wasted so much time.",
		"What if I was gathering what I needed all along?"
	),
	ThoughtInfo.new(
		"I don’t know who I am anymore.",
		"That uncertainty might be the soil where my true self is growing."
	),
	ThoughtInfo.new(
		"Everything feels meaningless.",
		"Perhaps meaning is never found — only made."
	),
	ThoughtInfo.new(
		"I don't deserve forgiveness.",
		"Even if I can’t forgive myself yet — I can stop punishing myself."
	),
	ThoughtInfo.new(
		"I have to stay in control or everything falls apart.",
		"Control helped me survive chaos — but now I can release my grip."
	),
	ThoughtInfo.new(
		"I always disappoint people.",
		"These are not my expectations - do they still serve me?"
	),
	ThoughtInfo.new(
		"I'm too sensitive.",
		"My sensitivity isn’t a flaw — it’s an antenna tuned to the unseen."
	),
	ThoughtInfo.new(
		"No one would notice if I disappeared.",
		"I may not be seen clearly — but that doesn't mean I'm invisible."
	),
	ThoughtInfo.new(
		"I'm addicted to this pain.",
		"Just because something is familiar does not make it healthy - nor forever."
	),
	ThoughtInfo.new(
		"I don’t deserve rest.",
		"Everyone deserves rest."
	),
	ThoughtInfo.new(
		"I should be stronger than this.",
		"Strength might look different than I was taught."
	),
	ThoughtInfo.new(
		"I always need to fix myself.",
		"Maybe there’s nothing to fix — just parts that need room to shift, writhe, and grow."
	),
	ThoughtInfo.new(
		"I’m afraid I’ll always feel this way.",
		"Feelings are like weather — even the darkest storm passes eventually."
	),
	ThoughtInfo.new(
		"I can’t change — it’s too late.",
		"Change doesn’t ask how old I am — only if I’m ready."
	),
	ThoughtInfo.new(
		"I’m ashamed of who I am.",
		"Shame is not identity — it’s just a shadow that is pretending to superceede the self."
	),
	ThoughtInfo.new(
		"I don't belong anywhere.",
		"Belonging isn’t found — it’s built, piece by piece."
	),
	ThoughtInfo.new(
		"I always say the wrong thing.",
		"Maybe silence was once safer — but now I’m learning to speak."
	),
	ThoughtInfo.new(
		"I can’t escape my past.",
		"My past shaped me — but it doesn’t have to steer me."
	),
	ThoughtInfo.new(
		"People only like the version of me I create for them.",
		"Only because I’ve mistaken approval for love."
	),
	ThoughtInfo.new(
		"I'm afraid there's something fundamentally wrong with me.",
		"I wear my fear like a scar — proof of nothing but my resiliance."
	)
]
var info: ThoughtInfo

var is_hovering: bool = false

var hover_color := Color.html("f7cb3b")
var released_color := Color.html("ffffff")

var original_color: Color

func _ready():
	# Duplicate material for local use
	var mat := mesh.get_active_material(0)
	if mat:
		var unique_mat = mat.duplicate()
		mesh.set_surface_override_material(0, unique_mat)
		
		if mat is ShaderMaterial:
			original_color = unique_mat.get_shader_parameter("Color")
			original_color = shift_color(original_color)
			unique_mat.set_shader_parameter("Color", original_color)
			
		elif  mat is StandardMaterial3D:
			original_color = shift_color(unique_mat.albedo_color)
			unique_mat.albedo_color = original_color
			
	#hover_color = shift_color(hover_color)
	#released_color = shift_color(released_color)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# TODO is there a nice clean way to get my 'index' here?
	# E.g. counts up with each new thought node created
	info = ThoughtInfos[get_index() % ThoughtInfos.size()]

func shift_color(c: Color) -> Color:
	var hue_shift = fmod(get_index() / 200.0, 1.0)
	return Color.from_hsv(c.h + hue_shift, c.s, c.v)
	
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
	if released:
		SignalBus.client_speak.emit(info.released)
	else:
		SignalBus.client_speak.emit("")

func _on_mouse_exited():
	is_hovering = false
	var mat := mesh.get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("Color", original_color)
	elif  mat is StandardMaterial3D:
		mat.albedo_color = original_color
		
var released = false
func release():
	released = true
	SignalBus.thought_released.emit(info)
	$ReleaseSFX.play()
	
	var mat := mesh.get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("posMult", 0.03)
		mat.set_shader_parameter("speed", 0.1)
		mat.set_shader_parameter("glow_color", released_color)
	elif  mat is StandardMaterial3D:
		mat.albedo_color = released_color
		original_color = released_color
