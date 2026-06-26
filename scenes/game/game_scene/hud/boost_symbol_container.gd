extends HBoxContainer

var boost_symbols : Array = []
var boost_symbol_scene : PackedScene = preload("res://scenes/game/UI_elements/animated_sprites/boost_symbol/boost_symbol.tscn")
var old_boosts_left : int

func _ready() -> void:
	#print("Readying")
	GameManagerGlobal.signal_boosts_left_change.connect(_on_boosts_left_change)
	GameManagerGlobal.signal_boost_count_change.connect(_on_boosts_count_change)
	old_boosts_left = 0

func _on_boosts_left_change() -> void:
	print("Changing count of left boosts to: ", GameManagerGlobal.boosts_left)
	var new_boosts_left = GameManagerGlobal.boosts_left
	var change = old_boosts_left - new_boosts_left
	if change == 0:
		return
	elif change > 0:
		for i in range(new_boosts_left, old_boosts_left):
			boost_symbols[i].use_boost_anim()
	elif change < 0:
		for i in range(old_boosts_left, new_boosts_left):
			boost_symbols[i].refil_boost_anim()
	
	old_boosts_left = GameManagerGlobal.boosts_left
	pass

func _on_boosts_count_change() -> void:
	print("Changing count of max boosts to: ", GameManagerGlobal.boost_count)
	#for b in boost_symbols:
		#print("Killing children")
		#remove_child(b)
	#boost_symbols.clear()
	var change = GameManagerGlobal.boost_count - boost_symbols.size()
	if change > 0:
		for i in range(change):
			print("Adding")
			var new_boost_symbol = boost_symbol_scene.instantiate()
			add_child(new_boost_symbol)
			boost_symbols.push_back(new_boost_symbol)
			new_boost_symbol.use_boost_anim()
	else:
		for i in range(abs(change)):
			var symbol_to_del = boost_symbols.back()
			remove_child(symbol_to_del)
			boost_symbols.pop_back()
		if GameManagerGlobal.boosts_left > GameManagerGlobal.boost_count:
			GameManagerGlobal.boosts_left = boost_symbols.size()
			old_boosts_left = boost_symbols.size()

func refill_boosts():
	GameManagerGlobal.modify_boost_left(min (GameManagerGlobal.boost_count, GameManagerGlobal.boosts_left + 1))
	$RefillTimer.start()
	

func _on_refill_timer_timeout() -> void:
	$RefillTimer.stop()
	if (GameManagerGlobal.boost_count != GameManagerGlobal.boosts_left):
		refill_boosts()
