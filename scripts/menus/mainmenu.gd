extends MarginContainer

@onready var mainMenuContainer: HBoxContainer = $HBoxContainer
@onready var settingsContainer: SettingsMenu = $Settings

func _ready():
	settingsContainer.returnCallback = onReturn

func new_game():
	print("new game clicked!")
	#TODO implement navigation and new game functionality

func continue_():
	print("continue clicked!")
	#TODO implement navigation and continue functionality

func options():
	settingsContainer.visible = true
	mainMenuContainer.visible = false

func credits():
	print("credits clicked!")
	#TODO implement navigation and credits functionality

func quit():
	get_tree().quit()
	
func onReturn():
	settingsContainer.visible = false
	mainMenuContainer.visible = true

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
