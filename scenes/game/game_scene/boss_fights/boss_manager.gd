extends Node2D

var all_bosses : Array[String] = [
	"res://scenes/game/game_scene/boss_fights/bosses/boss1.gd",
	"res://scenes/game/game_scene/boss_fights/bosses/boss2.gd"
]


func _ready() -> void:
		GameManagerGlobal.signal_boss_fight_start.connect(boss_start)

func boss_start():
	print("boss start!!!!!!!!")
	$ActiveBoss.set_script(load(all_bosses.pick_random()))
	$ActiveBoss.activate()
	pass

	
