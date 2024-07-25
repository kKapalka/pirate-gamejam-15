class_name ResourceRecipe extends Node

var modified = false
@export var id: String:
	set(value):
		id = value
		modified = true
@export var ingredientsId: Array[String]:
	set(value):
		ingredientsId = value
		modified = true
@export var resultId: String:
	set(value):
		resultId = value
		modified = true
@export var resultCount: int:
	set(value):
		resultCount = value
		modified = true
