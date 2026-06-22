extends Node2D

class_name GameScene

func _ready() -> void:
	GameManager.money = 1
	GameManager.game_state = GameEnums.game_states.BET_PHASE

func _process(_delta: float) -> void:
	match (GameManager.game_state):
		GameEnums.game_states.BET_PHASE:
			if Input.is_action_just_pressed("rotate_roullete"):
				$Table/Roulette.spin_roulette()
				GameManager.game_state = GameEnums.game_states.SPIN_PHASE
		GameEnums.game_states.SPIN_PHASE:
			if Input.is_action_just_pressed("stop_roullete"):
				$Table/Roulette.stop_roulette()
				GameManager.game_state = GameEnums.game_states.BET_PHASE
		_:
			pass
