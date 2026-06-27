class_name gigaburger extends ShopItem

var cost : int = 7
var image_path : String = "res://assets/textures/items/item_gigaburger.png"
var name : String = "Gigaburger"
var target_colour : Color
var description : String

func get_cost() -> int:
	return cost

func get_image_path() -> String:
	return image_path

func _init() -> void:
	target_colour = Color.RED if randi() % 2 else Color.BLACK
	description = "Increase the weight of all " + ("red" if target_colour == Color.RED else "black") + " pockets by one\n"
	return

func get_name() -> String:
	return name

func get_description() -> String:
	return description

func apply_effect() -> void:
	for cell in GameManagerGlobal.cells:
		if cell.colour == target_colour:
			cell.weight += 1
	GameManagerGlobal.commit_cell_change.emit()

func is_valid(_already_made_items : Array[ShopItem]) -> bool:
	return true
