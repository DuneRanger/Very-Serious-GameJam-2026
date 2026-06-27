class_name supercell extends ShopItem

var cost : int = 7
var image_path : String = "res://assets/textures/items/item_supercell.png"
var name : String = "Super Cell"
var target_number : int
var description : String

func get_cost() -> int:
	return cost

func get_image_path() -> String:
	return image_path

func _init() -> void:
	target_number = GameManagerGlobal.cells.pick_random().number
	description = "Increase the weight of a single number %d pocket by three" % target_number

func get_name() -> String:
	return name

func get_description() -> String:
	return description

func apply_effect() -> void:
	for cell in GameManagerGlobal.cells:
		if cell.number == target_number:
			cell.weight += 3
			break
	GameManagerGlobal.commit_cell_change.emit()

func is_valid(_already_made_items : Array[ShopItem]) -> bool:
	return true
