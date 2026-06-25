extends Node2D

func _on_new_game_button_button_down() -> void:
	GameManagerGlobal.signal_switch_scene.emit(GameEnums.switching_scenes.GAME_SCENE)
