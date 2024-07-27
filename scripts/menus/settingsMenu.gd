extends Control

class_name SettingsMenu

@onready var masterSlider: HSlider = $Master/Slider
@onready var musicSlider: HSlider = $Music/Slider
@onready var SFXSlider: HSlider = $SFX/Slider

@onready var returnButton: Button = $Return

@onready var focusable: Array[Control] = [
	masterSlider, musicSlider, SFXSlider, returnButton
]

var focusedButtonIndex = 0

var returnCallback: Callable

func _input(_event):
	if self.visible:
		if Input.is_action_pressed("ui_cancel"):
			_on_return_button_up()
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
			if focusedButtonIndex == 3:
				focusable[focusedButtonIndex].pressed.emit()

func _ready():
	masterSlider.value = SaveHandler.settings.master
	musicSlider.value = SaveHandler.settings.music
	SFXSlider.value = SaveHandler.settings.sfx

func _on_master_volume_slider_value_changed(value):
	focusedButtonIndex = 0
	SaveHandler.setMasterVolume(value)
func _on_music_volume_slider_value_changed(value):
	focusedButtonIndex = 1
	SaveHandler.setMusicVolume(value)
func _on_sfx_volume_slider_value_changed(value):
	focusedButtonIndex = 2
	SaveHandler.setSFXVolume(value)
func _on_return_button_up():
	if returnCallback == null:
		print("Menu hosting this settings panel does not set 'returnCallback' parameter of SettingsMenu node.")
	else:
		returnCallback.call()
		
func onShow():
	focusedButtonIndex = 0
	focusable[focusedButtonIndex].grab_focus()
	
		
