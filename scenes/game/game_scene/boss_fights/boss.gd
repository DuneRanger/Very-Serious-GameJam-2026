@abstract class_name Boss extends Node2D

var boss_name: String
var description: String
var boss_sprite_idle: Texture2D
var boss_sprite_laugh: Texture2D
var boss_sprite_defeat: Texture2D

func activate() -> void:
	$BossSprite.visible = true
	$BossSprite.texture = boss_sprite_idle
	$BossSprite/AnimationPlayer.play("floating_anim")

@abstract func assign_name_and_sprite() -> void
	
@abstract func boss_debuff() -> void
