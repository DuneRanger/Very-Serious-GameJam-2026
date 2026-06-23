extends Node2D

class_name GameManager

static var round_budget: int
static var round_count: int
static var money: int
static var tokens: int
static var spins: int
static var boosts: int
static var game_state : GameEnums.game_states
static var bets : Dictionary
static var caughtCells : Array[RouletteCell]

static var single_bet_coeff : float = 20.0
static var half_bet_coeff : float = 2.0
static var third_bet_coeff : float = 3.0
