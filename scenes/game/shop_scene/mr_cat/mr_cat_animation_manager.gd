extends Node2D
@onready var mr_cat_tail_sprite: AnimatedSprite2D = $MrCatControlNode/MrCatTailSprite
@onready var mr_cat_sprite: AnimatedSprite2D = $MrCatControlNode/MrCatSprite

@onready var timer: Timer = $Timer

func _ready() -> void:
	GameManagerGlobal.signal_mr_cat_swag.connect(play_sunglasses_anim)
	play_default_anim()

# This animation should play when Mr. Cat is idle
func play_default_anim():
	if not GameManagerGlobal.mr_cat_swag:
		mr_cat_sprite.play("default")
	mr_cat_tail_sprite.play("default")

# This animation should play when 
#Mr. Cat is happy about money.
# He will be happy for 3 seconds, 
#then he will revert to the default state
func play_money_anim():
	timer.start()
	if not GameManagerGlobal.mr_cat_swag:
		mr_cat_sprite.play("money")

	mr_cat_tail_sprite.play("money")

func _on_timer_timeout() -> void:
	timer.stop()
	play_default_anim()

func play_sunglasses_anim():
	GameManagerGlobal.mr_cat_swag = true
	mr_cat_sprite.play("sunglasses")


#test
func _on_test_button_pressed() -> void:
	play_money_anim()	

func _on_test_button_2_pressed() -> void:
	play_sunglasses_anim()


func _on_game_button_button_down() -> void:
	play_default_anim()
	SfxManager.press_button_sound()
	GameManagerGlobal.signal_switch_scene.emit(GameEnums.switching_scenes.GAME_SCENE)
