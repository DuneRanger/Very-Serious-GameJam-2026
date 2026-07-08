class_name bet_button extends Button

const base_color : Color = Color("326e2dff")
const red_color : Color = Color("d13030ff")
const black_color : Color = Color("000000ff")

var stylebox : StyleBoxFlat = null

@export var button_id: int
var amount_bet : float

func make_stylebox():
	stylebox = StyleBoxFlat.new()
	stylebox.border_color = Color("#ffffff00")
	stylebox.border_width_bottom = 2
	stylebox.border_width_top = 2
	stylebox.border_width_right = 2
	stylebox.border_width_left = 2
	add_theme_stylebox_override("normal", stylebox)
	add_theme_stylebox_override("hover_pressed", stylebox)
	add_theme_stylebox_override("hover", stylebox)
	add_theme_stylebox_override("pressed", stylebox)

func _on_cells_change():
	if button_id == GameEnums.max_roulette_num + 8:
		stylebox.bg_color = red_color
	if button_id == GameEnums.max_roulette_num + 9:
		stylebox.bg_color = black_color
	if betting_system.get_bet_type(button_id) != GameEnums.bet_types.NUMBER:
		return
	
	if GameManagerGlobal.red_cell_counts[button_id] > 0:
		print("Changing color of field: ", button_id, " to red")
		stylebox.bg_color = red_color
	elif GameManagerGlobal.black_cell_counts[button_id] > 0:
		print("Changing color of field: ", button_id, " to black")
		stylebox.bg_color = black_color
	else:
		print("Changing color of field: ", button_id, " to gree")
		stylebox.bg_color = base_color

func _ready() -> void:
	make_stylebox()
	add_theme_font_size_override("font_size", betting_system.get_font_size(button_id))
	$ChipAbove.texture = load("res://assets/textures/chips/chip_black.png")
	$ChipAbove.visible = false
	$BetValueLabel.visible = false
	
	stylebox.bg_color = base_color
	GameManagerGlobal.signal_change_amount_bet.connect(_on_change_amount)
	GameManagerGlobal.signal_commit_cell_change_finished.connect(_on_cells_change)

func _on_change_amount(id : int, value : float):
	if (id != button_id and id != betting_system.all_buttons_id):
		return
	$ChipAbove.texture = betting_system.get_chip_texture(value)
	amount_bet = value
	if amount_bet != 0:
		$ChipAbove.visible = true
		_on_mouse_entered()
	else:
		$ChipAbove.visible = false
		_on_mouse_exited()

func _on_button_down() -> void:
	GameManagerGlobal.signal_placed_bet.emit(button_id)

func _on_mouse_entered() -> void:
	if amount_bet > 0:
		print("Showing value on: ", button_id)
		$BetValueLabel.text = "[bgcolor=dim_gray]" + GameEnums.format_num(amount_bet) + "[/bgcolor]"
		$BetValueLabel.z_index = 100
		$BetValueLabel.visible = true


func _on_mouse_exited() -> void:
	print("Hiding value on: ", button_id)
	$BetValueLabel.visible = false
