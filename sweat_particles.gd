extends GPUParticles2D

func _process(delta: float) -> void:
	emitting = not Difficulty.freeze
		
