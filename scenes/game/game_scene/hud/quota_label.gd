extends RichTextLabel


func _ready() -> void:
	GameManagerGlobal.signal_round_start_confirm.connect(_on_round_start)

func _on_round_start() :
	
	if GameManagerGlobal.is_boss_round:
		visible = false
		$Timer.start()
		text = "[color=#eb3636]You need [color=#ffdb59]" + str(GameManagerGlobal.quota) + " [color=#eb3636]money to defeat the " + GameManagerGlobal.next_boss_name + "[/color]"
		
	else:
		$AnimationPlayer.play("AppearAnimation")
		text = "You need [color=#ffdb59]" + str(GameManagerGlobal.quota) + "[/color] money for " + GameManagerGlobal.current_quota_message


func _on_timer_timeout() -> void:
	$Timer.stop()
	$AnimationPlayer.play("AppearAnimation")
