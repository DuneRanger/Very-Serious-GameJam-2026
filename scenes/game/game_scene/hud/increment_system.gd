extends Node2D

func _ready() -> void:
	GameManagerGlobal.signal_bet_is_adding_change.connect(_on_signal_bet_change)
	GameManagerGlobal.signal_increment_change.connect(_on_signal_increment_change)
	pass

func _on_remove_toggle_button_down() -> void:
	GameManagerGlobal.bet_is_adding = not GameManagerGlobal.bet_is_adding
	GameManagerGlobal.signal_bet_is_adding_change.emit()

func _on_signal_bet_change() -> void:
	if GameManagerGlobal.bet_is_adding:
		print("The bet is adding")
		$RemoveToggle.text = "+"
	else:
		print("The bet is not adding")
		$RemoveToggle.text = "-"

func get_first_digit(num : int) -> int:
	while true:
		if num >= 0 and num <= 9:
			break
		num /= 10
	return num

func _on_increase_increment_button_button_down() -> void:
	var old_increment = GameManagerGlobal.bet_increment
	var new_increment = old_increment
	new_increment *= 5 if (get_first_digit(old_increment) == 1) else 2
	if new_increment > GameManagerGlobal.money:
		GameManagerGlobal.signal_send_error_message.emit("Cannot go bigger than your money :(")
		return
	GameManagerGlobal.bet_increment = new_increment
	GameManagerGlobal.signal_increment_change.emit()


func _on_decrease_increment_button_button_down() -> void:
	var old_increment = GameManagerGlobal.bet_increment
	var new_increment = old_increment
	new_increment /= 2 if (get_first_digit(old_increment) == 1) else 5
	if new_increment < 1:
		GameManagerGlobal.signal_send_error_message.emit("Cannot go smaller than 1:(")
		return
	GameManagerGlobal.bet_increment = new_increment
	GameManagerGlobal.signal_increment_change.emit()

func _on_signal_increment_change() -> void:
	$BetAmountLabel.text = "Bet amount:\n%d" %GameManagerGlobal.bet_increment
