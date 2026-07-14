extends Node2D

var all_bosses : Array[String] = [
	#Placeholder bosses
	"res://scenes/game/game_scene/boss_fights/bosses/boss1.gd",
	"res://scenes/game/game_scene/boss_fights/bosses/boss2.gd"
]


func _ready() -> void:
		GameManagerGlobal.signal_boss_fight_start.connect(boss_start)

func boss_start():
	print("boss start!!!!!!!!")
	GameManagerGlobal.is_boss_round = true
	$Boss.activate()
	$AnimationPlayer.play("boss_spawn")
	pass

func boss_end():
	print("Boss defeated!!!!")
	$AnimationPlayer.play("boss_defeat")
	GameManagerGlobal.is_boss_round = false

func pick_boss():
	$Boss.set_script(load(all_bosses.pick_random()))
	$Boss.assign_name_and_sprite()
	
func emit_signal_show_spin_button():
	GameManagerGlobal.signal_show_spin_button.emit()
