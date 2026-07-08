extends Node2D

var saved_amount : float

func _ready() -> void:
	saved_amount = 0

func set_value (amount : float):
	print("Moving from: ", str(saved_amount), " to: ", str(amount))
	saved_amount = amount
	print("Inserting value: ", saved_amount, "To box")
	$HBoxContainer/ValueLabel.text = GameEnums.format_num(saved_amount)

func set_diff (amount : float):
	var text : String
	if amount < 0.0:
		$HBoxContainer/IncreaseLabel.text = " - " + GameEnums.format_num(-amount)
		$HBoxContainer/IncreaseLabel.add_theme_color_override("font_color", Color.RED)
	elif amount > 0.0: 
		$HBoxContainer/IncreaseLabel.text = " + " + GameEnums.format_num(amount)
		$HBoxContainer/IncreaseLabel.add_theme_color_override("font_color", Color.GREEN)
	$HBoxContainer/IncreaseLabel.visible = true
	$Timer.start()
	if amount == 0.0:
		_on_timer_timeout()

func _on_timer_timeout() -> void:
	$HBoxContainer/IncreaseLabel.visible = false
	$Timer.stop()
