class_name skim_milk extends ShopItem

var cost : int = 3
var image_path : String = "res://assets/textures/items/item_skim_milk.png"
var name : String = "Skim Milk"
var description : String = "Increases max spins by one\n"

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
	var new_max_spin_count = GameManagerGlobal.spin_count + 1
	var new_spins_left = GameManagerGlobal.spins_left + 1
	GameManagerGlobal.modify_spin_count(new_max_spin_count)
	GameManagerGlobal.modify_spins_left(new_spins_left)
