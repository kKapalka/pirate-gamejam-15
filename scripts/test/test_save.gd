extends Node

func _ready():
	SaveHandler.load()
	print(SaveHandler.player.name)

func _on_autosave_timeout():
	SaveHandler.player.name = "Robert"
	SaveHandler.save()
