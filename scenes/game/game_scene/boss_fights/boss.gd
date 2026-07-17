@abstract class_name Boss extends Node2D

var boss_name: String ##the name of the boss
var description: String ##what describes the boss, what are its abilities
var boss_sprite_idle: Texture2D
var boss_sprite_laugh: Texture2D
var boss_sprite_defeat: Texture2D

func activate() -> void: ##activates automatically when starting a boss round
	$BossSprite.visible = true
	$BossSprite.texture = boss_sprite_idle
	$BossSprite/AnimationPlayer.play("floating_anim")

@abstract func assign_properties() -> void ##assign variables in this func (boss name, textures, description). The method is called when the game picks a next boss
	
@abstract func boss_debuff() -> void
