extends Node

#do we want to make our custom cursor? custom cursors are cool, and 
#if we want different cursors for different actions, this is the way to go
#@export var defaultCursor: Texture2D
@export var clickSound: AudioStream


func _ready():
	pass
	#if defaultCursor != null:
	#	Input.set_custom_mouse_cursor(defaultCursor)

#play click sound at event's position on mouse click
func _input(event):
	if Input.is_action_just_pressed("select"):
		AudioManager.playSFXAtMousePosition(clickSound)
