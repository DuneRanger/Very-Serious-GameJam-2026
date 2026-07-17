extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimerM.wait_time = randf_range(2,5)
	$TimerM.start()
	$TimerR.wait_time = randf_range(2,5)
	$TimerR.start()


func _on_timer_m_timeout() -> void:
	$TimerM.stop()
	$Money.play("default")


func _on_timer_r_timeout() -> void:
	$TimerR.stop()
	$Rubies.play("default")

func _on_money_animation_finished() -> void:
	$TimerM.wait_time = randf_range(3,10)
	$TimerM.start()

func _on_rubies_animation_finished() -> void:
	$TimerR.wait_time = randf_range(3,10)
	$TimerR.start()
