extends Node
class_name GameplayNode

@onready var camera: Camera3D = $Camera3D
@onready var draggingBoundsArea: Area3D = $DraggingBoundsArea
@onready var cardDisappearTimer: Timer = $CardDisappearTimer

var dragging: bool = false
@onready var resourceCardPool: ResourceCardDeckNode = $ResourceCardPool
var resourceCards: Array[ResourceCardNode]

# Called when the node enters the scene tree for the first time.
func _ready():
	CursorHandler.camera = camera
	CursorHandler.draggingBoundsArea = draggingBoundsArea
	draggingBoundsArea.visible = false
	var children = resourceCardPool.get_children()
	for i in len(children):
		var child = children[i]
		resourceCards.append(child)
		child.gameplayNode = self
		child.front.sorting_offset = len(children) - i

func _on_dragging_bounds_area_input_event(_camera, event: InputEvent, position, normal, shape_idx):
	if CursorHandler.dragging and event is InputEventMouseMotion:
		CursorHandler.onDraggingMouseMotion(position)

func updateResourceCardPoolZIndices(_card: ResourceCardNode):
	resourceCardPool.move_child(_card, 0)	
	for i in len(resourceCardPool.get_children()):
		var card = (resourceCardPool.get_child(i) as ResourceCardNode)
		card.front.sorting_offset = len(resourceCards) - i


func _on_end_turn_button_button_up():
	cardDisappearTimer.start()
	for i in len(resourceCardPool.get_children()):
		var card = (resourceCardPool.get_child(i) as ResourceCardNode)
		card.disappear()


func _on_card_disappear_timer_timeout():
	resourceCardPool.discard()
	resourceCardPool.draw()
