extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var boost_used_sprite: Sprite2D = $BoostUsedSprite
@onready var boost_sprite: Sprite2D = $BoostSprite

func _ready() -> void:
	var fucking_scale = Vector2(4,4)
	boost_sprite.scale = fucking_scale
	boost_used_sprite.scale = fucking_scale
	boost_idle_anim()

func boost_idle_anim():
	animation_player.play("boost_idle")
	var randomTime = randf_range(0, 4)
	animation_player.seek(randomTime)

func refil_boost_anim():
	animation_player.play("RefilBoost")

func use_boost_anim():
	animation_player.play("UseBoost")
