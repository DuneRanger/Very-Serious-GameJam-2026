extends Node

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_animation: AnimationPlayer = $AudioStreamPlayer/AnimationPlayer
@onready var death_timer: Timer = $AudioStreamPlayer/DeathTimer

var stop_state = false
var preloadAudio 
var boss = false
var boss_fade_out_type = 1

# debug purposes
func _ready() -> void:
	play_from_beginning()

func play_from_beginning() -> void:
	stop_state = false
	preloadAudio = load("res://assets/music/RouletteGameThemeLooped.ogg")
	audio_player.stream = load("res://assets/music/RouletteGameThemeBegin.ogg")
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
	audio_player.stream = load("res://assets/music/DeathSting.mp3")
	audio_player.play()

func _on_audio_stream_player_finished() -> void:
	if stop_state == false:
		audio_player.stream = preloadAudio
		audio_player.play()


func _on_win_timer_timeout() -> void:
	$AudioStreamPlayer/WinTimer.stop()
	audio_animation.play("RESET")
	audio_player.stream = load("res://assets/music/GameWin.ogg")
	audio_player.play()


func play_boss():
	preloadAudio = load("res://assets/music/prototypes/BossFightPrototypeV2.mp3")
	audio_animation.play("FadeOut2Animation")
	boss_fade_out_type = 1
	$AudioStreamPlayer/BossTimer.start()
	
func boss_defeat():
	audio_animation.play("FadeOut2Animation")
	boss_fade_out_type = 2
	$AudioStreamPlayer/BossTimer.start()

func _on_boss_timer_timeout() -> void:
	audio_animation.play("RESET")
	$AudioStreamPlayer/BossTimer.stop()
	if boss_fade_out_type == 1:
		$AudioStreamPlayer.stream = preloadAudio
		$AudioStreamPlayer.play()
		preloadAudio = load("res://assets/music/prototypes/BossFightPrototypeV2.mp3")
	elif boss_fade_out_type == 2:
		play_from_beginning()
