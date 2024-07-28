extends Node

func _ready():
	SaveHandler.load()
	print(SaveHandler.player.turn)

func _on_autosave_timeout():
	SaveHandler.player.turn = 8
	SaveHandler.saveGame()
