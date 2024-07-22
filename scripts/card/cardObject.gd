extends Node

var textureModified: bool = true
@onready var front: MeshInstance3D = $Front2
@onready var viewportHolder = $Front2/ViewportHolder
@onready var viewport = $Front2/ViewportHolder/SubViewport
@onready var cardTemplate: CardTemplate = $Front2/ViewportHolder/SubViewport/Cardtemplate

func _ready():
	changePropertyCard("gold")

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


func _on_area_3d_mouse_entered():
	print("mouse entered")
