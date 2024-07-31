@tool
extends Node

class_name EventCardTemplate

@export var nameLabel: AutoResizeLabel
@export var descriptionLabel: Label
@export var options: Array[Button]
@export var artworkRect: TextureRect
@export var philoStoneOverride: AnimatedSprite2D
@export var card: EventCardResource:
	get:
		return card
	set(newValue):
		card = newValue
		updateCardContents = true

var updateCardContents = false
var gameplayNode: GameplayNode

func ready():
	onCardModified()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if updateCardContents or card.modified:
		onCardModified()


func onCardModified():
	philoStoneOverride.visible = card.id == 'ending_stone'
	nameLabel.text = card.title
	descriptionLabel.text = card.description
	artworkRect.texture = card.texture
	nameLabel.onTextChanged()
	updateCardContents = false
	card.modified = false
	if len(options) == 0:
		options = [
			$Art/VBoxContainer/Option1, $Art/VBoxContainer/Option2, $Art/VBoxContainer/Option3
		]
	if len(options) > 0:
		for optionNode in options:
			optionNode.visible = false
		for i in len(card.options):
			options[i].get_child(0).text = card.options[i].text
			options[i].visible = true


func _on_option_3_button_up():
	onOptionPicked(2)
func _on_option_2_button_up():
	onOptionPicked(1)
func _on_option_1_button_up():
	onOptionPicked(0)

func onOptionPicked(index: int):
	var selectedOption = card.options[index]
	if selectedOption.gameOver:
		SaveHandler.clearGame()
		gameplayNode.onMainMenu()
	else:
		if len(selectedOption.cardsGranted) > 0:
			gameplayNode.resourceCardPool.spawnCardsByIds(selectedOption.cardsGranted)
		if selectedOption.eventCardOpenedId != null and selectedOption.eventCardOpenedId != '':
			self.card = CardHandler.getEventCard(selectedOption.eventCardOpenedId)
		else:
			gameplayNode.hideEventCard()
