class_name ink extends ShopItem

var cost : int = 3
var image_path : String = "res://assets/textures/items/item_ink.png"
var name : String = "Ink"
var description : String = "Paint two red pockets black\n\n"

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
	var red_cells = []
	for cell in GameManagerGlobal.cells:
		if cell.colour == Color.RED:
			red_cells.append(cell)
	red_cells.shuffle()
	for i in range(2):
		if i < len(red_cells):
			red_cells[i].colour = Color.BLACK
	GameManagerGlobal.commit_cell_change.emit()
