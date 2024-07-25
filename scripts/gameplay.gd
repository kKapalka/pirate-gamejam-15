extends Node
class_name GameplayNode

@onready var camera: Camera3D = $Camera3D
@onready var draggingBoundsArea: Area3D = $DraggingBoundsArea
@onready var cardDisappearTimer: Timer = $CardDisappearTimer

var dragging: bool = false
@onready var resourceCardPool: ResourceCardDeckNode = $ResourceCardPool
@onready var endTurnButton: Button = $Control/EndTurnButton
@onready var spawnCardButton: Button = $Control/SpawnRandomCard

# Called when the node enters the scene tree for the first time.
func _ready():
	CursorHandler.camera = camera
	CursorHandler.draggingBoundsArea = draggingBoundsArea
	draggingBoundsArea.visible = false

func _on_dragging_bounds_area_input_event(_camera, event: InputEvent, position, normal, shape_idx):
	if CursorHandler.dragging and event is InputEventMouseMotion:
		CursorHandler.onDraggingMouseMotion(position)

func _on_end_turn_button_button_up():
	var card = resourceCardPool.getRandomCard()
	if card != null:
		cardDisappearTimer.start()
		resourceCardPool.markAsHidden(card.get_instance_id())
		card.disappear()
		endTurnButton.disabled = true
		spawnCardButton.disabled = true

func _on_card_disappear_timer_timeout():
	endTurnButton.disabled = false
	spawnCardButton.disabled = false

func _on_spawn_random_card_button_up():
	resourceCardPool.spawnRandomCard()
