extends Node3D
class_name CardSlot

var card: ResourceCardNode

func onFill(_card: ResourceCardNode):
	card = _card
	card.onSlotEmpty = onSlotEmpty
	
func onSlotEmpty():
	card = null
