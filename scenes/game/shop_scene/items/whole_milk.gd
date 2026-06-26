class_name whole_milk extends ShopItem

var cost : int = 7
var image_path : String = "res://assets/textures/items/item_whole_milk.png"
var name : String = "Whole Milk"
var description : String = "Adds 2 Max spins\n"

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
	var new_max_spin_count = GameManagerGlobal.spin_count + 2
	var new_spins_left = GameManagerGlobal.spins_left + 2
	GameManagerGlobal.modify_spin_count(new_max_spin_count)
	GameManagerGlobal.modify_spins_left(new_spins_left)
