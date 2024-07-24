extends MarginContainer

@onready var mainMenuContainer: HBoxContainer = $HBoxContainer
@onready var settingsContainer: SettingsMenu = $Settings

@onready var buttons: Array[Button] = [
	$HBoxContainer/VSplitContainer/VBoxContainer/NewGame,
	$HBoxContainer/VSplitContainer/VBoxContainer/Continue,
	$HBoxContainer/VSplitContainer/VBoxContainer/Options,
	$HBoxContainer/CreditsContainer/Credits,
	$HBoxContainer/QuitContainer/Quit
]
var focusedButtonIndex = 0

func _ready():
	settingsContainer.returnCallback = onReturn
	buttons[focusedButtonIndex].grab_focus()

func _input(event):
	if mainMenuContainer.visible:
		if Input.is_action_pressed("ui_down"):
			focusedButtonIndex += 1
			if focusedButtonIndex >= len(buttons):
				focusedButtonIndex -= len(buttons)
			buttons[focusedButtonIndex].grab_focus()
			get_viewport().set_input_as_handled()
		
		if Input.is_action_pressed("ui_up"):
			focusedButtonIndex -= 1
			if focusedButtonIndex < 0:
				focusedButtonIndex += len(buttons)
			buttons[focusedButtonIndex].grab_focus()
			get_viewport().set_input_as_handled()
		
		if Input.is_action_pressed("select"):
			buttons[focusedButtonIndex].pressed.emit()
		

func new_game():
	focusedButtonIndex = 0
	print("new game clicked!")
	#TODO implement navigation and new game functionality

func continue_():
	focusedButtonIndex = 1
	print("continue clicked!")
	#TODO implement navigation and continue functionality

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
