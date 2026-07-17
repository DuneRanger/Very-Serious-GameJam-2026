extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManagerGlobal.signal_round_start_confirm.connect(show_self)
	GameManagerGlobal.signal_round_start.connect(change_text)
	

func change_text():
	visible = false
	text = "Round " + str(GameManagerGlobal.round_count)

func show_self():
	if GameManagerGlobal.is_boss_round:
		$Timer.wait_time = 6
		$Timer.start()
	else:
		$Timer.wait_time = 2
		$Timer.start()

func _on_timer_timeout() -> void:
	$Timer.stop()
	$AnimationPlayer.play("show_anim")
