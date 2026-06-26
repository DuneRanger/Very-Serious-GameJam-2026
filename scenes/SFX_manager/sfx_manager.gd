extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func play_SFX(path : String):
	$AudioStreamPlayer.pitch_scale = 1
	$AudioStreamPlayer.stream = load(path)
	$AudioStreamPlayer.play()

func play_SFX_pitched(path : String):
	$AudioStreamPlayer.pitch_scale = randf_range(0.5, 1.5)
	$AudioStreamPlayer.stream = load(path)
	$AudioStreamPlayer.play()
