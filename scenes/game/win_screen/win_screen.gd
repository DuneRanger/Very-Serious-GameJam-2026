extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.visible = false
	pass # Replace with function body.

func win_screen():
	MusicManager.play_win()
	$AnimationPlayer.play("win_screen")
	

func _on_test_button_pressed() -> void:
	win_screen()



func _on_return_button_pressed() -> void:
	$AnimationPlayer.play("RESET")
	MusicManager.play_from_beginning()
	GameManagerGlobal.signal_switch_scene.emit(GameEnums.switching_scenes.MAIN_MENU_SCENE)


func _on_continue_button_pressed() -> void:
	$AnimationPlayer.play("RESET")
	MusicManager.play_from_beginning()
