extends Label


func _ready() -> void:
	GameManagerGlobal.signal_round_start.connect(_on_round_start)

func _on_round_start() :
	$AnimationPlayer.play("AppearAnimation")
	text = "You need " + str(GameManagerGlobal.quota) + " money for " + GameManagerGlobal.current_quota_message
