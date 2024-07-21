extends Node

const FILE_NAME = "res://resources/game.save"

var player = {
	"name": "Zippy"
}

func save():
	var file = FileAccess.open(FILE_NAME, FileAccess.WRITE)
	file.store_string(JSON.stringify(player))
	file.close()

func load():
	if FileAccess.file_exists(FILE_NAME):
		var file = FileAccess.open(FILE_NAME, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			player = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
