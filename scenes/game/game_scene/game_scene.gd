extends Node2D

func _ready() -> void:
	$GameManager.money = 10
	$Table/BettingSystem.game_manager = $GameManager

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rotate_roullete"):
		$Table/Roulette.spin_roulette()
	elif Input.is_action_just_pressed("stop_roullete"):
		$Table/Roulette.stop_roulette()
