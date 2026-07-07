extends Node2D

var saved_amount

func _ready() -> void:
	saved_amount = 0

func set_value (amount : int):
	print("Moving from: ", str(saved_amount), " to: ", str(amount))
	saved_amount = amount
	$HBoxContainer/ValueLabel.text = str(saved_amount)

func set_diff (amount : int):
	var text : String
	if amount < 0:
		$HBoxContainer/IncreaseLabel.text = " - %d" %abs(amount)
		$HBoxContainer/IncreaseLabel.add_theme_color_override("font_color", Color.RED)
	elif amount > 0: 
		$HBoxContainer/IncreaseLabel.text = " + %d" %amount
		$HBoxContainer/IncreaseLabel.add_theme_color_override("font_color", Color.GREEN)
	$HBoxContainer/IncreaseLabel.visible = true
	$Timer.start()
	if amount == 0:
		_on_timer_timeout()
		


func _on_timer_timeout() -> void:
	$HBoxContainer/IncreaseLabel.visible = false
	$Timer.stop()
