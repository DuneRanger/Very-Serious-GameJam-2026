extends Node2D

class_name ErrorMessage

func put_content (content : String):
	$Label.text = content

func get_text_size () -> Vector2:
	return $Label.size

func restart_anim() -> void:
	$AnimationPlayer.stop()
	print("hello1")
	$AnimationPlayer.play("fade_out", -1, 1.0, false)
	print("hello2")
