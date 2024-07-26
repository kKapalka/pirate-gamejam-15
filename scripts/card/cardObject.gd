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

func _ready():
	resourceCardDeckNode = get_parent()
	frontMaterial = front.get_active_material(0)
		
func changePropertyCard(id: String):
	cardTemplate.card = CardHandler.loadResourceCard(id)

func becomeRandom():
	cardTemplate.card = CardHandler.getRandomResourceCard()
		
func onPickUp(lift: float):
	position.y = lift
	detectionArea.visible = false
	front.sorting_offset = 99
	rotate_x(deg_to_rad(25))
	var cardsAtSpawnIndex = resourceCardDeckNode.cardsAtSpawn.find(get_instance_id())
	if cardsAtSpawnIndex != -1:
		resourceCardDeckNode.cardsAtSpawn = []
		
	
func onDraggingMouseMotion(_position: Vector3):
	if mousePositionOffset == Vector3.ZERO:
		mousePositionOffset = _position
		basePosition = position
	position = basePosition + _position - mousePositionOffset
	
func onDrop():
	resourceCardDeckNode.updateCardZIndices(self)
	detectionArea.visible = true
	position.y = 0
	rotate_x(deg_to_rad(-25))
	mousePositionOffset = Vector3.ZERO
	resourceCardDeckNode.updateTableCardPosition(get_instance_id(), global_position)
	
func disappear():
	var tween = create_tween()
	tween.tween_method(gradualVisibility, 0.0, 1.0, 1.0)
	tween.tween_callback(afterDisappearing)

func gradualVisibility(delta: float):
	frontMaterial.emission = emissionColor * delta
	frontMaterial.albedo_color.a = 1.0 - delta

func afterDisappearing():
	visible = false
	frontMaterial.emission = Color(0.0,0.0,0.0,0.0)
	frontMaterial.albedo_color.a = 1.0
