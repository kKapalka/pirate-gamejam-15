@tool
class_name EventCardResource extends Texture2D

var modified = false
@export var texture: Texture2D:
	set(value):
		texture = value
		modified = true
@export var title: String:
	set(value):
		title = value
		modified = true
@export_multiline var description: String:
	set(value):
		description = value
		modified = true
@export var options: Array[EventCardOption]:
	set(value):
		options = value
		modified = true
@export var id: String:
	set(value):
		id = value
		modified = true
@export var consumable: bool = false
		
