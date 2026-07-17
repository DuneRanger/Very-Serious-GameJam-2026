extends Node2D

var boosts_left_gain
var times_hit_quota
var hit_quota_gain

func _ready() -> void:
	GameManagerGlobal.signal_round_start.connect(_on_round_start)
	GameManagerGlobal.signal_boss_fight_defeat.connect(get_rekt)


func _on_round_start():
	$SFXTimer.start()
	$AnimationPlayer.play("RoundStart")
	if GameManagerGlobal.round_count == 1 :
		$RubiesGainedMessage.visible = false
	else:
		$RubiesGainedMessage.visible = true
		$RubiesGainedMessage/RubiesGained.text = "[color=#d13030]Rubies gained: +" + str(3 + boosts_left_gain + hit_quota_gain) + "[/color]"
		$RubiesGainedMessage/ForExisting.text = "[color=#d13030]-[/color] for existing: [color=#d13030]+3[/color]"
		$RubiesGainedMessage/ForBoostsLeft.text = "[color=#d13030]-[/color] for " + str(boosts_left_gain/2) + " boosts left: [color=#d13030]+" + str(boosts_left_gain) + "[/color]"
		$RubiesGainedMessage/ForQuota.text = "[color=#d13030]-[/color] for reaching the quota " + str(times_hit_quota) + "x : [color=#d13030]+" +str(hit_quota_gain) + "[/color]"
	
	if GameManagerGlobal.is_boss_round:
		$RoundNumberLabel.text = "Round " + str(GameManagerGlobal.round_count) + ": Boss round!"
		$QuotaMessageLabel.text = "You need " + str(GameManagerGlobal.quota) + " to defeat the " + GameManagerGlobal.next_boss_name + "!"
	else:
		$RoundNumberLabel.text = "Round " + str(GameManagerGlobal.round_count)
		$QuotaMessageLabel.text = "You need " + str(GameManagerGlobal.quota) + " money for " + GameManagerGlobal.current_quota_message
	
	if GameManagerGlobal.round_count % 3 == 0:
		$QuotaMessageLabel.text += "\nYou got an extra roulette ball for your spins!"

func get_rekt():
	$AnimationPlayer.play("get_rekt")

func _on_sfx_timer_timeout() -> void:
	$SFXTimer.stop()
	SfxManager.play_SFX("res://assets/SFX/new_round.ogg")



func _on_confirm_button_pressed() -> void:
	GameManagerGlobal.signal_round_start_confirm.emit()
	SfxManager.play_SFX_pitched("res://assets/SFX/button_pressed.ogg")
	if GameManagerGlobal.is_boss_round:
		GameManagerGlobal.signal_hide_spin_button.emit()
		MusicManager.play_boss()
		$FadeOutTimer.start()
		$AnimationPlayer.play("FadeOutLong")
	else:
		$AnimationPlayer.play("FadeOut")

func _on_fade_out_timer_timeout() -> void:
	$FadeOutTimer.stop()
	GameManagerGlobal.signal_boss_fight_start.emit()
