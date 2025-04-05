extends Node3D
class_name Question

@onready var body: StaticBody3D = $StaticBody3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collider: CollisionShape3D = $StaticBody3D/CollisionShape3D
@onready var particles: GPUParticles3D = $GPUParticles3D

var clicked: bool = false
var is_hovering: bool = false
# TODO what colors?
var hover_color := Color(1.0, 0.8, 0.2)  # Goldish glow
var flash_color := Color(1.0, 1.0, 0.2)

var cost = 1

var original_color: Color

var QuestionLevels =  [
	[
		"Do you find yourself rumanating on this often?",
		"When you wake from this dream - what emotion fills you?",
		"When you imagine your ideal day, what’s the very first thing that happens?",
		"Do you feel more drawn to the past, the present, or the future?",
		"If your life had a recurring theme, what do you think it would be?",
		"Is there a version of yourself you miss—or perhaps one you’re growing toward?",
		"What do you think your habits say about how you view the world?",
		"When you picture success, what emotions arise?",
		"Do you feel more energized by solitude or connection?",
		"What role does spontaneity play in your life?",
		"Is there a part of your personality you’ve edited for others?",
		"When you feel most like yourself, what are you usually doing?",
		"Are your dreams more surreal or grounded?",
		"Do you often imagine how others see you?",
		"What does freedom look like in your mind?",
		"Do you notice patterns in what you avoid?",
		"Is there a place or time in your life that feels mythic to you?",
		"When you set goals, do they tend to be for yourself or for others?",
		"What emotion do you trust the most?",
		"Do you often revisit the same dream or type of dream?",
		"If your emotions had colors, which one dominates lately?",
		"What does your inner voice sound like when it’s kind?",
		"What’s a personality trait you once disliked, but now appreciate?",
		"How do you know when you’re telling yourself the truth?",
		"Are you more guided by curiosity or caution?",
		"Is there a part of you that feels ancient?",
		"How do you respond to silence?",
		"When you imagine a future version of yourself, what do they forgive you for?",
		"Do you tend to feel more like a participant in your life, or an observer?",
		"What kind of endings do you most often imagine?",
		"When do you feel the most grounded?",
		"What stories do you find yourself returning to again and again?",
		"How do you usually make difficult decisions—gut, logic, or something else?",
		"What parts of your personality feel inherited?",
		"Do your goals excite you or exhaust you?",
		"If your emotions had their own ecosystem, what would thrive there?",
		"What do you find beautiful, even when it hurts?",
		"Are there parts of yourself you only express in dreams?",
		"When you imagine changing, what stays the same?",
		"What do you think your laughter reveals about you?",
		"Do you feel more like a collection of traits or a single story?",
		"When do you feel the most authentic, without effort?"
	], [
		"What part of your childhood do you think shaped you the most?",
		"When did you first learn to hide part of yourself?",
		"How did your caregivers show love—and how did they withhold it?",
		"What did you need as a child that you didn’t receive?",
		"Which emotions were safe to express in your home growing up?",
		"What roles did you take on in your family, and are you still playing them?",
		"Who taught you how to treat yourself?",
		"When did you first realize adults are flawed?",
		"How do you carry your pain without letting it define you?",
		"Is there a version of yourself you're trying to protect?",
		"What patterns in your relationships keep repeating?",
		"What stories about yourself do you tell most often—and why those?",
		"What would it mean to truly forgive yourself?",
		"What’s something you’ve never said out loud, but wish someone would ask about?",
		"When do you feel like you're performing rather than being?",
		"What does 'home' mean to you now?",
		"Do you ever feel like you're chasing a life someone else imagined for you?",
		"Which part of your past do you still argue with in your mind?",
		"What part of yourself have you exiled to survive?",
		"If your younger self met you now, what would they be most afraid of?"
	], [
		"What would be left of you if everything you loved was taken away?",
		"Who are you when no one is watching—not even you?",
		"What do you fear would happen if you truly let go?",
		"Do you feel you are living—or simply preserving yourself?",
		"What is the secret hope that your suffering protects?",
		"What part of your identity would you surrender to be free?",
		"When you dream of dying, what part dies, and what awakens, reborn?",
		"What have you mistaken for love?",
		"If you stripped away this story you've told about yourself, what remains?",
		"What are you clinging to that is already gone?",
		"Do you think your pain has a purpose? Are you able to give it one?",
		"What lies have you inherited as truth?",
		"Which of you walls must be torn down? And which can -or must- remain unbroken?",
		"What are you pretending not to know?",
		"Are you ready to become someone you’ve never been?"
	],
]
var question_text = "I should ask..."

