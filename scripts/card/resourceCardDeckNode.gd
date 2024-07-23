extends Node
class_name ResourceCardDeckNode

var deck: ResourceCardDeck

@export var tableCardInitialSlotPool: Node

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
	savedDeck.fullContents.assign(["copper", "fire", "gold", "iron", "earth", "lead", "water", "air"])
	savedDeck.drawPile = savedDeck.fullContents.duplicate()
	var cardsDrawn = savedDeck.draw(SaveHandler.player.cardsDrawnPerTurn)
	var tableCards: Array[TableCard] = []
	for i in len(cardsDrawn):
		var card = (get_child(i) as ResourceCardNode)
		card.visible = true
		card.changePropertyCard(cardsDrawn[i])
		card.global_position = tableCardInitialSlotPool.get_child(i).global_position
		tableCards.append(TableCard.new(cardsDrawn[i], card.global_position, card.get_instance_id()))
	savedDeck.tableCards = tableCards
	SaveHandler.player.deck = inst_to_dict(savedDeck)
	SaveHandler.player.deck.tableCards = savedDeck.tableCards.map(func(x): return inst_to_dict(x))
	SaveHandler.saveGame()
	return savedDeck

func loadDeck():
	for i in len(deck.tableCards):
		var position = deck.tableCards[i].position
		if typeof(position) == 4:
			position = str_to_var("Vector3"+position)
		var card = (get_child(i) as ResourceCardNode)
		card.changePropertyCard(deck.tableCards[i].resourceCardId)
		card.global_position = position
		deck.tableCards[i].instanceId = card.get_instance_id()
		card.visible = true
	
func draw():
	var cardsDrawn = deck.draw(SaveHandler.player.cardsDrawnPerTurn)
	if len(cardsDrawn) < SaveHandler.player.cardsDrawnPerTurn:
		deck.shuffle()
		cardsDrawn.append_array(deck.draw(SaveHandler.player.cardsDrawnPerTurn - len(cardsDrawn)))
	var tableCards = []	
	for i in len(cardsDrawn):
		var card = (get_child(i) as ResourceCardNode)
		card.changePropertyCard(cardsDrawn[i])
		card.global_position = tableCardInitialSlotPool.get_child(i).global_position
		card.visible = true
		tableCards.append(TableCard.new(cardsDrawn[i], card.global_position, card.get_instance_id()))
	deck.tableCards = tableCards
	SaveHandler.player.deck = inst_to_dict(deck)
	SaveHandler.player.deck.tableCards = deck.tableCards.map(func(x): return inst_to_dict(x))
	SaveHandler.saveGame()
	
func updateTableCardPosition(instanceId: int, newPosition: Vector3):
	deck.tableCards.filter(func(x): return x.instanceId == instanceId)[0].position = newPosition
	SaveHandler.player.deck = inst_to_dict(deck)
	SaveHandler.player.deck.tableCards = deck.tableCards.map(func(x): return inst_to_dict(x))
	SaveHandler.saveGame()
