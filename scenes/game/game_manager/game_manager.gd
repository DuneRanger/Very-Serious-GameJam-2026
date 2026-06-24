extends Node2D

var round_budget: int
var round_count: int
var money: int
var rubys: int
var spin_count: int
var spins_left: int
var boost_count: int
var boosts_left: int
var game_state : GameEnums.game_states
var bets : Dictionary
var caughtCells : Array[RouletteCell]

var caughtBalls : int

var single_bet_coeff : float = 20.0
var half_bet_coeff : float = 2.0
var third_bet_coeff : float = 3.0

signal signal_spin_count_change (amount : int)
signal signal_spins_left_change (amount : int)

signal signal_boost_count_change (amount : int)
signal signal_boosts_left_change (amount : int)

signal signal_modify_money (amount : int)
signal signal_modify_rubys (amount : int)
signal signal_state_change (amount : int)
signal signal_send_error_message(message : String)

const base_cell_weight : float = 1.0

func modify_boost_count (amount : int):
	print("modifiing", boost_count, amount)
	boost_count = amount
	signal_boost_count_change.emit()

func modify_boost_left (amount : int):
	print("modifiing", boosts_left, amount)
	boosts_left = amount
	signal_boosts_left_change.emit()
	
func modify_spin_count (amount : int):
	print("modifiing", spin_count, amount)
	spin_count = amount
	signal_spin_count_change.emit()

func modify_spins_left (amount : int):
	print("modifiing", spins_left, amount)
	spins_left = amount
	signal_spins_left_change.emit()

func modify_game_state (new_state : GameEnums.game_states):
	game_state = new_state
	signal_state_change.emit()

func modify_money (amount : int):
	money += amount
	signal_modify_money.emit()

func modify_rubys (amount : int):
	rubys += amount
	signal_modify_rubys.emit()
