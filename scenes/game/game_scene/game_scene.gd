extends Node2D

func _ready() -> void:
	$GameManager.money = 10
	$Table/BettingSystem.game_manager = $GameManager
	
