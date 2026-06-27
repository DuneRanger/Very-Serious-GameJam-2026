extends Node2D

var start_new_game : bool
var round_budget: int
var round_count: int
var evening_count: int
var quota: int
var money: int
var rubies: int
var spin_count: int
var spins_left: int
var boost_count: int
var boosts_left: int
var current_showed_scene : GameEnums.switching_scenes
var game_state : GameEnums.game_states
var bets : Dictionary
var caughtCells : Array[RouletteCell]

var initial_cells : Array[RouletteCell]
var cells : Array[RouletteCell] = []

var mr_cat_swag : bool

var single_bet_coeff : float = 24.0
var half_bet_coeff : float = 2.0
var third_bet_coeff : float = 3.0

var bet_increment : int
var bet_is_adding : bool
var bet_is_max : bool

var applying_boost : bool = false

signal signal_game_start
signal signal_can_continue_game
signal signal_cannot_continue_game
signal reset_roulette

signal on_boost (boost_amount : float)

signal signal_switch_scene (new_scene : GameEnums.switching_scenes)

signal signal_spin_count_change (amount : int)
signal signal_spins_left_change (amount : int)

signal signal_boost_count_change (amount : int)
signal signal_boosts_left_change (amount : int)

signal signal_modify_money (amount : int)
signal signal_modify_rubies (amount : int)

signal signal_add_money(amount : int)
signal signal_add_rubies(amount : int)
signal signal_add_roulette_ball

signal signal_state_change (amount : int)
signal signal_send_error_message(message : String)

signal signal_buy_item (id : int)
signal commit_cell_change

signal signal_shop_start_hover (id : int)
signal signal_shop_stop_hover
signal signal_refresh_shop

signal signal_mr_cat_swag
signal signal_quota_message
signal signal_death_screen

signal signal_increment_change
signal signal_bet_is_adding_change
signal signal_bet_max_change

signal signal_endless_mode

var round_shop_reroll_count : int

var shop_max_spin_change : bool
var shop_left_spin_change : bool
var shop_max_boost_change : bool
var shop_left_boost_change : bool

# index 0 - 24 = numbers 0 - 24
# [25] = "1 to 8", [26] = "9 to 16", [27] = "17 to 24"
# [28] = "1 to 12", [29] = "13 to 24"
# [30] = "even", [31] = "odd"
# [32] = "red", [33] = "black"
var bet_id_multipliers : Array[float] = []


func game_start():
	GameManagerGlobal.modify_money(100)
	GameManagerGlobal.modify_rubies(100)
	GameManagerGlobal.modify_boost_count(2)
	GameManagerGlobal.modify_boost_left(2)
	GameManagerGlobal.modify_spin_count(3)
	GameManagerGlobal.modify_spins_left(3)
	GameManagerGlobal.round_count = 0
	mr_cat_swag = false
	GameManagerGlobal.modify_game_state(GameEnums.game_states.BET_PHASE)
	
	shop_max_spin_change = false
	shop_left_spin_change = false
	shop_max_boost_change = false
	shop_left_boost_change = false
	
	round_shop_reroll_count = 0
	
	bet_increment = 1
	bet_is_adding = true
	bet_is_max = false
	signal_increment_change.emit()
	signal_bet_is_adding_change.emit()
	signal_bet_max_change.emit()
	
	for i in range(GameEnums.bet_button_count):
		bet_id_multipliers.append(1.0)
	
	signal_game_start.emit()


signal signal_round_start

const base_cell_weight : float = 1.0

var current_quota_message : String
var quota_messages : Array[String] = [
	"food",
	"water",
	"health insurance",
	"rent",
	"a Catflix subscription",
	"cancelling your Pawdobe subscription", 
	"paying your debt to the mafia", #this is the max amount of characters thet looks good
	"taxes",
	"paying fines for bad parking",
	"car repairs",
	"a lifesaving operation",
	"your fiancées ring",
	"a haircut",
	"a new videogame",
	"catnip",
	"Catman comics",
	"the newest catphone",
	"starting a business",
	"a rabies vaccine",
]

func modify_boost_count (amount : int):
	boost_count = amount
	if current_showed_scene == GameEnums.switching_scenes.GAME_SCENE:
		signal_boost_count_change.emit()
	else:
		shop_max_boost_change = true

func modify_boost_left (amount : int):
	boosts_left = amount
	if current_showed_scene == GameEnums.switching_scenes.GAME_SCENE:
		signal_boosts_left_change.emit()
	else:
		shop_left_boost_change = true
	
func modify_spin_count (amount : int):
	spin_count = amount
	if current_showed_scene == GameEnums.switching_scenes.GAME_SCENE:
		signal_spin_count_change.emit()
	else:
		shop_max_spin_change = true

func modify_spins_left (amount : int):
	spins_left = amount
	if current_showed_scene == GameEnums.switching_scenes.GAME_SCENE:
		signal_spins_left_change.emit()
	else:
		shop_left_spin_change = true

func modify_game_state (new_state : GameEnums.game_states):
	game_state = new_state
	signal_state_change.emit()

func modify_money (amount : int):
	money = amount
	signal_modify_money.emit()

func modify_rubies (amount : int):
	rubies = amount
	signal_modify_rubies.emit()

func add_money (amount : int):
	money += amount
	signal_add_money.emit(amount)

func add_rubies (amount : int):
	rubies += amount
	signal_add_rubies.emit(amount)

func check_shop_change():
	if shop_max_spin_change:
		modify_spin_count(min (spin_count, GameEnums.total_max_spin_count))
		shop_max_spin_change = false
	if shop_left_spin_change:
		modify_spins_left(min (spins_left, GameEnums.total_max_spin_count, spin_count))
		shop_left_spin_change = false
	if shop_max_boost_change:
		modify_boost_count(min (boost_count, GameEnums.total_max_boost_count))
		shop_max_boost_change = false
	if shop_left_boost_change:
		modify_boost_left(min (boosts_left, GameEnums.total_max_boost_count, boost_count))
		shop_left_boost_change = false
