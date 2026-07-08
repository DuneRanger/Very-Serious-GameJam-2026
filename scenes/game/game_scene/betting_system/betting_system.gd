class_name betting_system extends Control

static var number_button_font_size : int = 22
static var third_button_font_size : int = 24
static var half_button_font_size : int = 13

static var texture_chip_black : Texture2D = load("res://assets/textures/chips/chip_black.png")
static var texture_chip_red : Texture2D = load("res://assets/textures/chips/chip_red.png")
static var texture_chip_blue : Texture2D = load("res://assets/textures/chips/chip_blue.png")
static var texture_chip_yellow : Texture2D = load("res://assets/textures/chips/chip_yellow.png")

const chip_black_requirement : float = 0.0
const chip_red_requirement : float = 50.0
const chip_blue_requirement : float = 200.0
const chip_yellow_requirement : float = 1000.0

const all_buttons_id : int = 12345678

const max_num : int = 24
const row_count : int = 3
const col_count : int = 8

static func get_font_size(id : int) -> int:
	var bet_type : GameEnums.bet_types = get_bet_type(id)
	match bet_type:
		GameEnums.bet_types.NUMBER:
			return number_button_font_size
		GameEnums.bet_types.THIRD:
			return third_button_font_size
		_:
			return half_button_font_size

static func get_bet_type(id : int) -> GameEnums.bet_types:
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

func _ready() -> void:
	GameManagerGlobal.signal_placed_bet.connect(new_bet)

static func get_chip_texture(value : float) -> Texture2D:
	print("Selecting icon, value: ", value)
	if value >= chip_yellow_requirement:
		print("Selected yellow")
		return texture_chip_yellow
	elif value >= chip_blue_requirement:
		print("Selected blue")
		return texture_chip_blue
	elif value >= chip_red_requirement:
		print("Selected red")
		return texture_chip_red
	else:
		print("Selected black")
		return texture_chip_black

func new_bet(button_id : int) -> void:
	if GameManagerGlobal.game_state != GameEnums.game_states.BET_PHASE:
		return
	
	var old_bet = GameManagerGlobal.bets.get(button_id, 0.0)
	
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
	elif old_bet == 0.0 and bet_amount <= 0.0:
		GameManagerGlobal.signal_send_error_message.emit("Cannot remove money from an empty bet!")
		return
	
	GameManagerGlobal.bets[button_id] = bet_amount + old_bet
	GameManagerGlobal.add_money(-bet_amount)
	
	if bet_amount > 0:
		SfxManager.play_SFX_pitched("res://assets/SFX/bet_remove.ogg")
	else:
		SfxManager.play_SFX_pitched("res://assets/SFX/bet_place.ogg")
	
	GameManagerGlobal.signal_change_amount_bet.emit(button_id, bet_amount + old_bet)

func clear_bets() -> void:
	GameManagerGlobal.signal_change_amount_bet.emit(all_buttons_id, 0.0)
	GameManagerGlobal.bets.clear()
	
