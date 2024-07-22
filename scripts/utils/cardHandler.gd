extends Node

@export var resourceCardArray: Array[ResourceCard] = []

func loadResourceCard(id: String) -> ResourceCard:
	return resourceCardArray.filter(func(card: ResourceCard): return card.id == id)[0]
