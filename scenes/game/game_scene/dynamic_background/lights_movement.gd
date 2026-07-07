extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var randomTime = randf_range(0, 240)
	print(randomTime)
	$AnimationPlayer.seek(randomTime)
