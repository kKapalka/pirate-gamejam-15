extends Node
class_name GameplayNode

@onready var camera: Camera3D = $Camera3D
@onready var draggingBoundsArea: Area3D = $DraggingBoundsArea
@onready var draggingPolygon: CollisionPolygon3D = $DraggingPolygon
@onready var cardDisappearTimer: Timer = $CardDisappearTimer

@onready var pauseMenu: PauseMenu = $Control/PauseMenu
@onready var activeMenu: Control = $Control/ActiveMenu
@onready var mapMenu: Control = $Control/MapMenu
@onready var eventCard: EventCardTemplate = $Control/EventCard

var dragging: bool = false
@onready var resourceCardPool: ResourceCardDeckNode = $ResourceCardPool
@onready var broodButton: Button = $Control/ActiveMenu/Brood
@onready var brewButton: Button = $Control/ActiveMenu/BrewButton

@onready var cardSlots: Array[CardSlot] = [$CardSlot, $CardSlot2, $CardSlot3]
@onready var resultSlot : Node3D = $ResultSlot
const blankCardId : String = "blank"

var resultSlotMaterial: StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready():
	CursorHandler.camera = camera
	CursorHandler.draggingBoundsArea = draggingBoundsArea
	CursorHandler.cardSlots = cardSlots
	draggingBoundsArea.visible = false
	pauseMenu.returnCallback = onReturn
	pauseMenu.mainMenuCallback = onMainMenu
	pauseMenu.quitCallback = onQuit
	CursorHandler.canInteractWithBoard = true
	loadRutine()
	TimeHandler.connect("turnEnded", _on_turn_ended)
	call_deferred("afterReady")	
	resultSlotMaterial = (resultSlot.get_child(0) as MeshInstance3D).get_active_material(0)
	eventCard.gameplayNode = self
	if SaveHandler.player.currentEvent != null and SaveHandler.player.currentEvent != '':
		CursorHandler.canInteractWithBoard = false
		openEventCardById(SaveHandler.player.currentEvent)

func afterReady():
	resourceCardPool.triggerSlotDetection(cardSlots)

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		if !pauseMenu.visible:
			pauseMenu.visible = true
			activeMenu.visible = false
			mapMenu.visible = false
			get_viewport().set_input_as_handled()
			if CursorHandler.dragging:
				CursorHandler.onDropTriggered()
			CursorHandler.canInteractWithBoard = false

func onReturn():
	get_viewport().set_input_as_handled()
	pauseMenu.visible = false
	activeMenu.visible = true
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
		broodButton.disabled = true
		brewButton.disabled = true

func _on_card_disappear_timer_timeout():
	broodButton.disabled = false
	brewButton.disabled = false

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
		activeMenu.visible = false
		mapMenu.visible = true

func _on_turn_ended():
	print("turn ended logic")

func start_brew():
	# validate empty slots <= 1
	var filteredCardSlots : Array[CardSlot] = cardSlots.filter(func(cardslot : CardSlot) : return cardslot.card != null)
	if filteredCardSlots.size() < 2 :
		onRecipeFailure()
		return
	#find recipe
	var ingredientsId : Array[String] = []
	ingredientsId.assign(cardSlots.map(func(cardslot : CardSlot) : return mapCardSlotToCardId(cardslot)))
	var recipe : ResourceRecipe = RecipeHandler.findCombination(ingredientsId)
	if recipe != null:
		#delete all consumable cards
		for cardSlot in filteredCardSlots:
			var card = cardSlot.card
			if card.cardTemplate.card.consumable :
				resourceCardPool.markAsHidden(card.get_instance_id())
				card.disappear()
		#create cards
		for i in recipe.resultCount:
			resourceCardPool.spawnOneCard(CardHandler.loadResourceCard(recipe.resultId), resultSlot.global_position)
		resourceCardPool.deckSaveRoutine()
		#advance time
		TimeHandler.advanceTime()
	else:
		onRecipeFailure()

func onRecipeFailure():	
	var tween = create_tween()
	tween.tween_method(flashResultSlot, 0.0, 1.0, 0.5)
	cardDisappearTimer.start()
	broodButton.disabled = true
	brewButton.disabled = true

func flashResultSlot(delta: float):
	resultSlotMaterial.emission = Color(0.6,0.0,0.0) * sin(delta * PI)

func mapCardSlotToCardId(cardslot : CardSlot) -> String:
	if cardslot.card != null:
		return cardslot.card.cardTemplate.card.id
	return blankCardId

func _on_brew_button_button_up():
	start_brew()


func _on_brood_button_up():
	pass # Replace with function body.


func _on_close_map_button_up():
	activeMenu.visible = true
	mapMenu.visible = false
	CursorHandler.canInteractWithBoard = true


func _on_forest_button_button_up():
	openEventCard(CardHandler.getRandomEventCardFromPool("forest"))


func _on_city_button_button_up():
	openEventCard(CardHandler.getRandomEventCardFromPool("city"))


func _on_mountains_button_button_up():
	openEventCard(CardHandler.getRandomEventCardFromPool("mountains"))


func _on_marsh_button_button_up():
	openEventCard(CardHandler.getRandomEventCardFromPool("marsh"))

func openEventCardById(id: String):
	openEventCard(CardHandler.getEventCard(id))

func openEventCard(card: EventCardResource):
	SaveHandler.player.currentEvent = card.id
	SaveHandler.saveGame()
	mapMenu.visible = false
	activeMenu.visible = false
	eventCard.visible = true
	eventCard.card = card
	
func hideEventCard():
	eventCard.visible = false
	activeMenu.visible = true
	CursorHandler.canInteractWithBoard = true
	SaveHandler.player.currentEvent = ''
	SaveHandler.saveGame()
