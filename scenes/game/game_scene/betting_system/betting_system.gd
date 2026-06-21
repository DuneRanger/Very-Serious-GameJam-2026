extends Node2D

@export var bet_button_scene: PackedScene
@export var button_size: float
@export var padding: float

var bets = {}
var max_num : int = 24
var row_count : int = 3
var col_count : int = 8
var increment = 1
var buttons : Array[Button] = []

var game_manager;

var button_id = 0

enum button_type {NUMBER, COLOR, HALF, THIRD}

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

func resize_background() -> void:
	$Background.size.x = button_size * 9 + padding * 10
	$Background.size.y = button_size * 6 + padding * 7
	$Background.position.x = -padding
	$Background.position.y = -padding

func connect_buttons() -> void:
	for b in buttons:
		b.button_down.connect(new_bet)

func _ready() -> void:
	make_buttons()
	connect_buttons()
	resize_background()
	

func _process(delta: float) -> void:
	pass

func new_bet() -> void:
	var pressed_buttons = []
	for b in buttons:
		if b.to_process:
			pressed_buttons.push_back(b)
			b.to_process = false
			
	for b in pressed_buttons:
		if increment > game_manager.money:
			print("Not enough money!")
			continue
			
		var old_bet = bets.get(b.button_id, 0)
		print("Old bet on: ", b.button_id, " is: ", old_bet)
		var new_bet = old_bet + increment
		bets[b.button_id] = new_bet
		game_manager.money -= increment
		print("Current bet on: ", b.button_id, " is: ", bets[b.button_id])
