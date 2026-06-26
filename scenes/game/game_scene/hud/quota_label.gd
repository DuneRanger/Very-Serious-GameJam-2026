extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManagerGlobal.signal_round_start.connect(_on_round_start)
	pass # Replace with function body.

func _on_round_start() :
	$AnimationPlayer.play("AppearAnimation")
	text = "You need " + str(GameManagerGlobal.quota) + " money for " + GameManagerGlobal.current_quota_message
