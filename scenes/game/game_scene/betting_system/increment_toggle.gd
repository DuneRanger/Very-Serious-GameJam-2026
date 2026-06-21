extends Button

var adding : bool
@export var increment_state_color_adding : Color
@export var increment_state_color_removing : Color

func _ready() -> void:
	adding = true
	$ColorRect.color = increment_state_color_adding

func _on_button_down() -> void:
	adding = !adding
	if adding:
		$ColorRect.color = increment_state_color_adding
	else:	
		$ColorRect.color = increment_state_color_removing
