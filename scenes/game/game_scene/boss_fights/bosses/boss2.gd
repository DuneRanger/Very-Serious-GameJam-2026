class_name Boss2 extends Boss

func assign_properties() -> void:
	boss_name = "boss 2"
	boss_sprite_idle = load("res://assets/textures/bosses/boss_placeholder2.png")
	description = "placeholder boss"



func boss_debuff():
	print("debuffuju tě")
