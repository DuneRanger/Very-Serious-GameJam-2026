extends Node

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var stream: AudioStreamSynchronized = audio_player.stream
@onready var audio_animation: AnimationPlayer = $AudioStreamPlayer/AnimationPlayer
@onready var death_timer: Timer = $AudioStreamPlayer/DeathTimer

var stop_state = false
var preload_audio_1
var preload_audio_2 
var boss_music = false
var boss_fade_out_type = 1
var play_original: bool  = true ##if it is playing the original version of the theme
var temp

# debug purposes
func _ready() -> void:
	GameManagerGlobal.signal_change_music_type.connect(change_theme_type)
	GameManagerGlobal.signal_boss_music_toggle.connect(boss_music_toggle)
	GameManagerGlobal.signal_boss_fight_lost.connect(boss_music_toggle)
	GameManagerGlobal.signal_round_start.connect(change_theme_calmer)
	play_from_beginning()

func play_from_beginning() -> void:
	print("music_from_beginning")
	play_original = true
	boss_music = false
	stop_state = false
	audio_animation.play("RESET")
	
	preload_audio_1 = load("res://assets/music/theme_normal_looped.ogg")
	preload_audio_2 = load("res://assets/music/theme_calmer_looped.ogg")
	stream.set_sync_stream(0, load("res://assets/music/theme_normal_begin.ogg"))
	stream.set_sync_stream(1, load("res://assets/music/theme_calmer_begin.ogg")) 
	stream.set_sync_stream_volume(1, -40)
	audio_player.play()

func play_win():
	stop_state = true
	audio_animation.play("FadeOutAnimation")
	$AudioStreamPlayer/WinTimer.start()

#play this when the player dies
func play_death() -> void :
	stop_state = true
	audio_animation.play("FadeOutAnimation")
	death_timer.start()

func _on_death_timer_timeout() -> void:
	death_timer.stop()
	audio_animation.play("RESET")
	audio_player.stream.set_sync_stream(0, load("res://assets/music/DeathSting.mp3"))
	audio_player.play()

func _on_audio_stream_player_finished() -> void:
	if stop_state == false:
		audio_player.stream.set_sync_stream(0, preload_audio_1)
		audio_player.stream.set_sync_stream(1, preload_audio_2)
		audio_player.play()


func _on_win_timer_timeout() -> void:
	$AudioStreamPlayer/WinTimer.stop()
	audio_animation.play("RESET")
	audio_player.stream = load("res://assets/music/GameWin.ogg")
	audio_player.play()


func play_boss():
	preload_audio_1 = load("res://assets/music/prototypes/BossFightPrototypeV2.mp3")
	audio_animation.play("FadeOut2Animation")
	boss_fade_out_type = 1
	$AudioStreamPlayer/BossTimer.start() #waits for boss spawn animation
	
func boss_defeat():
	audio_animation.play("FadeOut2Animation")
	boss_fade_out_type = 2
	$AudioStreamPlayer/BossTimer.start() #waits for boss defeat animation

func _on_boss_timer_timeout() -> void:
	#when boss anim finishes
	audio_animation.play("RESET")
	$AudioStreamPlayer/BossTimer.stop()
	if boss_fade_out_type == 1: 
		$AudioStreamPlayer.stream.set_sync_stream(0, preload_audio_1)
		$AudioStreamPlayer.play()
		preload_audio_1 = load("res://assets/music/prototypes/BossFightPrototypeV2.mp3")
	elif boss_fade_out_type == 2:
		play_from_beginning()


func change_theme_type():
	print("music_changing_theme_type")
	if boss_music == false:
		match play_original:
				true:
					change_theme_calmer()
				false:
					change_theme_original()
		print("music_temp = " + str(temp))
		print("music_play_original = " + str(play_original))
	

func change_theme_calmer():
	print("music_changing_to_calmer")
	get_transition_start_pos()
	play_original = false
	audio_animation.play("change_music_1")
	audio_animation.seek(4 - temp)
	
func change_theme_original():
	
	get_transition_start_pos()
	audio_animation.play("change_music_2")
	audio_animation.seek(4 - temp)
	play_original = true
	
func get_transition_start_pos():
		if audio_animation.is_playing():
			temp = audio_animation.current_animation_position
		else:
			temp = 4

func boss_music_toggle():
	match boss_music:
		true:
			boss_music = false
		false:
			boss_music = true
