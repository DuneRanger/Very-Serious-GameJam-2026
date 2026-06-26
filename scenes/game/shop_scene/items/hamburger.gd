class_name hamburger extends ShopItem

var cost : int = 3
var image_path : String = "res://assets/textures/items/item_hamburger.png"
var name : String = "Hamburger"
var target_number : int
var description : String

func get_cost() -> int:
	return cost

func get_image_path() -> String:
	return image_path

func _init() -> void:
	target_number = GameManagerGlobal.cells.pick_random().number
	description = "Increase the weight of all %d pockets by three\n" % target_number

func get_name() -> String:
	return name

func get_description() -> String:
	return description

func apply_effect() -> void:
	for cell in GameManagerGlobal.cells:
		if cell.number == target_number:
			cell.weight += 3
	GameManagerGlobal.commit_cell_change.emit()
