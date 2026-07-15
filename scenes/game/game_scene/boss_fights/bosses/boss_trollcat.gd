class_name Boss_Trollcat extends Boss

func assign_name_and_sprite() -> void:
	boss_name = "Trollcat"
	boss_sprite_idle = load("res://assets/textures/bosses/Trollcat/boss_trollcat_idle.png")
	boss_sprite_laugh = load("res://assets/textures/bosses/Trollcat/boss_trollcat_laugh.png")
	boss_sprite_defeat = load("res://assets/textures/bosses/Trollcat/boss_trollcat_defeat.png")
	description = "Does nothing?"
	GameManagerGlobal.signal_boss_fight_defeat.connect(reset_pos)

func boss_debuff():
	pass

func activate():
	$BossSprite.visible = true
	$BossSprite.texture = boss_sprite_idle
	$BossSprite.scale.x = 2
	$BossSprite.scale.y = 2
	$BossSprite.position.x = -16
	$BossSprite/AnimationPlayer.play("trollcat_floating_anim")

func reset_pos():
	$BossSprite/AnimationPlayer.play("RESET")
