extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BlackScreen.visible = false
	GameManagerGlobal.signal_death_screen.connect(death_screen)

#activates the death screen animation
func death_screen():
	$Label.text = "You didnt have enough money for\n" + GameManagerGlobal.current_quota_message 
	$StatsLabel.text = "Reached round " + str(GameManagerGlobal.round_count) + "\n \nYou had " + str(GameManagerGlobal.money) + " money \nneeded " + str(GameManagerGlobal.quota) + " money"
	$AnimationPlayer.play("death_screen_anim")
	MusicManager.play_death()

func _on_test_button_pressed() -> void:
	death_screen()
	pass # Replace with function body.

func _on_return_button_pressed() -> void:
	$AnimationPlayer.play("RESET")
	GameManagerGlobal.signal_cannot_continue_game.emit()
	MusicManager.play_from_beginning()
	GameManagerGlobal.signal_switch_scene.emit(GameEnums.switching_scenes.MAIN_MENU_SCENE)
