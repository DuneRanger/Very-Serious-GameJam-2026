class_name hamburger extends ShopItem

var cost : int = 3
var image_path : String = "res://assets/textures/items/item_hamburger.png"
var name : String = "Hamburger"
var description : String = "MMM Hamburger"

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
	print("But imagine it worked no")
