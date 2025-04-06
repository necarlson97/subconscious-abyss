extends Node3D

# Passes signals from 'thoughts'
# (created dynamically at runtime)
# and can be subscribed by the dialogue
signal client_thought(text: String)
signal client_speak(text: String)
signal therapist_thought(text: String)
signal therapist_speak(text: String)

signal preview_cost(cost: int)
signal question_asked(cost: int)

signal thought_released(info)
signal finished()
