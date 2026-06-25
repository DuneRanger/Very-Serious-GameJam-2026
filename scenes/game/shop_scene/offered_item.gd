extends Control

class_name offered_item

var is_item_bought
var shop_id

func set_icon(new_image_path : String) -> void:
	#print("Loading image on path: ", new_image_path)
	var new_image = load(new_image_path)
	#print("Some bullshit: ", new_image)
	$Image.texture = new_image
	is_item_bought = false

func set_id(new_id : int):
	shop_id = new_id

func _on_button_button_down() -> void:
	if is_item_bought == false:
		GameManagerGlobal.signal_buy_item.emit(shop_id)

func remove_offer() -> void:
	$Image.visible = false
	is_item_bought = true
	$Button.disabled = true

func _on_focus_entered() -> void:
	GameManagerGlobal.signal_shop_start_hover.emit(shop_id)

func _on_focus_exited() -> void:
	GameManagerGlobal.signal_shop_stop_hover.emit()
