extends Node2D

func _ready() -> void:
	$GameManager.money = 10
	$GameManager.game_state = GameEnums.game_states.BET_PHASE
	$Table/BettingSystem.game_manager = $GameManager
	$Table/Roulette.game_manager = $GameManager

func _process(delta: float) -> void:
	match ($GameManager.game_state):
		GameEnums.game_states.BET_PHASE:
			if Input.is_action_just_pressed("rotate_roullete"):
				$Table/Roulette.spin_roulette()
				$GameManager.game_state = GameEnums.game_states.SPIN_PHASE
		GameEnums.game_states.SPIN_PHASE:
			if Input.is_action_just_pressed("stop_roullete"):
				$Table/Roulette.stop_roulette()
				$GameManager.game_state = GameEnums.game_states.BET_PHASE
		_:
			pass
