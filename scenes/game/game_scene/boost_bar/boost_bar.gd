extends Node2D

var boost_modifier
@onready var boost_indicator: ColorRect = $bar/inner/boost_indicator

func _ready() -> void:
	visible = false

func _on_button_pressed() -> void:
	boost_modifier = boost_indicator.scale.y
	print(boost_modifier)
