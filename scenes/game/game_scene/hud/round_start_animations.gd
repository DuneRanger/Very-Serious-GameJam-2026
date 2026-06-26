extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManagerGlobal.signal_round_start.connect(_on_round_start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_round_start():
	$SFXTimer.start()
	$AnimationPlayer.play("RoundStart")
	$RoundNumberLabel.text = "Round " + str(GameManagerGlobal.round_count)
	$QuotaMessageLabel.text = "You need " + str(GameManagerGlobal.quota) + " money for " + GameManagerGlobal.current_quota_message



func _on_sfx_timer_timeout() -> void:
	$SFXTimer.stop()
	SfxManager.play_SFX("res://assets/SFX/new_round.ogg")
