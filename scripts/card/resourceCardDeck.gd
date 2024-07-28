class_name ResourceCardDeck

# entire deck: draw, discard, table
var fullContents: Array[String] = []

#cards as they are placed on table
var tableCards: Array[TableCard] = []

#initial deck content
func _init():
	self.fullContents.append_array(
		["water", "air", "earth", "fire"]
	)
