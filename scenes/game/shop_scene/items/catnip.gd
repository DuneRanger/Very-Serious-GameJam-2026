class_name catnip extends ShopItem

var cost : int = 7
var image_path : String = "res://assets/textures/items/item_catnip.png"
var name : String = "Catnip"
var description : String = "SO YUMMY!\nAdds two Boosts\n"

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
	var new_boost_count = GameManagerGlobal.boost_count + 2
	GameManagerGlobal.modify_boost_count(new_boost_count)
