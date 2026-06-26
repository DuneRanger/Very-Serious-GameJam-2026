extends Control

class_name offered_item

var actual_item : ShopItem
var is_item_bought
var shop_id

func item_init(inner_item : ShopItem, new_id : int) -> void:
	#print("Loading image on path: ", new_image_path)
	actual_item = inner_item
	var new_image = load(actual_item.get_image_path())
	$Image.texture = new_image
	is_item_bought = false
	shop_id = new_id

func inner_item_apply_effect():
	actual_item.apply_effect()

func _on_button_button_down() -> void:
	if is_item_bought == false:
		GameManagerGlobal.signal_buy_item.emit(shop_id)

func get_item_cost() -> int:
	return actual_item.get_cost()

func remove_offer() -> void:
	$Image.visible = false
	is_item_bought = true
	$Button.disabled = true

func get_offered_item_text() -> String:
	var item_name = actual_item.get_name()
	var desc = actual_item.get_description()
	var cost = str(actual_item.get_cost())
	var out = item_name + "\n\n" + desc + "\n\nCost: " + cost + " rubies" 
	return out

func _on_focus_entered() -> void:
	GameManagerGlobal.signal_shop_start_hover.emit(shop_id)

func _on_focus_exited() -> void:
	GameManagerGlobal.signal_shop_stop_hover.emit()
