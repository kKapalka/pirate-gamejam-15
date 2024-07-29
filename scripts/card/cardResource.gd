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
@export var consumable: bool = false
@export var discardStrength : float = 0.25:
	set(value):
		discardStrength = value
		modified = true
