extends Node2D


func _on_menu_button_button_down() -> void:
	GameManagerGlobal.signal_switch_scene.emit(GameEnums.switching_scenes.MAIN_MENU_SCENE)
