extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spin_used_sprite: Sprite2D = $SpinUsedSprite
@onready var spin_sprite: Sprite2D = $SpinSprite

func _ready() -> void:
	var fucking_scale = Vector2(4,4)
	spin_sprite.scale = fucking_scale
	spin_used_sprite.scale = fucking_scale

func refil_spin_anim():
	animation_player.play("RefilSpin")

func use_spin_anim():
	animation_player.play("UseSpin")

func _on_test_button_pressed() -> void:
	refil_spin_anim()

func _on_test_button_2_pressed() -> void:
	use_spin_anim()
