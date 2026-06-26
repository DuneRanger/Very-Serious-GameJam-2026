extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func play_SFX(path : String):
	$AudioStreamPlayer.stream = load(path)
	$AudioStreamPlayer.play()
