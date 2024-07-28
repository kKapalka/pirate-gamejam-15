extends Node3D

class_name ResourceCardNode

var textureModified: bool = true
@onready var front: MeshInstance3D = $Front2
@onready var cardTemplate: CardTemplate = $Front2/ViewportHolder/SubViewport/Cardtemplate
@onready var detectionArea: StaticBody3D = $Area3D
@export var emissionColor: Color
var resourceCardDeckNode: ResourceCardDeckNode

var mousePositionOffset: Vector3
var basePosition: Vector3
var frontMaterial: StandardMaterial3D
var rotationX: float
var baseY: float
var lift: float
var canMove = false

var oldPosition: Vector3
var newPosition: Vector3
var onSlotEmpty


var cardSlotDetectionArea = Rect2(Vector2(0,0), Vector2(1, 1.78) * Vector2(scale.x, scale.z) * 1.5)

func _ready():
	resourceCardDeckNode = get_parent()
	frontMaterial = front.get_active_material(0)
		
func changePropertyCard(id: String):
	cardTemplate.card = CardHandler.loadResourceCard(id)

func becomeRandom():
	cardTemplate.card = CardHandler.getRandomResourceCard()
		
func onPickUp(_lift: float):
	newPosition = position
	oldPosition = position	
	newPosition.y = _lift
	
	rotationX = rotation_degrees.x
	detectionArea.visible = false
	front.sorting_offset = 99
	var cardsAtSpawnIndex = resourceCardDeckNode.cardsAtSpawn.find(get_instance_id())
	if cardsAtSpawnIndex != -1:
		resourceCardDeckNode.cardsAtSpawn = []
	canMove = false
	var tween = create_tween()
	tween.tween_method(gradualRotation, 0.0, 1.0, 0.1)
	tween.tween_callback(
		func():
			canMove = true
	)
	if onSlotEmpty != null:
		onSlotEmpty.call()
		onSlotEmpty = null
	
	
func onDraggingMouseMotion(_position: Vector3):
	if mousePositionOffset == Vector3.ZERO:
		mousePositionOffset = _position
		basePosition = position
	if (canMove):
		basePosition.y = position.y
		position = lerp(position, basePosition + _position - mousePositionOffset, 0.8)
	
func onDrop(cardSlots: Array[CardSlot]):
	oldPosition = position
	newPosition = position
	oldPosition.y = 0
	resourceCardDeckNode.updateCardZIndices(self)
	detectionArea.visible = true
	mousePositionOffset = Vector3.ZERO
	
	cardSlotDetectionArea.position = Vector2(newPosition.x, newPosition.z) - (cardSlotDetectionArea.size / 2)
	for slot in cardSlots.filter(func(x): return x.card == null):
		if cardSlotDetectionArea.has_point(Vector2(slot.position.x, slot.position.z)):
			oldPosition = slot.position	
			slot.onFill(self)
	
	resourceCardDeckNode.updateTableCardPosition(get_instance_id(), oldPosition)
	
	
	var tween = create_tween()
	tween.tween_method(gradualRotation, 1.0, 0.0, 0.1)


func tryDetectSlot(cardSlots: Array[CardSlot]):
	cardSlotDetectionArea.position = Vector2(position.x, position.z) - (cardSlotDetectionArea.size / 2)
	for slot in cardSlots:
		if cardSlotDetectionArea.has_point(Vector2(slot.position.x, slot.position.z)):
			position = Vector3(slot.position.x, position.y, slot.position.z)
			slot.onFill(self)
			

func disappear():
	var tween = create_tween()
	tween.tween_method(gradualVisibility, 0.0, 1.0, 0.4)
	tween.tween_callback(afterDisappearing)
	


func gradualRotation(delta: float):
	position = lerp(oldPosition, newPosition, delta)
	rotation_degrees.x = rotationX + (25 * delta)

func gradualVisibility(delta: float):
	frontMaterial.emission = emissionColor * delta
	frontMaterial.albedo_color.a = 1.0 - delta

func afterDisappearing():
	visible = false
	frontMaterial.emission = Color(0.0,0.0,0.0,0.0)
	frontMaterial.albedo_color.a = 1.0
