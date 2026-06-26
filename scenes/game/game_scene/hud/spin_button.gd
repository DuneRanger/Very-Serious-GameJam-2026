extends Button

func _ready() -> void:
	GameManagerGlobal.signal_state_change.connect(check_state_validity)
	GameManagerGlobal.signal_modify_money.connect(check_bet_validity)
	pass

func check_state_validity() -> void:
	if GameManagerGlobal.game_state == GameEnums.game_states.BET_PHASE:
		visible = true

func check_bet_validity() -> void:
	for bet_idx in GameManagerGlobal.bets:
		if GameManagerGlobal.bets[bet_idx] > 0:
			disabled = false
			return
	disabled = true

func _on_button_down() -> void:
	if GameManagerGlobal.spins_left > 0:
		GameManagerGlobal.modify_game_state(GameEnums.game_states.SPIN_PHASE)
		GameManagerGlobal.modify_spins_left(GameManagerGlobal.spins_left - 1)
		$Timer.start()

func _on_timer_timeout() -> void:
	$Timer.stop()
	visible = false
	disabled = true
