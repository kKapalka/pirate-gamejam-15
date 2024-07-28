extends Node3D
class_name CardSlot

var card: ResourceCardNode

func onFill(_card: ResourceCardNode):
	card = _card
	card.onSlotEmpty = onSlotEmpty
	print(self)
	print("I have card " + _card.cardTemplate.card.id)
	
func onSlotEmpty():
	card = null
	print("card ejected")
