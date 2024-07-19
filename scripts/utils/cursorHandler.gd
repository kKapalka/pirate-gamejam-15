extends Node

@export var defaultCursor: Texture2D
@export var clickSound: AudioStream

func _ready():
	if defaultCursor != null:
		Input.set_custom_mouse_cursor(defaultCursor)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and !event.is_echo():
		AudioManager.playSFX(clickSound, event.global_position)
