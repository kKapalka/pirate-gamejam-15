@tool
extends Node


@export var nameLabel: AutoResizeLabel
@export var artworkRect: TextureRect
@export var card: ResourceCard:
	get:
		return card
	set(newValue):
		card = newValue
		if Engine.is_editor_hint():
			updateCardContentsInEditor = true

var updateCardContentsInEditor = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if updateCardContentsInEditor or card.modified:
		updateCardContents()


func updateCardContents():
	nameLabel.text = card.name
	nameLabel.remove_theme_color_override("font_color")
	nameLabel.add_theme_color_override("font_color", card.textColor)
	artworkRect.texture = card.texture
	nameLabel.onTextChanged()
	updateCardContentsInEditor = false
	card.modified = false
