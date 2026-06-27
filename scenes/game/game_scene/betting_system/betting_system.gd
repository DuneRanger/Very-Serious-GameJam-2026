extends Node2D

@export var bet_button_scene: PackedScene
@export var bet_button_label: PackedScene
@export var background_width: float
@export var padding: float

@export var number_button_font_size : int
@export var third_button_font_size : int
@export var half_button_font_size : int

var labels = {}
var max_num : int = 24
var row_count : int = 3
var col_count : int = 8
var buttons : Array[Button] = []

var button_size : float
var background_height : float

var button_id = 0

func get_bet_type(id : int) -> GameEnums.bet_types:
	if id >= 0 && id <= max_num:
		return GameEnums.bet_types.NUMBER
	if id >= (max_num + 1) && id <= (max_num + 3):
		return GameEnums.bet_types.THIRD
	if id >= (max_num + 4) && id <= (max_num + 9):
		return GameEnums.bet_types.HALF
	else:
		return GameEnums.bet_types.HALF

func get_button_font_size(button_type : GameEnums.bet_types) -> int:
	match (button_type):
		GameEnums.bet_types.NUMBER:
			return number_button_font_size
		GameEnums.bet_types.HALF:
			return half_button_font_size
		GameEnums.bet_types.THIRD:
			return third_button_font_size
		_:
			return 10
		 

func get_button_id() -> int:
	var out = button_id
	button_id += 1
	return out

func make_buttons() -> void:
	var button_zero = bet_button_scene.instantiate()
	var button_zero_y_size = button_size * row_count + padding * (row_count - 1)
	button_zero.text = str(0)
	button_zero.init(button_size, button_zero_y_size, 0, 0, get_button_id())
	buttons.push_back(button_zero)
	add_child(button_zero)
	
	for i in range(max_num):
		var row = 1.0 * (i % row_count)
		var col = 1.0 * (i / row_count)
		@warning_ignore("integer_division")
		var col = 1 * (i / row_count)
		var new_button = bet_button_scene.instantiate()
		var new_pos_x = (button_size + padding) * (col + 1)
		var new_pos_y = (button_size + padding) * row
		
		var id = get_button_id()
		new_button.text = str(id)
		
		new_button.init(button_size, button_size, new_pos_x, new_pos_y, id)
		
		buttons.push_back(new_button)
		add_child(new_button)
	
	var thirds_col_len = 3
	var thirds_size_x = thirds_col_len * button_size + (thirds_col_len - 1) * padding
	var thirds_pos_y = (button_size + padding) * row_count

	
	var button_1st_third = bet_button_scene.instantiate()
	button_1st_third.text = "1 to 8"
	button_1st_third.init(thirds_size_x, button_size, 0, thirds_pos_y, get_button_id())
	buttons.push_back(button_1st_third)
	add_child(button_1st_third)
	
	var button_2nd_third = bet_button_scene.instantiate()
	button_2nd_third.text = "9 to 16"
	button_2nd_third.init(thirds_size_x, button_size, thirds_size_x + padding, thirds_pos_y, get_button_id())
	buttons.push_back(button_2nd_third)
	add_child(button_2nd_third)
	
	var button_3rd_third = bet_button_scene.instantiate()
	button_3rd_third.text = "17 to 24"
	button_3rd_third.init(thirds_size_x, button_size, (thirds_size_x + padding) * 2, thirds_pos_y, get_button_id())
	buttons.push_back(button_3rd_third)
	add_child(button_3rd_third)
	
	
	var last_row_size_x = (3 * button_size + padding) / 2
	var last_row_pos_y = (button_size + padding) * (row_count + 1)

	var button_1st_half = bet_button_scene.instantiate()
	button_1st_half.text = "1 to 12"
	button_1st_half.init(last_row_size_x, button_size, 0, last_row_pos_y, get_button_id())
	buttons.push_back(button_1st_half)
	add_child(button_1st_half)
	
	var button_2nd_half = bet_button_scene.instantiate()
	button_2nd_half.text = "13 TO 24"
	button_2nd_half.init(last_row_size_x, button_size, (last_row_size_x + padding) * 5, last_row_pos_y, get_button_id())
	buttons.push_back(button_2nd_half)
	add_child(button_2nd_half)	
	
	
	var button_even = bet_button_scene.instantiate()
	button_even.text = "EVEN"
	button_even.init(last_row_size_x, button_size, last_row_size_x + padding, last_row_pos_y, get_button_id())
	buttons.push_back(button_even)
	add_child(button_even)
	
	var button_odd = bet_button_scene.instantiate()
	button_odd.text = "ODD"
	button_odd.init(last_row_size_x, button_size, (last_row_size_x + padding) * 4, last_row_pos_y, get_button_id())
	buttons.push_back(button_odd)
	add_child(button_odd)	
	
	var button_red = bet_button_scene.instantiate()
	button_red.text = "RED"
	button_red.init(last_row_size_x, button_size, (last_row_size_x + padding) * 2, last_row_pos_y, get_button_id())
	buttons.push_back(button_red)
	add_child(button_red)	
	
	var button_black = bet_button_scene.instantiate()
	button_black.text = "BLACK"
	button_black.init(last_row_size_x, button_size, (last_row_size_x + padding) * 3, last_row_pos_y, get_button_id())
	buttons.push_back(button_black)
	add_child(button_black)	

