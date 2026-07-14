@abstract class_name Boss extends Node2D

var boss_name: String
var boss_sprite_path: String

func activate() -> void:
	print("spawned " + boss_name)
	$BossSprite.visible = true
	$BossSprite.texture = load(boss_sprite_path)

@abstract func assign_name_and_sprite() -> void
	
@abstract func boss_debuff() -> void
