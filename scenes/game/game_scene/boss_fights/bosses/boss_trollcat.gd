class_name Boss_Trollcat extends Boss

func assign_name_and_sprite() -> void:
	boss_name = "Trollcat"
	boss_sprite_idle_path = "res://assets/textures/bosses/Trollcat/boss_trollcat_idle.png"
	boss_sprite_laugh_path = "res://assets/textures/bosses/Trollcat/boss_trollcat_laugh.png"
	boss_sprite_defeat_path = "res://assets/textures/bosses/Trollcat/boss_trollcat_defeat.png"
	description = "Does nothing?"

func boss_debuff():
	print("debuffuju tě")
