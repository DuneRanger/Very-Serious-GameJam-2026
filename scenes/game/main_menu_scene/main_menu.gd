extends Node2D

func _on_new_game_button_button_down() -> void:
	GameManagerGlobal.start_new_game = true
	GameManagerGlobal.signal_switch_scene.emit(GameEnums.switching_scenes.GAME_SCENE)
	SfxManager.play_SFX("res://assets/SFX/start_game.ogg")



func _on_how_to_play_button_button_down() -> void:
	GameManagerGlobal.signal_switch_scene.emit(GameEnums.switching_scenes.HOW_TO_PLAY_SCENE)


func _on_continue_button_button_down() -> void:
	GameManagerGlobal.signal_switch_scene.emit(GameEnums.switching_scenes.GAME_SCENE)
	SfxManager.play_SFX("res://assets/SFX/start_game.ogg")

func _on_continue_button_ready() -> void:
	$ContinueButton.disabled = true

func continue_on() -> void:
	$ContinueButton.disabled = false

func _ready() -> void:
	GameManagerGlobal.signal_can_continue_game.connect(continue_on)
	GameManagerGlobal.signal_cannot_continue_game.connect(_on_continue_button_ready)
