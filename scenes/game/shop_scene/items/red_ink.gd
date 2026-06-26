class_name red_ink extends ShopItem

var cost : int = 3
var image_path : String = "res://assets/textures/items/item_red_ink.png"
var name : String ="Red Ink"
var description : String = "Paint two black pockets red\n\n"

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
	var black_cells = []
	for cell in GameManagerGlobal.cells:
		if cell.colour == Color.BLACK:
			black_cells.append(cell)
	black_cells.shuffle()
	for i in range(2):
		if i < len(black_cells):
			black_cells[i].colour = Color.RED
	GameManagerGlobal.commit_cell_change.emit()
