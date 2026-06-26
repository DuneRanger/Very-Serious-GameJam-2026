extends Button

func _ready() -> void:
	GameManagerGlobal.signal_state_change.connect(check_state_validity)
	GameManagerGlobal.signal_add_money.connect(check_bet_validity)
	GameManagerGlobal.signal_modify_money.connect(check_bet_validity)
	pass

func check_state_validity() -> void:
	if GameManagerGlobal.game_state == GameEnums.game_states.BET_PHASE:
		visible = true

func check_bet_validity(_arg = 0) -> void:
	print("Checking validity")
	for bet_idx in GameManagerGlobal.bets:
		if GameManagerGlobal.bets[bet_idx] > 0:
			disabled = false
			text = "SPIN!"
			return
	disabled = true
	text = "Place\n a bet!"

func _on_button_down() -> void:
	if GameManagerGlobal.spins_left > 0:
		SfxManager.play_SFX("res://assets/SFX/spin_start.ogg")
		GameManagerGlobal.modify_game_state(GameEnums.game_states.SPIN_PHASE)
		GameManagerGlobal.modify_spins_left(GameManagerGlobal.spins_left - 1)
		$Timer.start()

func _on_timer_timeout() -> void:
	$Timer.stop()
	visible = false
	disabled = true
