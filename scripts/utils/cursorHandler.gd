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
				var card = detectCardByMouseRaycast()
				if card != null:
					draggingBoundsArea.visible = true
					draggedCard = card
					draggedCard.onPickUp(draggingBoundsArea.position.y)
					dragging = true
			else:
				draggingBoundsArea.visible = false
				draggedCard.onDrop()
				draggedCard = null
				dragging = false				

func onDraggingMouseMotion(position: Vector3):
	draggedCard.onDraggingMouseMotion(position)

func detectCardByMouseRaycast() -> ResourceCardNode:
	var mouse = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse)
	var raycast = (camera.get_child(0) as RayCast3D)
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
		return cards[0]
	return null
