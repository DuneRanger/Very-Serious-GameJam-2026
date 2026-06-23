extends Node

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_animation: AnimationPlayer = $AudioStreamPlayer/AnimationPlayer
@onready var death_timer: Timer = $AudioStreamPlayer/DeathTimer

var death = false
var preloadAudio 

# debug purposes
func _ready() -> void:
	preloadAudio = load("res://assets/music/RouletteGameThemeLooped.ogg")
	play_from_beginning()

func play_from_beginning() -> void:
	death = false
	audio_player.stream = load("res://assets/music/RouletteGameThemeBegin.ogg")
	audio_player.play(160)

#play this when the player dies
func play_death() -> void :
	death = true
	audio_animation.play("FadeOutAnimation")
	death_timer.start()

func _on_death_timer_timeout() -> void:
	death_timer.stop()
	audio_animation.play("RESET")
	audio_player.stream = load("res://assets/music/DeathSting.mp3")
	audio_player.play()

func _on_audio_stream_player_finished() -> void:
	if death == false:
		audio_player.stream = preloadAudio
		audio_player.play()
