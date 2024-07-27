extends Node
class_name GameplayNode

@onready var camera: Camera3D = $Camera3D
@onready var draggingBoundsArea: Area3D = $DraggingBoundsArea
@onready var draggingPolygon: CollisionPolygon3D = $DraggingPolygon
@onready var cardDisappearTimer: Timer = $CardDisappearTimer

@onready var pauseMenu: PauseMenu = $Control/PauseMenu
@onready var activeMenu: Control = $Control/ActiveMenu

var dragging: bool = false
@onready var resourceCardPool: ResourceCardDeckNode = $ResourceCardPool
@onready var endTurnButton: Button = $Control/ActiveMenu/EndTurnButton
@onready var spawnCardButton: Button = $Control/ActiveMenu/SpawnRandomCard

# Called when the node enters the scene tree for the first time.
func _ready():
	CursorHandler.camera = camera
	CursorHandler.draggingBoundsArea = draggingBoundsArea
	draggingBoundsArea.visible = false
	pauseMenu.returnCallback = onReturn
	pauseMenu.mainMenuCallback = onMainMenu
	CursorHandler.canInteractWithBoard = true
	loadRutine()
	TimeHandler.connect("turnEnded", _on_turn_ended)

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		if !pauseMenu.visible:
			pauseMenu.visible = true
			activeMenu.visible = false
			get_viewport().set_input_as_handled()
			if CursorHandler.dragging:
				CursorHandler.onDropTriggered()
			CursorHandler.canInteractWithBoard = false

func onReturn():
	pauseMenu.visible = false
	activeMenu.visible = true
	get_viewport().set_input_as_handled()
	CursorHandler.canInteractWithBoard = true
	
func onMainMenu():	
	saveRoutine()
	get_tree().change_scene_to_file("res://scenes/menus/mainmenu.tscn")

func onQuit():
	saveRoutine()
	get_tree().quit()

func loadRutine():
	SaveHandler.loadGame()
	TimeHandler.time = SaveHandler.player.time

func saveRoutine():
	SaveHandler.player.time = TimeHandler.time
	SaveHandler.saveGame()

func _on_dragging_bounds_area_input_event(_camera, event: InputEvent, position, _normal, _shape_idx):
	if CursorHandler.dragging and event is InputEventMouseMotion:
		var minV = draggingPolygon.polygon[3]
		var maxV = draggingPolygon.polygon[1]
		var dragPosition = Vector3(max(minV.x,min(maxV.x,position.x)), position.y, max(minV.y, min(maxV.y, position.z)))
		CursorHandler.onDraggingMouseMotion(dragPosition)

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


func _on_notebook_collider_input_event(_camera, _event, _position, _normal, _shape_idx):
	if Input.is_action_just_pressed("select") and CursorHandler.cursorLagTimer.is_stopped() and CursorHandler.canInteractWithBoard:
		CursorHandler.cursorLagTimer.start()
		CursorHandler.canInteractWithBoard = false
		print("Alchemist's Notebook Open")


func _on_scroll_collider_input_event(_camera, _event, _position, _normal, _shape_idx):
	if Input.is_action_just_pressed("select") and CursorHandler.cursorLagTimer.is_stopped() and CursorHandler.canInteractWithBoard:
		CursorHandler.canInteractWithBoard = false
		CursorHandler.cursorLagTimer.start()
		print("Map Open")

func _on_turn_ended():
	print("turn ended logic")


