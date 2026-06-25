extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManagerGlobal.quota = 1000000
	GameManagerGlobal.signal_quota_message.connect(_on_quota_message_recieved)
	pass # Replace with function body.

func _on_quota_message_recieved() :
	text = "You need " + str(GameManagerGlobal.quota) + " money for " + GameManagerGlobal.current_quota_message
