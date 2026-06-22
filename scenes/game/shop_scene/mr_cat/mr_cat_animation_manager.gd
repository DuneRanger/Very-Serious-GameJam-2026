extends Node2D

@onready var mr_cat_tail_sprite: AnimatedSprite2D = $MrCatTailSprite
@onready var mr_cat_sprite: AnimatedSprite2D = $MrCatSprite
@onready var timer: Timer = $Timer


func _ready() -> void:
	play_default_anim()

# This animation should play when Mr. Cat is idle
func play_default_anim():
	mr_cat_sprite.play("default")
	mr_cat_tail_sprite.play("default")

# This animation should play when 
#Mr. Cat is happy about money.
# He will be happy for 3 seconds, 
#then he will revert to the default state
func play_money_anim():
	timer.start()
	mr_cat_sprite.play("money")
	mr_cat_tail_sprite.play("money")

func _on_timer_timeout() -> void:
	timer.stop()
	play_default_anim()


#test
func _on_test_button_pressed() -> void:
	play_money_anim()
