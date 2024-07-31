extends MarginContainer

const section_time := 2.0
const line_time := 0.5
const base_speed := 100
const speed_up_multiplier := 10.0
const title_color := Color.LIGHT_CORAL
const title_font_size := 40
const title_itch_io := 28

var scroll_speed := base_speed
var speed_up := false

@onready var line := $Control/Label
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"Squared Circle",
		"By Lost then Found"
	],[
		"Programmers",
		"Rethagos",
		"https://rethagos.itch.io",
		"Paulo Aparicio",
		"https://apita49.itch.io"
	],[
		"Artists",
		"Callum Atwell",
		"https://cattwell.itch.io",
		"Joseph McGowan",
		"https://joemunder.itch.io"
	],[
		"Story Writer",
		"Joseph McGowan",
		"https://joemunder.itch.io"
	],[
		"Composer",
		"Baelex",
		"https://baelex.itch.io"
	],[
		"QA Support",
		"David Parks",
		"",
		"Evan Vaughn",
		"Ads MacDonald"
	],[
		"Tools used",
		"Developed with Godot Engine",
		"https://godotengine.org/license"
	],[
		"Special thanks",
		"Thor for inspiring us"
	],[		
		"Pirate Software - Game Jam 15"
	],[
		"logo"
	]
	
]


func _process(delta):
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			if l == $Control/TextureRect:
				l.global_position.y -= scroll_speed
				if l.global_position.y < -l.size.y:
					lines.erase(l)
					l.queue_free()
			else:
				l.global_position.y -= scroll_speed
				if l.global_position.y < -l.get_line_height():
					lines.erase(l)
					l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		get_tree().change_scene_to_file("res://scenes/menus/mainmenu.tscn")


func add_line():
	var text = section.pop_front()
	if text == "logo":
		lines.append($Control/TextureRect)
		return
	var new_line = line.duplicate()
	new_line.text = text
	lines.append(new_line)
	if curr_line == 0:
		new_line.set("theme_override_colors/font_color",title_color)
		new_line.set("theme_override_font_sizes/font_size",title_font_size)
	elif  curr_line % 2 == 0:
		new_line.set("theme_override_font_sizes/font_size",title_itch_io)
	$Control.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
