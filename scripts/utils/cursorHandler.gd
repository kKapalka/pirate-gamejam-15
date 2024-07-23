extends Node

#do we want to make our custom cursor? custom cursors are cool, and 
#if we want different cursors for different actions, this is the way to go
#@export var defaultCursor: Texture2D
@export var clickSound: AudioStream

var resourceCardsInArea: Array[ResourceCardNode] = []

var dragging: bool = false
var draggedCard: ResourceCardNode = null
var draggedCardOffset: Vector2 = Vector2.ZERO
var camera: Camera3D
var draggingBoundsArea: Area3D

func _ready():
	pass
	#if defaultCursor != null:
	#	Input.set_custom_mouse_cursor(defaultCursor)

#play click sound at event's position on mouse click
func _input(event):
	if Input.is_action_just_pressed("select"):
		if camera != null:
			if draggedCard == null:
				if len(resourceCardsInArea) > 0:
					draggingBoundsArea.visible = true
					resourceCardsInArea.sort_custom(func(a,b): return a.zindex - b.zindex )
					draggedCard = resourceCardsInArea[0]
					draggedCard.onPickUp(draggingBoundsArea.position.y)
					dragging = true
			else:
				draggingBoundsArea.visible = false
				draggedCard.onDrop()
				draggedCard = null
				dragging = false				

func onDraggingMouseMotion(position: Vector3):
	draggedCard.onDraggingMouseMotion(position)

