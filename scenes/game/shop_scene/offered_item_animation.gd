extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var randomTime = randf_range(0, 8)
	$AnimationPlayer.seek(randomTime)
