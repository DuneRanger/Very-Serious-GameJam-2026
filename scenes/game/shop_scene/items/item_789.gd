extends ShopItem

class_name item_789

var cost : int = 7
var image_path : String = "res://assets/textures/items/item_789.png"
var name : String = "7 8 9"
var description : String = "Change all number 9 pockets into 7"

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
	for cell in GameManagerGlobal.cells:
		if cell.number == 9: cell.number = 7
	GameManagerGlobal.commit_cell_change.emit()
