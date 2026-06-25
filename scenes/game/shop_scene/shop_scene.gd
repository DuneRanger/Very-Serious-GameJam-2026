extends Node2D

const offered_items_count : int = 3
var offered_items : Array
var offered_items_scene_instances : Array
var offered_items_scenes : Array

@export var offered_item_scene : PackedScene

var all_common_offered_items : Array[String] = [
	"res://scenes/game/shop_scene/items/propeller_hat.gd",
	"res://scenes/game/shop_scene/items/sunglasses.gd"
]

var all_rare_offered_items : Array[String] = [
	"res://scenes/game/shop_scene/items/dynamite.gd"
]

func _ready() -> void:
	refresh_shop()
	GameManagerGlobal.signal_buy_item.connect(_on_buy_item)

func refresh_shop() -> void:
	delete_old_items()
	generate_new_items()
	offer_items()

func generate_item() -> ShopItem:
	var random_roll = randf()
	var item_selection = all_rare_offered_items if (random_roll < 0.3) else all_common_offered_items
	var new_item_class_path = item_selection.pick_random()
	var new_item_class = load(new_item_class_path)
	var new_item = new_item_class.new()
	return new_item

func delete_old_items() -> void:
	for old_item in offered_items_scenes:
		$OfferedItemsHBox.remove_child(old_item)
	offered_items.clear()
	offered_items_scenes.clear()

func generate_new_items() -> void:
	print("Generating new items")
	for i in range(offered_items_count):
		var new_item = generate_item()
		offered_items.push_back(new_item)
		$OfferedItemsHBox.add_child(new_item)

func offer_items() -> void:
	for i in offered_items_count:
		var item = offered_items[i]
		#print("Making visual on item: ", item.get_name())
		var new_offered_item = offered_item_scene.instantiate()
		new_offered_item.set_id(i)
		#print("Visual: ", new_offered_item)
		new_offered_item.set_icon(item.get_image_path())
		#print("After icon: ", new_offered_item)
		$OfferedItemsHBox.add_child(new_offered_item)
		offered_items_scenes.push_back(new_offered_item)
	pass

func _on_buy_item(item_id : int):
	#print("Bought item: ", item_id)
	var item = offered_items[item_id]
	#print("Item: ", item)
	item.apply_effect()
	offered_items_scenes[item_id].remove_offer()
	$MrCat.play_money_anim()



func _on_fucking_awesome_refresh_button_button_down() -> void:
	refresh_shop()
