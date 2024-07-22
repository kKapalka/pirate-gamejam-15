extends Control

class_name PauseMenu

@onready var pauseMenuContainer: VBoxContainer = $VBoxContainer
@onready var settingsContainer: SettingsMenu = $Settings
@onready var resumeButton: Button = $VBoxContainer/Resume
@onready var settingsButton: Button = $VBoxContainer/Options
@onready var mainMenuButton: Button = $VBoxContainer/MainMenu
@onready var quitButton: Button = $VBoxContainer/Quit

@onready var focusable: Array[Control] = [
	resumeButton, settingsButton, mainMenuButton, quitButton
]

var focusedButtonIndex = 0

var returnCallback: Callable
var mainMenuCallback: Callable

func _ready():
	settingsContainer.returnCallback = onReturn
	focusable[focusedButtonIndex].grab_focus()

func onShow():
	focusedButtonIndex = 0
	focusable[focusedButtonIndex].grab_focus()

func _input(event):
	if pauseMenuContainer.visible:
		if Input.is_action_pressed("ui_cancel"):
			_on_resume_button_up()
			get_viewport().set_input_as_handled()
		if Input.is_action_pressed("ui_down"):
			focusedButtonIndex += 1
			if focusedButtonIndex >= len(focusable):
				focusedButtonIndex -= len(focusable)
			focusable[focusedButtonIndex].grab_focus()
			get_viewport().set_input_as_handled()
		
		if Input.is_action_pressed("ui_up"):
			focusedButtonIndex -= 1
			if focusedButtonIndex < 0:
				focusedButtonIndex += len(focusable)
			focusable[focusedButtonIndex].grab_focus()
			get_viewport().set_input_as_handled()
		
		if Input.is_action_pressed("select"):
			focusable[focusedButtonIndex].pressed.emit()

func _on_resume_button_up():
	focusedButtonIndex = 0
	if returnCallback == null:
		print("Game does not set 'returnCallback' parameter of PauseMenu node.")
	else:
		returnCallback.call()

func _on_settings_button_up():
	focusedButtonIndex = 1
	settingsContainer.visible = true
	settingsContainer.onShow()
	pauseMenuContainer.visible = false

func _on_main_menu_button_up():
	focusedButtonIndex = 2
	if returnCallback == null:
		print("Game does not set 'mainMenuCallback' parameter of PauseMenu node.")
	else:
		SaveHandler.saveGame()
		mainMenuCallback.call()


func _on_quit_button_up():
	focusedButtonIndex = 3
	SaveHandler.saveGame()
	get_tree().quit()

func onReturn():
	settingsContainer.visible = false
	pauseMenuContainer.visible = true
	focusable[focusedButtonIndex].grab_focus()
