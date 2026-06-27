@abstract class_name ShopItem extends Object

@abstract func _init() -> void

@abstract func get_cost() -> int

@abstract func get_image_path() -> String

@abstract func get_name() -> String

@abstract func get_description() -> String

@abstract func apply_effect() -> void

@abstract func is_valid(_already_made_items : Array[ShopItem]) -> bool
