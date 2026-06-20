extends Node2D

var boost_modifier
@onready var boost_indicator: ColorRect = $bar/outer/inner/boost_indicator

func _on_boost_bar_button_pressed() -> void:
	boost_modifier = boost_indicator.scale.y
	print(boost_modifier)
