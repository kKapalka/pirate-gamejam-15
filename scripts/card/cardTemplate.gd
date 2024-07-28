@tool
extends Node

class_name CardTemplate


@export var nameLabel: AutoResizeLabel
@export var artworkRect: TextureRect
@export var card: ResourceCard:
	get:
		return card
	set(newValue):
		card = newValue
		updateCardContents = true

var updateCardContents = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if updateCardContents or card.modified:
		onCardModified()


func onCardModified():
	nameLabel.text = card.name
	artworkRect.texture = card.texture
	nameLabel.onTextChanged()
	updateCardContents = false
	card.modified = false
