class_name gigaburger extends ShopItem

var cost : int = 7
var image_path : String = "res://assets/textures/items/item_gigaburger.png"
var name : String = "Gigaburger"
var description : String = "MMMMMMM GIGAburger"

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
