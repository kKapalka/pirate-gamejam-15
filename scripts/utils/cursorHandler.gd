extends Node

#do we want to make our custom cursor? custom cursors are cool, and 
#if we want different cursors for different actions, this is the way to go
#@export var defaultCursor: Texture2D
@export var clickSound: AudioStream
@export var cardClickSound: AudioStream

var resourceCardsInArea: Array[ResourceCardNode] = []

var dragging: bool = false
var draggedCard: ResourceCardNode = null
var draggedCardOffset: Vector2 = Vector2.ZERO
var camera: Camera3D
var draggingBoundsArea: Area3D
var canInteractWithBoard = true
var cardSlots: Array[CardSlot]
var uiActive: bool = true

@onready var cursorLagTimer: Timer = $CursorLagTimer

func _ready():
	SaveHandler.loadGame()

#play click sound at event's position on mouse click
func _input(_event):
	if Input.is_action_just_pressed("select") and cursorLagTimer.is_stopped():
		if camera != null:
			if draggedCard == null:
				var card = detectCardByMouseRaycast()
				if card != null and canInteractWithBoard:
					cursorLagTimer.start()
					draggedCard = card
					draggingBoundsArea.visible = true
					canInteractWithBoard = false
				else:
					if !canInteractWithBoard:
						on2DClick()
			else:
				AudioManager.playSFX(cardClickSound, draggedCard.position)
				onDropTriggered()
		else:			
			on2DClick()

func on2DClick():
	cursorLagTimer.start()
	AudioManager.playSFXAtDefaultPosition(clickSound)
	
func on3DClick():
	var mouse = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse)
	var to = from + camera.project_ray_normal(mouse) * 100
	var cast = camera.get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to,
	0b00000000_00000000_00000000_00000111)
	)
	print(cast)
				
func onDropTriggered():
	draggingBoundsArea.visible = false
	draggedCard.onDrop(cardSlots)
	draggedCard = null
	dragging = false
	cursorLagTimer.start()
	canInteractWithBoard = true
	
func onDraggingMouseMotion(position: Vector3):
	if !dragging:
		AudioManager.playSFX(cardClickSound, position)
		draggedCard.onPickUp(position)
		dragging = true
	draggedCard.onDraggingMouseMotion(position)

func detectCardByMouseRaycast() -> ResourceCardNode:
	var mouse = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse)
	var to = from + camera.project_ray_normal(mouse) * 100
	var cast = camera.get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to,
	0b00000000_00000000_00000000_00000010)
	)
	if cast.has("position"):
		var shapeParams = PhysicsShapeQueryParameters3D.new()
		var shape = BoxShape3D.new()
		shape.size = Vector3(0.01,0.01,0.01)
		shapeParams.transform = Transform3D.IDENTITY
		shapeParams.transform.origin = cast.position
		shapeParams.shape = shape
		shapeParams.collision_mask = 0b00000000_00000000_00000000_00000010
		shapeParams.collide_with_bodies = true
		var intersectPoint = camera.get_world_3d().direct_space_state.intersect_shape(shapeParams)
		var cards = intersectPoint.map(func(x): return x.collider.get_parent() as ResourceCardNode)
		cards.sort_custom(func(a,b): return a.front.sorting_offset > b.front.sorting_offset)
		return cards.filter(func(x): return x.visible)[0]
	return null
