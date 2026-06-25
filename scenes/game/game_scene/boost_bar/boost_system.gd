extends CanvasLayer

var boost_amount

func _ready() -> void:
	$boost_bar/Button.button_down.connect(_on_boost_button_pressed)
	$HappyButton.button_down.connect(_on_happy_button_pressed)
	$UnHappyButton.button_down.connect(_on_unhappy_button_pressed)
	$boost_bar.visible = false
	$HappyButton.visible = false
	$UnHappyButton.visible = false
	

func start_system() -> void:
	$boost_bar.visible = false
	$HappyButton.visible = true
	$UnHappyButton.visible = true

func _on_boost_button_pressed() -> void:
	boost_amount = $boost_bar/bar/inner/boost_indicator.scale.y
	print(boost_amount, " from boost_system")
	GameManagerGlobal.on_boost.emit(boost_amount)
	$boost_bar/Button.visible = false
	$boost_bar/bar/inner/boost_indicator/AnimationPlayer.pause()
	$Timer.start()

func _on_happy_button_pressed() -> void:
	$HappyButton.visible = false
	$UnHappyButton.visible = false
	GameManagerGlobal.modify_game_state(GameEnums.game_states.BET_PHASE)

func _on_unhappy_button_pressed() -> void:
	$HappyButton.visible = false
	$UnHappyButton.visible = false
	$boost_bar.visible = true
	var new_boosts_left = GameManagerGlobal.boosts_left - 1
	GameManagerGlobal.modify_boost_left(new_boosts_left)
	#TODO boost symbol game_scene function
	$boost_bar/bar/inner/boost_indicator/AnimationPlayer.play("boost_bar_anim")

func _on_timer_timeout() -> void:
	$boost_bar.visible = false
	$boost_bar/Button.visible = true
	GameManagerGlobal.applying_boost = true
	GameManagerGlobal.modify_game_state(GameEnums.game_states.SPIN_PHASE)
	$Timer.stop()
