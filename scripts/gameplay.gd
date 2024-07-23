extends Node
class_name GameplayNode

@onready var camera: Camera3D = $Camera3D
@onready var draggingBoundsArea: Area3D = $DraggingBoundsArea

var dragging: bool = false
@onready var resourceCardPool: Node = $ResourceCardPool
var resourceCards: Array[ResourceCardNode]


# Called when the node enters the scene tree for the first time.
func _ready():
	CursorHandler.camera = camera
	CursorHandler.draggingBoundsArea = draggingBoundsArea
	draggingBoundsArea.visible = false
	for child in resourceCardPool.get_children():
		resourceCards.append(child)
		child.gameplayNode = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dragging_bounds_area_input_event(camera, event: InputEvent, position, normal, shape_idx):
	if CursorHandler.dragging and event is InputEventMouseMotion:
		CursorHandler.onDraggingMouseMotion(position)

func updateResourceCardPoolZIndices(_card: ResourceCardNode):
	resourceCardPool.move_child(_card, 0)
	
	for i in len(resourceCardPool.get_children()):
		var card = (resourceCardPool.get_child(i) as ResourceCardNode)
		card.front.sorting_offset = len(resourceCards) - i
	_card.front.sorting_offset = len(resourceCards)