func pad_all_buttons() -> void:
	var pad_vect = Vector2(padding, padding)
	for b in buttons:
		b.position += pad_vect

func connect_buttons() -> void:
	for b in buttons:
		b.placed_bet.connect(new_bet)

func set_button_size() -> void:
	for b in buttons:
		var button_type = get_bet_type(b.button_id)
		var b_font_size = get_button_font_size(button_type)
		b.add_theme_font_size_override("font_size", b_font_size)

func _ready() -> void:
	button_size = (background_width - padding * (col_count + 2)) / (col_count + 1)
	background_height = (row_count + 2) * button_size + (row_count + 3) * padding
	$Background.size = Vector2(background_width, background_height)
	make_buttons()
	pad_all_buttons()
	set_button_size()
	connect_buttons()

func get_label(b):
	var b_id = b.button_id
	if labels.has(b_id):
		return labels[b_id]
	var lab = bet_button_label.instantiate()
	lab.size = Vector2(button_size, button_size) * 2/3
	lab.position = b.position + (b.size - lab.size) / 2.0
	labels[b.button_id] = lab
	return lab

func new_bet(b_id : int) -> void:
	if GameManagerGlobal.game_state != GameEnums.game_states.BET_PHASE:
		return
	var b = buttons[b_id]
	
	var old_bet = GameManagerGlobal.bets.get(b_id, 0)
	
	var is_bet_adding = not (GameManagerGlobal.bet_is_adding == false || Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT))
	var is_bet_max = GameManagerGlobal.bet_is_max
	var bet_amount = GameManagerGlobal.bet_increment
	
	if is_bet_adding and is_bet_max:
		bet_amount = GameManagerGlobal.money
	elif is_bet_adding:
		bet_amount = bet_amount
	elif is_bet_max:
		bet_amount = - old_bet
	else:
		bet_amount = max(-bet_amount, -old_bet)
	
	if bet_amount > GameManagerGlobal.money:
		GameManagerGlobal.signal_send_error_message.emit("Not enough money!")
		return
	elif old_bet == 0 and bet_amount <= 0:
		GameManagerGlobal.signal_send_error_message.emit("Removing money on an empty bet!")
		return
	
	GameManagerGlobal.bets[b_id] = bet_amount + old_bet
	GameManagerGlobal.add_money(-bet_amount)
	
	if bet_amount > 0:
		SfxManager.play_SFX_pitched("res://assets/SFX/bet_remove.ogg")
	else:
		SfxManager.play_SFX_pitched("res://assets/SFX/bet_place.ogg")
	
	var l = get_label(b)
	
	if GameManagerGlobal.bets[b_id] > 0:
		if l.get_parent() == null:
			add_child(l)
	else:
		remove_child(l)

func clear_bets() -> void:
	for label_id in labels:
		var label = labels[label_id]
		if label.get_parent() != null:
			remove_child(label)
	labels.clear()
	GameManagerGlobal.bets.clear()
	
