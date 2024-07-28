extends Node

var resourceCardArray: Array[ResourceCard]

func _ready():
	var path = "res://resources/cards"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var card = ResourceLoader.load(path+"/"+file_name) as ResourceCard
			resourceCardArray.append(card)
			file_name = dir.get_next()
			
				
func loadResourceCard(id: String) -> ResourceCard:
	return resourceCardArray.filter(func(card: ResourceCard): return card.id == id)[0]

func getRandomResourceCard() -> ResourceCard:
	return resourceCardArray.pick_random()
