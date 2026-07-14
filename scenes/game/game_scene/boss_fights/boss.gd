@abstract class_name Boss extends Node2D

var boss_name: String
var description: String
var boss_sprite_idle_path: String
var boss_sprite_laugh_path: String
var boss_sprite_defeat_path: String

func activate() -> void:
	$BossSprite.visible = true
	$BossSprite.texture = load(boss_sprite_idle_path)

@abstract func assign_name_and_sprite() -> void
	
@abstract func boss_debuff() -> void
