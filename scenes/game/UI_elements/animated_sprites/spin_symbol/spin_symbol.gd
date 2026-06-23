extends Node2D


@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer


func refil_spin_anim():
	animation_player.play("RefilSpin")

	
func use_spin_anim():
	animation_player.play("UseSpin")



func _on_test_button_pressed() -> void:
	refil_spin_anim()


func _on_test_button_2_pressed() -> void:
	use_spin_anim()
