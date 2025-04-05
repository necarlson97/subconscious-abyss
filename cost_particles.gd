extends GPUParticles2D

func _ready():
	SignalBus.question_asked.connect(question_asked)

func question_asked(cost: int):
	restart()
