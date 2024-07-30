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
@onready var discardSlot: CardSlot = $DiscardSlot
var allSlots : Array[CardSlot]

var resultSlotMaterial: StandardMaterial3D

@onready var labelCardStrength = $"Control/ActiveMenu/CandleStrength"
@onready var labelTurnsLeft = $"Control/ActiveMenu/TurnsLeft"

@export var deskClickSound: AudioStream
@export var scrollClickSound: AudioStream
@export var furnaceClickSound: AudioStream
@export var glassClickSound: AudioStream
@export var bookClickSound: AudioStream
@export var UIClickSound: AudioStream
@export var brewSound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.setMusicTrack(1)
	CursorHandler.camera = camera
	CursorHandler.draggingBoundsArea = draggingBoundsArea
	allSlots = cardSlots.duplicate()
	allSlots.append(discardSlot)
	CursorHandler.cardSlots = allSlots
	draggingBoundsArea.visible = false
	pauseMenu.returnCallback = onReturn
	pauseMenu.mainMenuCallback = onMainMenu
	pauseMenu.quitCallback = onQuit
	CursorHandler.canInteractWithBoard = true
	loadRutine()
	TimeHandler.connect("turnEnded", _on_turn_ended)
	TimeHandler.connect("timeChanged", _on_time_value_changed)
	CandleHandler.connect("candleValueChanged", _on_candle_value_changed)
	CandleHandler.connect("candleReachedLimit", _on_candle_reached_limit)
	call_deferred("afterReady")	
	resultSlotMaterial = (resultSlot.get_child(0) as MeshInstance3D).get_active_material(0)
	eventCard.gameplayNode = self
	if SaveHandler.player.currentEvent != null and SaveHandler.player.currentEvent != '':
		CursorHandler.canInteractWithBoard = false
		openEventCardById(SaveHandler.player.currentEvent)

func afterReady():
	resourceCardPool.triggerSlotDetection(allSlots)

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
			AudioManager.playSFXAtDefaultPosition(UIClickSound)

func onReturn():
	get_viewport().set_input_as_handled()
	pauseMenu.visible = false
	activeMenu.visible = true
	CursorHandler.canInteractWithBoard = true
	
func onMainMenu():	
	AudioManager.setMusicTrack(0)
	saveRoutine()
	get_tree().change_scene_to_file("res://scenes/menus/mainmenu.tscn")

func onQuit():
	saveRoutine()
	get_tree().quit()

func loadRutine():
	SaveHandler.loadGame()
	TimeHandler.time = SaveHandler.player.time
	CandleHandler.candleStrength = SaveHandler.player.candle
	update_candle_label()
	update_time_label()

func saveRoutine():
	SaveHandler.player.time = TimeHandler.time
	SaveHandler.player.candle = CandleHandler.candleStrength
	SaveHandler.saveGame()

func _on_dragging_bounds_area_input_event(_camera, event: InputEvent, position, _normal, _shape_idx):
	if (CursorHandler.draggedCard != null and !CursorHandler.dragging) or (CursorHandler.dragging and event is InputEventMouseMotion):
		var minV = draggingPolygon.polygon[3]
		var maxV = draggingPolygon.polygon[1]
		var dragPosition = Vector3(max(minV.x,min(maxV.x,position.x)), position.y, max(minV.y, min(maxV.y, position.z)))
		CursorHandler.onDraggingMouseMotion(dragPosition)


func _on_scroll_collider_input_event(_camera, _event, position, _normal, _shape_idx):
	if Input.is_action_just_pressed("select") and CursorHandler.cursorLagTimer.is_stopped() and CursorHandler.canInteractWithBoard:
		if TimeHandler.time > 3:
			print("cannot travel")
		else:
			AudioManager.playSFX(scrollClickSound, position)
			CursorHandler.canInteractWithBoard = false
			CursorHandler.cursorLagTimer.start()
			activeMenu.visible = false
			mapMenu.visible = true

func _on_turn_ended():
	CandleHandler.reduceStrengthBy(1)

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
			deleteCard(cardSlot.card)
		#create cards
		for i in recipe.resultCount:
			resourceCardPool.spawnOneCard(CardHandler.loadResourceCard(recipe.resultId), resultSlot.global_position)
		resourceCardPool.deckSaveRoutine()
		#advance time
		AudioManager.playSFXAtDefaultPosition(brewSound)
		TimeHandler.advanceTime()
	else:
		onRecipeFailure()

func deleteCard(card : ResourceCardNode):
	if card.cardTemplate.card.consumable :
		resourceCardPool.markAsHidden(card.get_instance_id())
		card.disappear()

func onRecipeFailure():	
	var tween = create_tween()
	tween.tween_method(flashResultSlot, 0.0, 1.0, 0.5)
	AudioManager.playSFXAtDefaultPosition(UIClickSound)
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
	AudioManager.playSFXAtDefaultPosition(UIClickSound)
	TimeHandler.advanceTime()


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
	if SaveHandler.player.currentEvent != 'assessment2':
		TimeHandler.advanceTime()
	SaveHandler.player.currentEvent = ''
	SaveHandler.saveGame()

func _on_candle_reached_limit():
	update_candle_label()
	openEventCardById("ending_shadows")

func _on_candle_value_changed():
	update_candle_label()

func update_candle_label():
	labelCardStrength.text = "Candle Strength: " + str(CandleHandler.candleStrengthInInt())

func _on_time_value_changed():
	update_time_label()

func update_time_label():
	labelTurnsLeft.text = "Turns until darkness attacks: " + str(7 - TimeHandler.time)


func _on_static_body_3d_input_event(_camera, _event, position, _normal, _shape_idx):
	if Input.is_action_just_pressed("select") and CursorHandler.cursorLagTimer.is_stopped() and CursorHandler.canInteractWithBoard:
		AudioManager.playSFX(deskClickSound, position)
		CursorHandler.cursorLagTimer.start()


func _on_furnace_body_input_event(_camera, _event, position, _normal, _shape_idx):
	if Input.is_action_just_pressed("select") and CursorHandler.cursorLagTimer.is_stopped() and CursorHandler.canInteractWithBoard:
		AudioManager.playSFX(furnaceClickSound, position)
		CursorHandler.cursorLagTimer.start()


func _on_glass_stuffs_input_event(_camera, _event, position, _normal, _shape_idx):
	if Input.is_action_just_pressed("select") and CursorHandler.cursorLagTimer.is_stopped() and CursorHandler.canInteractWithBoard:
		AudioManager.playSFX(glassClickSound, position)
		CursorHandler.cursorLagTimer.start()


func _on_notebook_collider_input_event(_camera, _event, position, _normal, _shape_idx):
	if Input.is_action_just_pressed("select") and CursorHandler.cursorLagTimer.is_stopped() and CursorHandler.canInteractWithBoard:
		AudioManager.playSFX(bookClickSound, position)
		CursorHandler.cursorLagTimer.start()


func _on_card_disappear_timer_timeout():
	broodButton.disabled = false
	brewButton.disabled = false


func _on_discard_button_button_up():
	if discardSlot.card != null and discardSlot.card.cardTemplate.card.consumable:
		CandleHandler.addStrengthBy(discardSlot.card.cardTemplate.card.discardStrength)
		deleteCard(discardSlot.card)
