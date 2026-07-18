extends Node2D


var all_bosses : Array[String] = [
	#Placeholder bosses
	"res://scenes/game/game_scene/boss_fights/bosses/boss1.gd",
	"res://scenes/game/game_scene/boss_fights/bosses/boss2.gd",
	"res://scenes/game/game_scene/boss_fights/bosses/boss_trollcat.gd"
	
]

var laugh_count : int = 1

func _ready() -> void:
	GameManagerGlobal.signal_boss_fight_start.connect(boss_start)
	GameManagerGlobal.signal_boss_fight_lost.connect(boss_laugh)
	GameManagerGlobal.signal_game_start.connect(new_game)
	GameManagerGlobal.signal_boss_hide.connect(hide_boss)

func boss_start(): ##Starts a boss round and spawns the boss
	GameManagerGlobal.is_boss_round = true
	GameManagerGlobal.signal_boss_music_toggle.emit()
	$Boss.activate()
	$AnimationPlayer.play("boss_spawn")
	pass

func boss_defeat(): ##Ends a boss round, plays boss defeat anim, returns game to normal
	$BossDefeatTimer.start()
	MusicManager.boss_defeat()
	SfxManager.play_SFX_pitched("res://assets/SFX/boss_defeat.mp3")
	$Boss/BossSprite.texture = $Boss.boss_sprite_defeat
	$AnimationPlayer.play("boss_defeat")
	GameManagerGlobal.is_boss_round = false
	GameManagerGlobal.signal_boss_fight_defeat.emit()
	GameManagerGlobal.signal_boss_music_toggle.emit()

func pick_boss(): ##picks a random boss and adds the boss script to the Boss object
	$Boss.set_script(load(all_bosses.pick_random()))
	$Boss.assign_properties()
	
func emit_signal_show_spin_button():
	GameManagerGlobal.signal_show_spin_button.emit()


func boss_laugh(): ##plays boss laughing anim
	$Boss/BossSprite.texture = $Boss.boss_sprite_laugh
	$LaughTimer.start()
	
func _on_laugh_timer_timeout() -> void:
	laugh_count +=1
	if laugh_count % 2 == 0:
		$Boss/BossSprite.texture = $Boss.boss_sprite_idle
	else:
		$Boss/BossSprite.texture = $Boss.boss_sprite_laugh
	if laugh_count == 14:
		laugh_count = 1
		$LaughTimer.stop()

func new_game():
	$Boss/BossSprite/AnimationPlayer.stop()
	hide_boss()

func hide_boss():
	$Boss.visible = false

func _on_boss_defeat_timer_timeout() -> void:
	$BossDefeatTimer.stop()
	$Boss/BossSprite.scale.x = 4
	$Boss/BossSprite.scale.y = 4
	$Boss/BossSprite.position.x = 0
	$Boss/BossSprite/AnimationPlayer.stop()
