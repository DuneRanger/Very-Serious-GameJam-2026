extends Node2D

var round_budget: int
var round_count: int
var money: int
var rubys: int
var spins: int
var boosts: int
var game_state : GameEnums.game_states
var bets : Dictionary
var caughtCells : Array[RouletteCell]

var caughtBalls : int

var single_bet_coeff : float = 20.0
var half_bet_coeff : float = 2.0
var third_bet_coeff : float = 3.0

signal money_change
signal ruby_change
signal state_change
signal send_error_message(message : String)

const base_cell_weight : float = 1.0

func modify_money (amount : int):
	money += amount
	money_change.emit()

func modify_rubys (amount : int):
	rubys += amount
	ruby_change.emit()
