extends Node

#do we want to make our custom cursor? custom cursors are cool, and 
#if we want different cursors for different actions, this is the way to go
#@export var defaultCursor: Texture2D
@export var clickSound: AudioStream

var resourceCardsInArea: Array[ResourceCardNode] = []

var draggedCard: ResourceCardNode = null
var draggedCardOffset: Vector2 = Vector2.ZERO
var camera: Camera3D

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
					resourceCardsInArea.sort_custom(func(a,b): return a.zindex - b.zindex )
					draggedCard = resourceCardsInArea[0]
					draggedCard.onPickUp()
			else:
				draggedCard.onDrop()
				draggedCard = null
		test()
	elif camera != null and event is InputEventMouseMotion and draggedCard != null:
		var mouse = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse)
		var to = from + camera.project_ray_normal(mouse) * 100
		var cast = camera.get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
		if cast != null:
			print(cast)
			draggedCard.position = cast.position
			
func test():
	var mouse = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse)
	var to = from + camera.project_ray_normal(mouse) * 100
	var cast = camera.get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
	print(cast)

