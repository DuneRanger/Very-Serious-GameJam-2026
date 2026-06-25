class_name ink extends ShopItem

var cost : int = 3
var image_path : String = "res://assets/textures/items/item_ink.png"
var name : String = "Ink"
var description : String
var target_cell : RouletteCell

func select_target_cell():
	target_cell = RouletteCell.new(1, Color.RED, 1.0)

func get_cost() -> int:
	return cost

func get_image_path() -> String:
	return image_path

func _init() -> void:
	select_target_cell()
	description = "Paints a " + str(target_cell) + " to black."
	return

func get_name() -> String:
	return name

func get_description() -> String:
	return description

func apply_effect() -> void:
	print("But imagine it worked no")
