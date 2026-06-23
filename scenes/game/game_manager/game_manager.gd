extends Node2D

var round_budget: int
var round_count: int
var money: int
var tokens: int
var spins: int
var boosts: int
var game_state : GameEnums.game_states
var bets : Dictionary
var caughtCells : Array

var single_bet_coeff : float = 20.0
var half_bet_coeff : float = 2.0
var third_bet_coeff : float = 3.0

signal money_change

const base_cell_weight : float = 1.0

func modify_money (amount : int):
	money += amount
	money_change.emit()

class RouletteCell:
	var number
	var colour
	var weight
	var modifier
	
	func _init(num, col, w = base_cell_weight):
		number = num;
		colour = col;
		weight = w
