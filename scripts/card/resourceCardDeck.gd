class_name ResourceCardDeck extends Resource

# entire deck: draw, discard, table
var fullContents: Array[String] = []

# cards in draw pile. At the start of the turn, a selected amount of cards is moved from draw pile onto the table.
var drawPile: Array[String] = []

# cards in discard pile. Once draw pile becomes empty, discard pile gets shuffled and moved into draw pile.
var discardPile: Array[String] = []

#cards placed on table. At the end of the turn, they will end up in discard pile
var tableCards: Array[TableCard] = []

#up to 3 cards, each index represents unique reagent brewing slot
var cardsInBrewingSlots: Array[String] = []

# draw N cards. stop if not enough cards in deck
func draw(number: int) -> Array[String]:
	var cards = []
	for i in number:
		cards.append(drawPile.pop_front())
		if len(drawPile) == 0:
			return cards
	return cards

# move all table cards into discard pile
func discardTableCards():
	discardPile.append_array(tableCards.map(func(x: TableCard): return x.resourceCardId))
	
#put discard pile in the draw pile, then shuffle it
func shuffle():
	drawPile.append_array(discardPile)
	discardPile = []
	drawPile.shuffle()
