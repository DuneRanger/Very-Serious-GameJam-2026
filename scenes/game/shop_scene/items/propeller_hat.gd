extends ShopItem

class_name propeller_hat

var cost : int = 3
var image_path : String = "res://assets/textures/items/item_propeller_hat.png"
var name : String = "Propeller Hat"
var description : String = "Propells you :D\nIncreases max boosts by one\n"

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
	var new_boost_count = GameManagerGlobal.boost_count + 1
	var new_boosts_left = GameManagerGlobal.boosts_left + 1
	GameManagerGlobal.modify_boost_count(new_boost_count)
	GameManagerGlobal.modify_boost_left(new_boosts_left)
