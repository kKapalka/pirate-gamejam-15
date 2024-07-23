extends Node

@onready var camera: Camera3D = $Camera3D
@onready var draggingBoundsArea: Area3D = $DraggingBoundsArea

var dragging: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	CursorHandler.camera = camera
	CursorHandler.draggingBoundsArea = draggingBoundsArea
	draggingBoundsArea.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dragging_bounds_area_input_event(camera, event: InputEvent, position, normal, shape_idx):
	if CursorHandler.dragging and event is InputEventMouseMotion:
		CursorHandler.onDraggingMouseMotion(position)
