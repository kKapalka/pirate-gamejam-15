extends Node

class_name SettingsMenu

@onready var masterSlider: HSlider = $Master/Slider
@onready var musicSlider: HSlider = $Music/Slider
@onready var SFXSlider: HSlider = $SFX/Slider

@onready var returnButton: Button = $Return

var returnCallback: Callable

func _ready():
	masterSlider.value = SaveHandler.settings.master
	musicSlider.value = SaveHandler.settings.music
	SFXSlider.value = SaveHandler.settings.sfx

func _on_master_volume_slider_value_changed(value):
	SaveHandler.setMasterVolume(value)
func _on_music_volume_slider_value_changed(value):
	SaveHandler.setMusicVolume(value)
func _on_sfx_volume_slider_value_changed(value):
	SaveHandler.setSFXVolume(value)
func _on_return_button_up():
	if returnCallback == null:
		print("Menu hosting this settings panel does not set 'returnCallback' parameter of SettingsMenu node.")
	else:
		returnCallback.call()
		
