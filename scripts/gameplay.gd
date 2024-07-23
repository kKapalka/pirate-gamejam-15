extends Node

@onready var camera: Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	CursorHandler.camera = camera


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
