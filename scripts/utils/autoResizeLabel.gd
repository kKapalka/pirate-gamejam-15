@tool
class_name AutoResizeLabel extends Label

@export var minFontSize = 24
@export var currentFontSize = 56
@export var maxFontSize = 56

# It works somewhat. Resizes on its own to accomodate longer card names.
func onTextChanged():
	var font = get_theme_font("font")
	var line = TextLine.new()
	line.direction = text_direction
	line.flags = justification_flags
	line.alignment = horizontal_alignment
	for i in 20:
		line.clear()
		var created = line.add_string(text, font, currentFontSize)
		if created:
			var text_size = line.get_line_width()
			var multiplier = (int)(maxFontSize / currentFontSize)
			if text_size > (ceil(size.x + (10 - (20 * multiplier))) * multiplier):
				currentFontSize -= multiplier
			elif currentFontSize < maxFontSize:
				currentFontSize += multiplier
			else:
				break
		else:
			push_warning('Could not create a string')
			break			
	add_theme_font_size_override("font_size", currentFontSize)
