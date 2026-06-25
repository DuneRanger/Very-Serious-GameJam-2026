extends Control

class_name offered_item

var shop_id

func set_icon(new_image_path : String) -> void:
	print("Loading image on path: ", new_image_path)
	var new_image = load(new_image_path)
	print("Some bullshit: ", new_image)
	$Image.texture = new_image

func set_id(new_id : int):
	shop_id = new_id

func _on_button_button_down() -> void:
	GameManagerGlobal.signal_buy_item.emit(shop_id)
