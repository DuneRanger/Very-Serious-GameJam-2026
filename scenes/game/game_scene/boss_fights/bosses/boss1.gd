class_name Boss1 extends Boss

func assign_properties() -> void:
	boss_name = "boss 1"
	boss_sprite_idle = load("res://assets/textures/bosses/boss_placeholder1.png")


func boss_debuff():
	print("debuffuju tě")
