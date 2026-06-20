extends Node2D

@onready var boost_indicator: ColorRect = $bar/outer/inner/boost_indicator

func _on_boost_bar_button_pressed() -> void:
	var boost_modifier = boost_indicator.scale.y
	print(boost_modifier)
