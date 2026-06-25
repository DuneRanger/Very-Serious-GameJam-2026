extends Node2D

const offered_items_count : int = 3
var offered_items : Array
var offered_items_scene_instances : Array

@export var offered_item_scene : PackedScene

var all_offered_items : Array[String] = [
	"res://scenes/game/shop_scene/items/propeller_hat.gd",
	"res://scenes/game/shop_scene/items/sunglasses.gd"
]

func _ready() -> void:
	generate_items()
	offer_items()
	GameManagerGlobal.signal_buy_item.connect(_on_buy_item)

func generate_items() -> void:
	print("Generating")
	for old_item in offered_items_scene_instances:
		print("Removing")
		$OfferedItemsHBox.remove_child(old_item)
	
	offered_items_scene_instances.clear()
	offered_items.clear()
	for i in range(offered_items_count):
		print("Making new items!")
		var new_item_class_path = all_offered_items.pick_random()
		var new_item_class = load(new_item_class_path)
		var new_item = new_item_class.new()
		print(new_item.get_name())
		offered_items.push_back(new_item)

func offer_items() -> void:
	for i in offered_items_count:
		var item = offered_items[i]
		print("Making visual on item: ", item.get_name())
		var new_offered_item = offered_item_scene.instantiate()
		new_offered_item.set_id(i)
		print("Visual: ", new_offered_item)
		new_offered_item.set_icon(item.get_image_path())
		print("After icon: ", new_offered_item)
		$OfferedItemsHBox.add_child(new_offered_item)
	pass

func _on_buy_item(item_id : int):
	print("Bought item: ", item_id)
	var item = offered_items[item_id]
	print("Item: ", item)
	item.apply_effect()

	
