class_name bet_button extends Button

const base_color : Color = Color.GREEN
const red_color : Color = Color.DARK_RED
const black_color : Color = Color.BLACK

@export var button_id: int
var amount_bet : int

func set_color(new_color : Color):
	var stylebox : StyleBoxFlat = StyleBoxFlat.new()
	stylebox.bg_color = new_color
	add_theme_stylebox_override("normal", stylebox)
	add_theme_stylebox_override("hover_pressed", stylebox)
	add_theme_stylebox_override("hover", stylebox)
	add_theme_stylebox_override("pressed", stylebox)

func _on_cells_change():
	if betting_system.get_bet_type(button_id) != GameEnums.bet_types.NUMBER:
		return
	if GameManagerGlobal.red_cell_counts[button_id] > 0:
		print("Changing color of field: ", button_id, " to red")
		set_color(red_color)
	elif GameManagerGlobal.black_cell_counts[button_id] > 0:
		print("Changing color of field: ", button_id, " to black")
		set_color(black_color)
	else:
		print("Changing color of field: ", button_id, " to gree")
		set_color(base_color)

func _ready() -> void:
	add_theme_font_size_override("font_size", betting_system.get_font_size(button_id))
	$ChipAbove.texture = load("res://assets/textures/chips/chip_black.png")
	$ChipAbove.visible = false
	$BetValueLabel.visible = false
	set_color(base_color)
	GameManagerGlobal.signal_change_amount_bet.connect(_on_change_amount)
	GameManagerGlobal.signal_commit_cell_change_finished.connect(_on_cells_change)

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
	_on_mouse_entered()

func _on_button_down() -> void:
	GameManagerGlobal.signal_placed_bet.emit(button_id)

func _on_mouse_entered() -> void:
	print("Showing value on: ", button_id)
	if amount_bet > 0:
		$BetValueLabel.visible = true


func _on_mouse_exited() -> void:
	print("Hiding value on: ", button_id)
	$BetValueLabel.visible = false
