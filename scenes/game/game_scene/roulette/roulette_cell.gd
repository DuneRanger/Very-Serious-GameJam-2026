class_name RouletteCell
extends RefCounted

enum Modifier {NONE, STICKY, SHINY}

const base_cell_weight : float = 1.0

var number : int
var colour : Color
var weight : float
var modifier : Modifier = Modifier.NONE

# Assigned after Roulette.build_banks().
var bank : RouletteBank

func _init(num: int, col: Color, w: float = base_cell_weight) -> void:
	number = num
	colour = col
	weight = w

func _to_string() -> String:
	var color_str = "red" if (colour == Color.RED) else "black"
	var out = color_str + " " + str(number)
	return out
