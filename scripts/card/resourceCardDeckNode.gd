extends Node
class_name ResourceCardDeckNode

var deck: ResourceCardDeck

@export var tableCardSpawnPoint: Node3D
@export var tableCardSpawnOffset: Vector3
@export var cardNode: PackedScene

var activeCards: Array[ResourceCardNode] = []
var inactiveCards: Array[ResourceCardNode] = []

var cardsAtSpawn: Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	SaveHandler.loadGame()
	var savedDeck = SaveHandler.player.deck
	if savedDeck == {}:
		deck = initDeck()
	else:
		var inst = dict_to_inst(savedDeck)
		var tableCardsAsDicts = inst.tableCards as Array[Dictionary]
		deck = inst as ResourceCardDeck
		deck.tableCards = []
		var tableCards = tableCardsAsDicts.map(func(x): return dict_to_inst(x))
		deck.tableCards.assign(tableCards)
		loadDeck()

	
func initDeck() -> ResourceCardDeck:
	var savedDeck = ResourceCardDeck.new()
	var tableCards: Array[TableCard] = []
	var amount = len(savedDeck.fullContents)
	for i in amount:
		var card = cardNode.instantiate() as ResourceCardNode
		add_child(card)		
		move_child(card, 0)	
		card.global_rotation = tableCardSpawnPoint.global_rotation
		card.visible = true
		card.changePropertyCard(savedDeck.fullContents[amount - i - 1])
		card.position = tableCardSpawnPoint.position + tableCardSpawnOffset * i
		tableCards.append(TableCard.new(savedDeck.fullContents[amount - i - 1], card.global_position, card.get_instance_id()))
		activeCards.append(card)
	savedDeck.tableCards = tableCards
	SaveHandler.player.deck = inst_to_dict(savedDeck)
	SaveHandler.player.deck.tableCards = savedDeck.tableCards.map(func(x): return inst_to_dict(x))
	SaveHandler.saveGame()
	return savedDeck

func loadDeck():
	var amount = len(deck.tableCards)
	for i in amount:
		var position = deck.tableCards[amount - i - 1].position
		if typeof(position) == 4:
			position = str_to_var("Vector3"+position)
		var card = cardNode.instantiate() as ResourceCardNode
		add_child(card)
		card.global_rotation = tableCardSpawnPoint.global_rotation
		card.changePropertyCard(deck.tableCards[amount - i - 1].resourceCardId)
		card.position = position
		card.front.sorting_offset = amount - i
		deck.tableCards[amount - i - 1].instanceId = card.get_instance_id()
		card.visible = true
		activeCards.append(card)
	
func updateTableCardPosition(instanceId: int, newPosition: Vector3):
	deck.tableCards.filter(func(x): return x.instanceId == instanceId)[0].position = newPosition
	SaveHandler.player.deck = inst_to_dict(deck)
	SaveHandler.player.deck.tableCards = deck.tableCards.map(func(x): return inst_to_dict(x))
	SaveHandler.saveGame()

func updateCardZIndices(_card: ResourceCardNode):
	var childrenCount = len(get_children())
	move_child(_card, 0)	
	for i in childrenCount:
		var card = (get_child(i) as ResourceCardNode)
		card.front.sorting_offset = childrenCount - i
		
func markAsHidden(instanceId: int):
	var index = -1
	var card = null
	for i in len(activeCards):
		if activeCards[i].get_instance_id() == instanceId:
			index = i
			card = activeCards[i]
			break
	if index != -1:
		activeCards.remove_at(index)
		inactiveCards.append(card)
		deck.fullContents.remove_at(deck.fullContents.find(card.cardTemplate.card.id))
		deck.tableCards.remove_at(deck.tableCards.find(deck.tableCards.filter(func(x): return x.instanceId == instanceId)[0]))
		SaveHandler.player.deck = inst_to_dict(deck)
		SaveHandler.player.deck.tableCards = deck.tableCards.map(func(x): return inst_to_dict(x))
		SaveHandler.saveGame()
	else:
		print(instanceId)
		print("cant mark as hidden, card is not active")
	
func getRandomCard():
	if len(activeCards) > 0:
		return activeCards.pick_random()
	return null
	
func spawnRandomCard():
	var cards: Array[ResourceCard] = [CardHandler.getRandomResourceCard()]
	spawn(cards)
	
func spawn(cards: Array[ResourceCard]):
	var finalCard = null
	for i in len(cards):
		var card = null
		if len(inactiveCards) > 0:
			card = inactiveCards[0]
			inactiveCards.remove_at(0)
		else:			
			card = cardNode.instantiate() as ResourceCardNode
			add_child(card)
			card.global_rotation = tableCardSpawnPoint.global_rotation
		card.visible = true
		card.changePropertyCard(cards[i].id)
		var pos = tableCardSpawnPoint.position + (tableCardSpawnOffset * (i + len(cardsAtSpawn)))
		card.position = pos
		deck.fullContents.append(cards[i].id)
		deck.tableCards.append(TableCard.new(cards[i].id, card.global_position, card.get_instance_id()))
		activeCards.append(card)
		cardsAtSpawn.append(card.get_instance_id())
		finalCard = card
	updateCardZIndices(finalCard)
	SaveHandler.player.deck = inst_to_dict(deck)
	SaveHandler.player.deck.tableCards = deck.tableCards.map(func(x): return inst_to_dict(x))
	SaveHandler.saveGame()

func triggerSlotDetection(slots: Array[CardSlot]):
	for card in activeCards:
		card.tryDetectSlot(slots)
