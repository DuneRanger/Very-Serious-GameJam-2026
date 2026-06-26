extends Node2D

const offered_items_count : int = 3
const rare_item_chance : float = 0.3
var offered_items : Array

@export var offered_item_scene : PackedScene

var all_common_offered_items : Array[String] = [
	"res://scenes/game/shop_scene/items/propeller_hat.gd",
	"res://scenes/game/shop_scene/items/sunglasses.gd",
	"res://scenes/game/shop_scene/items/ink.gd",
	"res://scenes/game/shop_scene/items/red_ink.gd",
	"res://scenes/game/shop_scene/items/hamburger.gd",
	"res://scenes/game/shop_scene/items/skim_milk.gd"
]

var all_rare_offered_items : Array[String] = [
	"res://scenes/game/shop_scene/items/dynamite.gd",
	"res://scenes/game/shop_scene/items/gigaburger.gd",
	"res://scenes/game/shop_scene/items/catnip.gd",
	"res://scenes/game/shop_scene/items/whole_milk.gd"
]

func _ready() -> void:
	refresh_shop()
	$DescriptionLabel.visible = false
	GameManagerGlobal.signal_modify_rubies.connect(modify_rubies)
	GameManagerGlobal.signal_add_rubies.connect(add_rubies)
	GameManagerGlobal.signal_buy_item.connect(_on_buy_item)
	GameManagerGlobal.signal_shop_start_hover.connect(_on_focus_entered)
	GameManagerGlobal.signal_shop_stop_hover.connect(_on_focus_exited)

func get_inner_items() -> Array[ShopItem]:
	var out : Array[ShopItem] = []
	for item in offered_items:
		out.push_back(item.actual_item)
	return out

func refresh_shop() -> void:
	delete_old_items()
	generate_new_items()

func generate_inner_item() -> ShopItem:
	var new_item
	#while true:
	var random_roll = randf()
	var item_selection = all_rare_offered_items if (random_roll < rare_item_chance) else all_common_offered_items
	var new_item_class_path = item_selection.pick_random()
	var new_item_class = load(new_item_class_path)
	new_item = new_item_class.new()	
	return new_item

func delete_old_items() -> void:
	for old_item in offered_items:
		$OfferedItemsHBox.remove_child(old_item)
	offered_items.clear()

func is_item_non_duplicate(inner_new_item : ShopItem) -> bool:
	for old_item in offered_items:
		var inner_old_item = old_item.actual_item
		if inner_new_item.get_name() == inner_old_item.get_name():
			print("Same items:")
			print("Old item: ", inner_old_item.get_class())
			print("New item: ", inner_new_item.get_class())
			return false
	return true

func generate_new_items() -> void:
	print("Generating new items")
	var i = 0
	while offered_items.size() < offered_items_count:
		var new_item_inner = generate_inner_item()
		var new_item = offered_item_scene.instantiate()
		new_item.item_init(new_item_inner, i)
		print("Tried making item: ", new_item_inner.get_name())
		if new_item.is_item_valid(get_inner_items()) and is_item_non_duplicate(new_item_inner):
			print("Made item with id: ", i)
			offered_items.push_back(new_item)
			$OfferedItemsHBox.add_child(new_item)
			i += 1

func _on_buy_item(item_id : int):
	var item = offered_items[item_id]
	var cost = item.get_item_cost()
	if GameManagerGlobal.rubies >= cost:
		item.inner_item_apply_effect()
		offered_items[item_id].remove_offer()
		GameManagerGlobal.add_rubies(-cost)
		print("Removing %d from rubies" %-(cost))
		$MrCat.play_money_anim()
		$DescriptionLabel.text = ""
		$DescriptionLabel.visible = false
	else:
		$DescriptionLabel.text = "Not Enough Rubies!!!"

func _on_fucking_awesome_refresh_button_button_down() -> void:
	refresh_shop()

func _on_focus_entered(button_id : int):
	var item = offered_items[button_id]
	var text = item.get_offered_item_text()
	$DescriptionLabel.text = text
	$DescriptionLabel.visible = true

func _on_focus_exited():
	$DescriptionLabel.text = ""
	$DescriptionLabel.visible = false

	
func modify_rubies():
	$RubyLabel.set_value(GameManagerGlobal.rubies)

func add_rubies(amount : int):
	print("I am in add rubies, amount: ", amount)
	print("Count on gmm: ", GameManagerGlobal.rubies)
	modify_rubies()
	$RubyLabel.set_diff(amount)
