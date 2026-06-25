extends ShopItem

class_name dynamite

var cost : int = 7
var image_path : String = "res://assets/textures/items/item_dynamite.png"
var name : String = "Dynamite"
var description : String = "Destroy 25% of the pockets on the roulette (rounded down)"

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
	var cell_count = len(GameManagerGlobal.cells)
	var remove_count = floor(cell_count / 4)
	var removal_indices = []
	for i in range(remove_count):
		removal_indices.append(randi_range(0, cell_count - 1 - i))
	for idx in removal_indices:
		GameManagerGlobal.cells.remove_at(idx)
	GameManagerGlobal.commit_cell_change.emit()
