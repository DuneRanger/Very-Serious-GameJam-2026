extends Button

@export var button_id: int
var amount_bet : int

func _ready() -> void:
	add_theme_font_size_override("font_size", betting_system.get_font_size(button_id))
	$ChipAbove.texture = load("res://assets/textures/chips/chip_black.png")
	$ChipAbove.visible = false
	GameManagerGlobal.signal_change_amount_bet.connect(_on_change_amount)

func _on_change_amount(id : int, value : int):
	if (id != button_id and id != betting_system.all_buttons_id):
		#print("Caught from button: " + str(button_id) + ", returning")
		return
	#print("Caught from button: " + str(button_id) + ", doing")
	$ChipAbove.texture = betting_system.get_chip_texture(value)
	amount_bet = value
	if amount_bet == 0:
		$ChipAbove.visible = false
	else:
		$ChipAbove.visible = true

func _on_button_down() -> void:
	GameManagerGlobal.signal_placed_bet.emit(button_id)
