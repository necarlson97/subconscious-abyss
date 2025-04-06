extends Node
class_name Dialogue

@export var listen_signal = "client thought"
# Nodes
@onready var text_label = $Label as Label

func _ready():
	text_label.text = " "
	SignalBus.connect(listen_signal, Callable(self, "_on_signal"))

func _process(delta):
	type_out()

func type_out():
	if text_label.visible_ratio < 1:
		text_label.visible_characters += 1
		_play_sound_for_letter()

func _on_signal(text: String):
	text_label.visible_ratio = 0
	text_label.text = text
	
# Handle audio
@export var speach_clips: Array[AudioStream]
@export var default_clip: AudioStream

var can_play = true
@export var pitch_start = 1.0
func _play_sound_for_letter():
	if not get_node_or_null("AudioStreamPlayer"): return
	if not can_play: return
	if text_label.text == "": return
	$AudioStreamPlayer.pitch_scale = pitch_start + randf_range(-0.1, 0.1)
	
	var last_character_idx = clamp(
		text_label.visible_characters-1, 0, text_label.text.length())
	var last_character = text_label.text[last_character_idx]
	
	$AudioStreamPlayer.stream = default_clip
	for clip in speach_clips:
		var clip_name = clip.resource_path.split('/')[-1].split('.')[0]
		if last_character in clip_name:
			$AudioStreamPlayer.stream = clip
			
	# TODO
	$"../Portrait".bounce()

	$AudioStreamPlayer.play()
	can_play = false
	await get_tree().create_timer(.1).timeout
	can_play = true
