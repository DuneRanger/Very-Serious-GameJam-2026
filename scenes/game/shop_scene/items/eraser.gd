extends ShopItem

class_name eraser

var cost : int = 4
var image_path : String = "res://assets/textures/items/item_eraser.png"
var name : String = "Eraser"
var description : String
var target_cell : RouletteCell

func get_cost() -> int:
	return cost

func get_image_path() -> String:
	return image_path

func _init() -> void:
	target_cell = GameManagerGlobal.cells.pick_random()
	while target_cell.colour == Color.DARK_GREEN: target_cell = GameManagerGlobal.cells.pick_random()
	description = "Remove a %s from the roulette\n" %str(target_cell)

func get_name() -> String:
	return name

func get_description() -> String:
	return description

func apply_effect() -> void:
	GameManagerGlobal.cells.erase(target_cell)
	GameManagerGlobal.commit_cell_change.emit()

func is_valid(already_made_items : Array[ShopItem]) -> bool:
	return len(GameManagerGlobal.cells) > 4
