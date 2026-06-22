extends Node2D

class_name GameScene

@export var err_lab: PackedScene

func _ready() -> void:
	GameManager.money = 1
	GameManager.game_state = GameEnums.game_states.BET_PHASE

func _process(_delta: float) -> void:
	if $Table/BettingSystem.error_message != "":
		send_error_message($Table/BettingSystem.error_message)
		$Table/BettingSystem.error_message = ""
		
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

func send_error_message(message : String):
	print("ok1")
	$Table/ErrorMessage.put_content(message)
	print("ok2")
	$Table/ErrorMessage.restart_anim()
	print("ok3")
