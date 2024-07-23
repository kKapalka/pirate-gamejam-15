extends Node
class_name ResourceCardDeckNode

var deck: ResourceCardDeck

@export var tableCardInitialSlots: Array[Node3D]
@export var resourceCardPool: Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var savedDeck = SaveHandler.player.deck
	if savedDeck == {}:
		deck = initDeck()
	else:
		deck = savedDeck
		loadDeck()
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func initDeck() -> ResourceCardDeck:
	var savedDeck = ResourceCardDeck.new()
	savedDeck.fullContents = ["copper", "fire", "gold", "iron", "earth", "lead", "water", "air"]
	savedDeck.drawPile = savedDeck.fullContents
	var cardsDrawn = savedDeck.draw(SaveHandler.player.cardsDrawnPerTurn)
	var tableCards = []
	for i in len(cardsDrawn):
		var card = (resourceCardPool.get_child(i) as ResourceCardNode)
		card.changePropertyCard(cardsDrawn[i])
		card.global_position = tableCardInitialSlots[i].global_position
		tableCards.append(TableCard.new(cardsDrawn[i], card.global_position))
	savedDeck.tableCards = tableCards
	SaveHandler.player.deck = savedDeck
	SaveHandler.saveGame()
	return savedDeck

func loadDeck():
	for i in len(deck.tableCards):
		var card = (resourceCardPool.get_child(i) as ResourceCardNode)
		card.changePropertyCard(deck.tableCards[i].nodeId)
		card.global_position = deck.tableCards[i].position
	
func draw():	
	var cardsDrawn = deck.draw(SaveHandler.player.cardsDrawnPerTurn)
	if len(cardsDrawn) < SaveHandler.player.cardsDrawnPerTurn:
		deck.shuffle()
		cardsDrawn.append_array(deck.draw(SaveHandler.player.cardsDrawnPerTurn - len(cardsDrawn)))
	var tableCards = []	
	for i in len(cardsDrawn):
		var card = (resourceCardPool.get_child(i) as ResourceCardNode)
		card.changePropertyCard(cardsDrawn[i])
		card.global_position = tableCardInitialSlots[i].global_position
		tableCards.append(TableCard.new(cardsDrawn[i], card.global_position))	
	SaveHandler.player.deck = deck
	SaveHandler.saveGame()
	
