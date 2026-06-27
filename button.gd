extends Button

func _on_button_down() -> void:
	if GameManagerGlobal.game_state == GameEnums.game_states.BET_PHASE:
		SfxManager.press_button_sound()
		GameManagerGlobal.signal_switch_scene.emit(GameEnums.switching_scenes.MAIN_MENU_SCENE)
	else:
		GameManagerGlobal.signal_send_error_message.emit("Only allowed after finishing a spin!")
