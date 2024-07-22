extends Node

class_name ResourceCardNode

@onready var sprite: Sprite3D = $RigidBody3D/Sprite3D

var zIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func onPickUp():
	set_physics_process(false)

func onDrop():
	# make this card's Z-index the new maximum
	# and drop the Z-index of all the other cards present on the board by 1
	set_physics_process(true)
	
func _on_table_detection_area_area_entered(area):
	#if table detected, get glued to the table
	#if slot detected, fall into the slot
	pass # Replace with function body.

func _on_rigid_body_3d_mouse_entered():
	print("mouse enter")
	CursorHandler.resourceCardsInArea.append(self)

func _on_rigid_body_3d_mouse_exited():
	CursorHandler.resourceCardsInArea.remove_at(CursorHandler.resourceCardsInArea.find(self))
