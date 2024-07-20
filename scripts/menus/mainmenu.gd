extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event: InputEvent) -> void:
	#Menu Navigation by Right Click
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var new_game_bounds = Rect2($HBoxContainer/VSplitContainer/VBoxContainer/NewGameLabel.global_position, $HBoxContainer/VSplitContainer/VBoxContainer/NewGameLabel.size)
		if new_game_bounds.has_point(event.position):
			new_game()
		var continue_bounds = Rect2($HBoxContainer/VSplitContainer/VBoxContainer/ContinueLabel.global_position, $HBoxContainer/VSplitContainer/VBoxContainer/ContinueLabel.size)
		if continue_bounds.has_point(event.position):
			continue_()
		var options_bounds = Rect2($HBoxContainer/VSplitContainer/VBoxContainer/OptionsLabel.global_position, $HBoxContainer/VSplitContainer/VBoxContainer/OptionsLabel.size)
		if options_bounds.has_point(event.position):
			options()
		var credits_bounds = Rect2($HBoxContainer/CreditsContainer/CreditsLabel.global_position, $HBoxContainer/CreditsContainer/CreditsLabel.size)
		if credits_bounds.has_point(event.position):
			credits()
		var quit_bounds = Rect2($HBoxContainer/QuitContainer/QuitLabel.global_position, $HBoxContainer/QuitContainer/QuitLabel.size)
		if quit_bounds.has_point(event.position):
			quit()

func new_game():
	print("new game clicked!")
	#TODO implement navigation and new game functionality

func continue_():
	print("continue clicked!")
	#TODO implement navigation and continue functionality

func options():
	print("options clicked!")
	#TODO implement navigation and options functionality

func credits():
	print("credits clicked!")
	#TODO implement navigation and credits functionality

func quit():
	get_tree().quit()
