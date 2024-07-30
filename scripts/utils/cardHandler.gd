extends Node

var resourceCardArray: Array[ResourceCard]
var eventCardArray: Array[EventCardResource]
@export var cityEventPool: Array[String]
@export var forestEventPool: Array[String]
@export var marshEventPool: Array[String]
@export var mountainEventPool: Array[String]

func _ready():
	resourceCardArray = []
	resourceCardArray.assign(loadResourcesFromCatalog("res://resources/cards"))
	eventCardArray = []
	eventCardArray.assign(loadResourcesFromCatalog("res://resources/events"))

func loadResourcesFromCatalog(path: String) -> Array[Resource]:
	var resources: Array[Resource] = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":			
			if '.tres.remap' in file_name:
				file_name = file_name.trim_suffix('.remap')
			var card = ResourceLoader.load(path+"/"+file_name)
			resources.append(card)
			file_name = dir.get_next()
	return resources

func loadResourceCard(id: String) -> ResourceCard:
	return resourceCardArray.filter(func(card: ResourceCard): return card.id == id)[0]

func getRandomResourceCard() -> ResourceCard:
	return resourceCardArray.pick_random()
	
func getRandomEventCardFromPool(pool: String) -> EventCardResource:
	match pool:
		"city":
			return getEventCard(cityEventPool.pick_random())
		"forest":
			return getEventCard(forestEventPool.pick_random())
		"marsh":
			return getEventCard(marshEventPool.pick_random())
		"mountain":
			return getEventCard(mountainEventPool.pick_random())
		_:
			return eventCardArray.pick_random()

func getEventCard(id: String)-> EventCardResource:
	print(id)
	return eventCardArray.filter(func(card: EventCardResource): return card.id == id)[0]
