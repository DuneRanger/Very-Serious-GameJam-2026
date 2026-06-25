class_name pencil extends ShopItem

var cost : int = 3
var image_path : String = "res://assets/textures/items/pencil.png"
var name : String = "Pencil"
var description : String 
var new_cell : RouletteCell

func make_cell():
	var cell_num = randf_range(1, 24)
	new_cell = RouletteCell.new(cell_num, Color.RED, 1.0)

func get_cost() -> int:
	return cost

func get_image_path() -> String:
	return image_path

func _init() -> void:
	make_cell()
	description = "Adds a " + str(new_cell) + " the roullete."

func get_name() -> String:
	return name

func get_description() -> String:
	return description

func apply_effect() -> void:
	print("But imagine it worked no")
