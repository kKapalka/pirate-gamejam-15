@tool
class_name ResourceCard extends Texture2D

var modified = false
@export var texture: Texture2D:
	set(value):
		texture = value
		modified = true
@export var name: String:
	set(value):
		name = value
		modified = true
@export var id: String:
	set(value):
		id = value
		modified = true
@export var textColor: Color:
	set(value):
		textColor = value
		modified = true
		