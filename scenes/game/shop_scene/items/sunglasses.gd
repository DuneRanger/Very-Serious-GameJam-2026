extends ShopItem

class_name sunglasses

var cost : int = 1
var image_path : String = "res://assets/textures/items/item_sunglasses.png"
var name : String = "Sunglasses"
var description : String = "+1 swag"

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
	GameManagerGlobal.signal_mr_cat_swag.emit()
