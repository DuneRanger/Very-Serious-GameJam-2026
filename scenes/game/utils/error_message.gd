extends Node2D

class_name ErrorMessage

func put_content (content : String):
	$Label.text = content

func restart_anim() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("fade_out", -1, 1.0, false)


func _on_shop_button_button_down() -> void:
	pass # Replace with function body.
