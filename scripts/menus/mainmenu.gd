extends MarginContainer

@onready var mainMenuContainer: HBoxContainer = $HBoxContainer
@onready var settingsContainer: SettingsMenu = $Settings

@onready var buttons: Array[Button] = [
	$HBoxContainer/VSplitContainer/VBoxContainer/Continue,
	$HBoxContainer/VSplitContainer/VBoxContainer/NewGame,
	$HBoxContainer/VSplitContainer/VBoxContainer/Options,
	$HBoxContainer/CreditsContainer/Credits,
	$HBoxContainer/QuitContainer/Quit
]
var focusedButtonIndex = 0
var minFocusedButtonIndex = 0

func _ready():
	AudioManager.setMusicTrack(0)
	settingsContainer.returnCallback = onReturn
	if SaveHandler.player == {
		"deck": {},
		"currentEvent": '',
		"time": 1
	}:
		buttons[0].visible = false
		focusedButtonIndex = 1
		minFocusedButtonIndex = 1
	
	buttons[focusedButtonIndex].grab_focus()

func _input(_event):
	if mainMenuContainer.visible:
		if Input.is_action_pressed("ui_down"):
			focusedButtonIndex += 1
			if focusedButtonIndex >= len(buttons):
				focusedButtonIndex -= len(buttons) - minFocusedButtonIndex
			buttons[focusedButtonIndex].grab_focus()
			get_viewport().set_input_as_handled()
		
		if Input.is_action_pressed("ui_up"):
			focusedButtonIndex -= 1
			if focusedButtonIndex < minFocusedButtonIndex:
				focusedButtonIndex += len(buttons) - minFocusedButtonIndex
			buttons[focusedButtonIndex].grab_focus()
			get_viewport().set_input_as_handled()
		
		if Input.is_action_pressed("select"):
			buttons[focusedButtonIndex].pressed.emit()
		

func new_game():
	focusedButtonIndex = 1
	AudioManager.setMusicTrack(1)
	SaveHandler.clearGame()
	get_tree().change_scene_to_file("res://scenes/gameplay.tscn")

func continue_():
	focusedButtonIndex = 0
	AudioManager.setMusicTrack(1)
	get_tree().change_scene_to_file("res://scenes/gameplay.tscn")

func options():
	focusedButtonIndex = 2
	settingsContainer.visible = true
	settingsContainer.onShow()
	mainMenuContainer.visible = false

func credits():
	focusedButtonIndex = 3
	get_tree().change_scene_to_file("res://scenes/menus/credits.tscn")

func quit():
	focusedButtonIndex = 4
	get_tree().quit()
	
func onReturn():
	settingsContainer.visible = false
	mainMenuContainer.visible = true
	buttons[focusedButtonIndex].grab_focus()

func _on_new_game_button_up():
	new_game()
func _on_continue_button_up():
	continue_()
func _on_options_button_up():
	options()
func _on_quit_button_up():
	quit()
func _on_credits_button_up():
	credits()
