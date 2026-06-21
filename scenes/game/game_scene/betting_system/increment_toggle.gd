extends Button

var adding : bool
var adding_text = "+"
var removing_text = "-"

func _ready() -> void:
	adding = true
	text = adding_text
	
func _on_button_down() -> void:
	adding = !adding
	if adding:
		text = adding_text
	else:	
		text = removing_text
