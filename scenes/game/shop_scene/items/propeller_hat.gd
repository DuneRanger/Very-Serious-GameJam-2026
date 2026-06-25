extends ShopItem

class_name propeller_hat

var cost : int = 3
var image_path : String = "res://assets/textures/items/item_propeller_hat.png"
var name : String = "Propeller Hat"
var description : String = "Propells you :D"

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
	GameManagerGlobal.modify_boost_count(GameManagerGlobal.boost_count + 1)
