class_name exercise extends ShopItem

var cost : int = 4
var image_path : String = "res://assets/textures/items/item_exercise.png"
var name : String = "Exercise"
var description : String = "Lose one max boost, but gain a 1.2x multiplier on all future spins\n"

func get_cost() -> int:
	return cost

func get_image_path() -> String:
	return image_path

func _init() -> void:
	return

func get_name() -> String:
	return name

func get_description() -> String:
	return description

func apply_effect() -> void:
	var new_boost_count = max(0, GameManagerGlobal.boost_count - 1)
	GameManagerGlobal.modify_boost_count(new_boost_count)
	for mult in GameManagerGlobal.bet_id_multipliers:
		mult *= 1.2

func is_valid(already_made_items : Array[ShopItem]) -> bool:
	return GameManagerGlobal.boost_count > 0
