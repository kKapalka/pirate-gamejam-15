extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	loadRutine()
	TimeHandler.connect("turnEnded", _on_turn_ended)

func loadRutine():
	SaveHandler.loadGame()
	TimeHandler.time = SaveHandler.player.time

func _on_turn_ended():
	print("turn ended logic")

func _on_timer_timeout():
	TimeHandler.advanceTime()
