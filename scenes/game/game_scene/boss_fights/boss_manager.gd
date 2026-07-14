extends Node2D

var all_bosses : Array[String] = [
	#Placeholder bosses
	#"res://scenes/game/game_scene/boss_fights/bosses/boss1.gd",
	"res://scenes/game/game_scene/boss_fights/bosses/boss2.gd",
	"res://scenes/game/game_scene/boss_fights/bosses/boss_trollcat.gd"
	
]


func _ready() -> void:
		GameManagerGlobal.signal_boss_fight_start.connect(boss_start)

func boss_start():
	GameManagerGlobal.is_boss_round = true
	$Boss.activate()
	$AnimationPlayer.play("boss_spawn")
	pass

func boss_end():
	$BossDefeatTimer.start()
	$Boss/BossSprite.texture = load($Boss.boss_sprite_defeat_path)
	$AnimationPlayer.play("boss_defeat")
	GameManagerGlobal.is_boss_round = false

func pick_boss():
	$Boss.set_script(load(all_bosses.pick_random()))
	$Boss.assign_name_and_sprite()
	if $Boss.boss_name == "Trollcat":
		$Boss/BossSprite.scale.x = 2
		$Boss/BossSprite.scale.y = 2
		$Boss/BossSprite.position.x = -16
		$Boss/BossSprite/AnimationPlayer.play("trollcat_floating_anim")
	
func emit_signal_show_spin_button():
	GameManagerGlobal.signal_show_spin_button.emit()


func _on_boss_defeat_timer_timeout() -> void:
	$BossDefeatTimer.stop()
	$Boss/BossSprite.scale.x = 4
	$Boss/BossSprite.scale.y = 4
	$Boss/BossSprite.position.x = 0
	$Boss/BossSprite/AnimationPlayer.play("floating_anim")
