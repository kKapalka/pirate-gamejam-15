extends Node3D

class_name ResourceCardNode

#Z-Index - helper variable to ensure that only topmost card gets picked up
var zindex: int = 0

var textureModified: bool = true
@onready var front: MeshInstance3D = $Front2
@onready var viewportHolder = $Front2/ViewportHolder
@onready var viewport = $Front2/ViewportHolder/SubViewport
@onready var cardTemplate: CardTemplate = $Front2/ViewportHolder/SubViewport/Cardtemplate
@onready var detectionArea: StaticBody3D = $Area3D

var mousePositionOffset: Vector3
var basePosition: Vector3
var storedLift: float

var gameplayNode: GameplayNode

func _ready():
	becomeRandom()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if textureModified:
		#call_deferred("onTextureModified")
		textureModified = false
	
# allegedly using viewport in this way is taxing on memory
# so this would be a workaround. Needs to be tested.
#func onTextureModified():
	#await RenderingServer.frame_post_draw
	#var texture = viewport.get_texture().get_image() as Image
	#var material: BaseMaterial3D = front.mesh.surface_get_material(0)
	#material.albedo_texture = ImageTexture.create_from_image(texture)
	#viewportHolder.visible = false
		
func changePropertyCard(id: String):
	cardTemplate.card = CardHandler.loadResourceCard(id)
	textureModified = true
	#viewportHolder.visible = true

func becomeRandom():
	cardTemplate.card = CardHandler.getRandomResourceCard()
	textureModified = true	

func _on_area_3d_mouse_entered():
	CursorHandler.resourceCardsInArea.append(self)

func _on_area_3d_mouse_exited():
	CursorHandler.resourceCardsInArea.remove_at(CursorHandler.resourceCardsInArea.find(self))
		
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
	#CursorHandler.resourceCardsInArea.append(self)
