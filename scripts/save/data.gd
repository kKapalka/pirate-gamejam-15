extends Node

const FILE_NAME = "res://resources/game.save"
const SETTINGS_FILE_NAME = "res://resources/settings.save"

var player = {
	"name": "Zippy",
	"deck": {},
	"time": 1
}
var settings = {
	"master": 10,
	"music": 10,
	"sfx": 10
}

func saveGame():
	save(FILE_NAME, player)
func saveSettings():
	save(SETTINGS_FILE_NAME, settings)

func _ready():
	loadSettings()

func load():
	loadGame()
	loadSettings()
	
func clearGame():
	player = {
		"name": "Zippy",
		"deck": {},
		"time": 1
	}
	saveGame()

func loadGame():
	loadFile(FILE_NAME, "player")
func loadSettings():
	loadFile(SETTINGS_FILE_NAME, "settings")

func save(fileName: String, saveObject: Variant):
	var file = FileAccess.open(fileName, FileAccess.WRITE)
	file.store_string(JSON.stringify(saveObject))
	file.close()

func loadFile(fileName: String, saveObjectName: String):
	if FileAccess.file_exists(fileName):
		var file = FileAccess.open(fileName, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			match saveObjectName:
				"player":
					player = data
				"settings":
					settings = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
		
func setSFXVolume(value: int):
	settings.sfx = value
	setBus("SFX", linear_to_db(float(value)/10.0))
	saveSettings()
func setMusicVolume(value: int):
	settings.music = value
	setBus("Music", linear_to_db(float(value)/10.0))
	saveSettings()
func setMasterVolume(value: int):
	settings.master = value
	setBus("Master", linear_to_db(float(value)/10.0))
	saveSettings()
	
func setBus(busName, volume_db):
	var busIndex = AudioServer.get_bus_index(busName)
	AudioServer.set_bus_volume_db(busIndex, volume_db)
	AudioServer.set_bus_mute(busIndex, false)

