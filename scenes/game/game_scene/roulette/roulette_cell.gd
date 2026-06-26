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

static func get_colour_string(_colour : Color):
	match _colour:
		Color.RED: return "red"
		Color.BLACK: return "black"
		Color.DARK_GREEN: return "green"
		_: return "unknown colour"


func _to_string() -> String:
	var out = get_colour_string(colour) + " " + str(number)
	return out