var Responses = [
	"That's a good question...",
	"I'll have to think about that...",
	"I’ve never really considered it before.",
	"Hmm… no one’s ever asked me that.",
	"Honestly? I don’t know.",
	"It’s complicated.",
	"I guess it depends on the day.",
	"Part of me wants to say yes, but...",
	"That makes me feel... something. I’m not sure what.",
	"There’s a lot there.",
	"I’m not sure I have the words for it.",
	"It’s not easy to explain.",
	"Can we come back to that?",
	"I think I know what you’re getting at.",
	"You might be onto something.",
	"I feel seen. And a little exposed.",
	"It’s hard to put into words.",
	"I’ve avoided thinking about that.",
	"You really want me to answer that?",
	"That touched a nerve.",
	"I’m not proud of the answer.",
	"Well... that depends who you ask.",
	"There’s a story there.",
	"I wish I had a simple answer.",
	"Do you always go this deep?",
	"That hit me harder than I expected.",
	"Can I be honest?",
	"That question kind of scares me.",
	"I’ve been asking myself that too.",
	"I think I’ve been avoiding this.",
	"Now you’ve got me spiraling.",
	"I feel like I should know, but I don’t.",
	"That brings up some old stuff.",
	"You’re not going to let me dodge this, are you?",
	"That’s… unsettlingly accurate.",
	"I need a minute with that one.",
	"Wow. Okay.",
	"That’s the kind of question that keeps me up at night.",
	"It’s funny you ask—I was just thinking about that.",
	"Do other people cry at this part?",
]

var response_text = "Hrm..."

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Duplicate material for local use
	var mat := mesh.get_active_material(0)
	if mat:
		var unique_mat = mat.duplicate()
		mesh.set_surface_override_material(0, unique_mat)
		if mat is ShaderMaterial:
			original_color = unique_mat.get_shader_parameter("Color")
		elif  mat is StandardMaterial3D:
			original_color = unique_mat.albedo_color
			
	body.mouse_entered.connect(_on_mouse_entered)
	body.mouse_exited.connect(_on_mouse_exited)

func set_cost(set_cost=1):
	cost = set_cost
	var questions_for_level = QuestionLevels[cost-1]
	question_text = questions_for_level[get_index() % questions_for_level.size()]
	response_text = Responses[get_index() % Responses.size()]
	
	# Change the color to match cost
	var colors =[
		"80ffdb",
		"48bfe3",
		"5e60ce",
	]
	original_color = Color.html(colors[cost-1])
	
	var mat = mesh.get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("Color", original_color)
	elif  mat is StandardMaterial3D:
		mat.albedo_color = original_color

func get_my_stage():
	var pillar_height = 6
	var offset_from_top = (pillar_height / 2.0) - global_position.y
	return int(floor(offset_from_top / pillar_height))

func _on_mouse_entered():
	if clicked:
		return
	if get_my_stage() != get_node("/root/main").get_current_stage():
		return
	
	is_hovering = true
	var mat := mesh.get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("Color", hover_color)
	elif  mat is StandardMaterial3D:
		mat.albedo_color = hover_color
	SignalBus.therapist_thought.emit(question_text)
	
func _on_mouse_exited():
	if clicked:
		return
	is_hovering = false
	var mat := mesh.get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("Color", original_color)
	elif  mat is StandardMaterial3D:
		mat.albedo_color = original_color

func _input(event):
	if clicked or !is_hovering:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked = true
		handle_disappear()
		SignalBus.therapist_speak.emit(question_text)
		SignalBus.question_asked.emit(cost)
		
		await get_tree().create_timer(1.0).timeout
		SignalBus.client_speak.emit(response_text)

func handle_disappear():
	flash_material()
	await get_tree().create_timer(0.2).timeout
	collider.disabled = true
	particles.restart()
	particles.emitting = true
	await get_tree().create_timer(particles.lifetime * 2).timeout
	queue_free()

func flash_material():
	var mat := mesh.get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("Color", flash_color)
	elif  mat is StandardMaterial3D:
		mat.albedo_color = flash_color
	await get_tree().create_timer(0.1).timeout
	
func _process(delta: float) -> void:
	if particles.emitting:
		mesh.get_active_material(0).albedo_color.a -= 2.0 * delta
