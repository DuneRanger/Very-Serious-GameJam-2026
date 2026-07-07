extends CanvasLayer

var boost_amount

func _ready() -> void:
	$boost_bar/Button.button_down.connect(_on_boost_button_pressed)
	$HappyButton.button_down.connect(_on_happy_button_pressed)
	$UnHappyButton.button_down.connect(_on_unhappy_button_pressed)
	$boost_bar.visible = false
	$HappyButton.visible = false
	$UnHappyButton.visible = false
	$Background.visible = false
	

func start_system() -> void:
	$Background.visible = true
	$boost_bar.visible = false
	$HappyButton.visible = true
	$UnHappyButton.visible = true
	$AnimationPlayer.play("appear")

func _on_boost_button_pressed() -> void:
	SfxManager.play_SFX("res://assets/SFX/boost_bar_use.mp3")
	boost_amount = $boost_bar/bar/inner/boost_indicator.scale.y
	print(boost_amount, " from boost_system")
	GameManagerGlobal.on_boost.emit(boost_amount)
	$boost_bar/Button.visible = false
	$boost_bar/bar/inner/boost_indicator/AnimationPlayer.pause()
	GameManagerGlobal.applying_boost = true
	$Timer.start()
	#BG Test
	$Background.visible = true

func _on_happy_button_pressed() -> void:
	$HappyButton.visible = false
	$UnHappyButton.visible = false
	$Background.visible = false
	GameManagerGlobal.modify_game_state(GameEnums.game_states.BET_PHASE)

func _on_unhappy_button_pressed() -> void:
	SfxManager.play_SFX("res://assets/SFX/boost_bar_spawn.mp3")
	$HappyButton.visible = false
	$UnHappyButton.visible = false
	$boost_bar.visible = true
	var new_boosts_left = GameManagerGlobal.boosts_left - 1
	GameManagerGlobal.modify_boost_left(new_boosts_left)
	#TODO boost symbol game_scene function
	$boost_bar/bar/inner/boost_indicator/AnimationPlayer.play("boost_bar_anim")

func _on_timer_timeout() -> void:
	$Background.visible = false
	$boost_bar.visible = false
	$boost_bar/Button.visible = true
	GameManagerGlobal.modify_game_state(GameEnums.game_states.SPIN_PHASE)
	$Timer.stop()
