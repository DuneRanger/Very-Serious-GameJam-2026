extends Node2D

var is_active = false
var first_spin_of_round

func _ready() -> void:
	GameManagerGlobal.signal_state_change.connect(check_state_validity)
	GameManagerGlobal.signal_add_money.connect(check_bet_validity)
	GameManagerGlobal.signal_modify_money.connect(check_bet_validity)
	GameManagerGlobal.signal_hide_spin_button.connect(hide_self)
	GameManagerGlobal.signal_show_spin_button.connect(show_self)
	GameManagerGlobal.signal_round_start.connect(set_first_spin)
	pass

func check_state_validity() -> void:
	if GameManagerGlobal.game_state == GameEnums.game_states.BET_PHASE:
		visible = true

func check_bet_validity(_arg = 0) -> void:
	print("Checking validity")
			#je to tu trošičku přeskládaný aby ten button neresetoval animaci pokazdy kdyz dáš bet
	for bet_idx in GameManagerGlobal.bets:
		if GameManagerGlobal.bets[bet_idx] > 0:
			if is_active == false:
				is_active = true
				$SpinButton.disabled = false
				$SpinButton.text = "SPIN!"
				$AnimationPlayer.play("activate_anim")
			#handlovani toho jak se ukazuje u boss fightu
				if GameManagerGlobal.is_boss_round:
					visible = true
					$Timer2.start()
					show_self()
			return
	$SpinButton.disabled = true
	is_active = false
	if GameManagerGlobal.is_boss_round:
		hide_self()
	else:
		is_active = false
		$AnimationPlayer.play("shaking")
		$SpinButton.text = "Place\n a bet!"

func _on_button_down() -> void:
	if GameManagerGlobal.spins_left > 0:
		if first_spin_of_round == true:
			GameManagerGlobal.signal_change_music_type.emit()
			first_spin_of_round = false
		$Timer2.stop()
		$SpinButton.disabled = true
		SfxManager.play_SFX("res://assets/SFX/spin_start.ogg")
		GameManagerGlobal.modify_game_state(GameEnums.game_states.SPIN_PHASE)
		GameManagerGlobal.modify_spins_left(GameManagerGlobal.spins_left - 1)
		$Timer.start()
		$AnimationPlayer.play("use_spin")

func _on_timer_timeout() -> void:
	$Timer.stop()
	visible = false
	$SpinButton.disabled = true
	$AnimationPlayer.play("RESET")
	
	
func set_first_spin():
	first_spin_of_round = true
	
#pičoviny na callování animací
func hide_self():
	visible = false

func show_self():
	$AnimationPlayer.play("show_button")
	
func shake_anim():
	$AnimationPlayer.play("shaking")

func _on_timer_2_timeout() -> void:
	$Timer2.stop()
	$AnimationPlayer.play("activate_anim")
