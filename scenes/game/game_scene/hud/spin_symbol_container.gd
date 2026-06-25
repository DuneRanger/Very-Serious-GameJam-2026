extends HBoxContainer

var spin_symbols : Array = []
var spin_symbol_scene : PackedScene = preload("res://scenes/game/UI_elements/animated_sprites/spin_symbol/spin_symbol.tscn")
var old_spins_left : int

func _ready() -> void:
	print("Readying")
	GameManagerGlobal.signal_spins_left_change.connect(_on_spins_left_change)
	GameManagerGlobal.signal_spin_count_change.connect(_on_spins_count_change)
	old_spins_left = 0

func _on_spins_left_change() -> void:
	print("Change lefting")
	var new_spins_left = GameManagerGlobal.spins_left
	var change = old_spins_left - new_spins_left
	print("Change: ", change)
	if change == 0:
		return
	elif change > 0:
		for i in range(new_spins_left, old_spins_left):
			spin_symbols[i].use_spin_anim()
	elif change < 0:
		for i in range(old_spins_left, new_spins_left):
			spin_symbols[i].refil_spin_anim()
	
	old_spins_left = GameManagerGlobal.spins_left
	pass

func _on_spins_count_change() -> void:
	print("Change counting")
	for b in spin_symbols:
		print("Killing children")
		remove_child(b)
	spin_symbols.clear()
	
	for i in range(GameManagerGlobal.spin_count):
		print("Adding")
		var new_spin_symbol = spin_symbol_scene.instantiate()
		add_child(new_spin_symbol)
		spin_symbols.push_back(new_spin_symbol)
		
	GameManagerGlobal.modify_spins_left(GameManagerGlobal.spin_count)

func refill_spins():
	GameManagerGlobal.modify_spins_left(min (GameManagerGlobal.spin_count, GameManagerGlobal.spins_left + 1))
	$RefillTimer.start()

func _on_refill_timer_timeout() -> void:
	$RefillTimer.stop()
	if (GameManagerGlobal.spin_count != GameManagerGlobal.spins_left):
		refill_spins()
	
	pass # Replace with function body.
