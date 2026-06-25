extends Node2D

const offered_items_count : int = 3
const rare_item_chance : float = 0.3
var offered_items : Array
var offered_items_scene_instances : Array
var offered_items_scenes : Array

@export var offered_item_scene : PackedScene

var all_common_offered_items : Array[String] = [
	"res://scenes/game/shop_scene/items/propeller_hat.gd",
	"res://scenes/game/shop_scene/items/sunglasses.gd",
	"res://scenes/game/shop_scene/items/ink.gd",
	"res://scenes/game/shop_scene/items/red_ink.gd",
	"res://scenes/game/shop_scene/items/hamburger.gd"
]

var all_rare_offered_items : Array[String] = [
	"res://scenes/game/shop_scene/items/dynamite.gd",
	"res://scenes/game/shop_scene/items/gigaburger.gd"
]

func _ready() -> void:
	refresh_shop()
	$DescriptionLabel.visible = false
	GameManagerGlobal.signal_buy_item.connect(_on_buy_item)
	GameManagerGlobal.signal_shop_start_hover.connect(_on_focus_entered)
	GameManagerGlobal.signal_shop_stop_hover.connect(_on_focus_exited)

func refresh_shop() -> void:
	delete_old_items()
	generate_new_items()
	offer_items()

func generate_item() -> ShopItem:
	var new_item
	#while true:
	var random_roll = randf()
	var item_selection = all_rare_offered_items if (random_roll < rare_item_chance) else all_common_offered_items
	var new_item_class_path = item_selection.pick_random()
	var new_item_class = load(new_item_class_path)
	new_item = new_item_class.new()	
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

func _on_focus_entered(button_id : int):
	var item = offered_items[button_id]
	var text = get_offered_item_text(item)
	$DescriptionLabel.text = text
	$DescriptionLabel.visible = true

func _on_focus_exited():
	print($DescriptionLabel.position)
	$DescriptionLabel.text = ""
	$DescriptionLabel.visible = false

func get_offered_item_text(item : ShopItem) -> String:
	var out = item.get_name() + "\n\n" + item.get_description() + "\n\nCost: " + str(item.get_cost()) + " rubies" 
	return out
	
