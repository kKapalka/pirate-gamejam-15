extends Control

@onready var testContainer: PanelContainer = $PanelContainer
@onready var pauseContainer: PauseMenu = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pauseContainer.returnCallback = on_return
	pauseContainer.mainMenuCallback = on_mainmenu

func _on_button_button_up():
	pauseContainer.visible = true
	pauseContainer.onShow()
	testContainer.visible = false

func on_return():
	pauseContainer.visible = false
	testContainer.visible = true

func on_mainmenu():
	print("Parent handling main menu nav")
