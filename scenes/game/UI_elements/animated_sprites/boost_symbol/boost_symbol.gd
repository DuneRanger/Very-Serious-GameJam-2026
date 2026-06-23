extends Node2D

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var boost_used_sprite: Sprite2D = $Control/BoostUsedSprite
@onready var boost_sprite: Sprite2D = $Control/BoostSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boost_idle_anim()

func boost_idle_anim():
	animation_player.play("boost_idle")
	var randomTime = randf_range(0, 4)
	animation_player.seek(randomTime)

func refil_boost_anim():
	animation_player.play("RefilBoost")

	
func use_boost_anim():
	animation_player.play("UseBoost")



func _on_test_button_pressed() -> void:
	refil_boost_anim()


func _on_test_button_2_pressed() -> void:
	use_boost_anim()
