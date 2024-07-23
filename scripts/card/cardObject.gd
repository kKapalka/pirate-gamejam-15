extends Node3D

class_name ResourceCardNode

var textureModified: bool = true
@onready var front: MeshInstance3D = $Front2
@onready var cardTemplate: CardTemplate = $Front2/ViewportHolder/SubViewport/Cardtemplate
@onready var detectionArea: StaticBody3D = $Area3D

var mousePositionOffset: Vector3
var basePosition: Vector3
var storedLift: float

var gameplayNode: GameplayNode

func _ready():
	becomeRandom()
		
func changePropertyCard(id: String):
	cardTemplate.card = CardHandler.loadResourceCard(id)

func becomeRandom():
	cardTemplate.card = CardHandler.getRandomResourceCard()
		
func onPickUp(lift: float):
	storedLift = global_position.y
	position.y = lift
	detectionArea.visible = false
	front.sorting_offset = 99
	
func onDraggingMouseMotion(_position: Vector3):
	if mousePositionOffset == Vector3.ZERO:
		mousePositionOffset = _position
		basePosition = position
	position = basePosition + _position - mousePositionOffset
	
func onDrop():
	gameplayNode.updateResourceCardPoolZIndices(self)
	detectionArea.visible = true
	position.y = 0
	mousePositionOffset = Vector3.ZERO
