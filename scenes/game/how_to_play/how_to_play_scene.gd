extends Node2D

var other_button_text : String = "2/2"

func _on_menu_button_button_down() -> void:
	GameManagerGlobal.signal_switch_scene.emit(GameEnums.switching_scenes.MAIN_MENU_SCENE)


func _on_next_page_button_button_down() -> void:
	$NumbersLabel.visible = not $NumbersLabel.visible
	$RulesLabel.visible = not $RulesLabel.visible
	var buf = other_button_text
	other_button_text = $NextPageButton.text
	$NextPageButton.text = buf
