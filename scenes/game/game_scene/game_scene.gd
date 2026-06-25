extends Node2D

class_name GameScene

func _ready() -> void:
	GameManagerGlobal.round_count = 0
	round_start()
	GameManagerGlobal.signal_send_error_message.connect(_on_send_error_message)
	GameManagerGlobal.signal_state_change.connect(_on_new_state)
	GameManagerGlobal.signal_modify_money.connect(edit_money)
	GameManagerGlobal.signal_modify_rubys.connect(edit_rubys)
	GameManagerGlobal.modify_money(100)
	GameManagerGlobal.modify_rubys(50)
	GameManagerGlobal.modify_boost_count(3)
	GameManagerGlobal.modify_spin_count(4)
	GameManagerGlobal.mr_cat_swag = false
	#GameManagerGlobal.modify_boost_left(3)
	GameManagerGlobal.modify_game_state(GameEnums.game_states.BET_PHASE)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("stop_roullete"):
		if (GameManagerGlobal.game_state == GameEnums.game_states.SPIN_PHASE):
			GameManagerGlobal.modify_game_state(GameEnums.game_states.BET_PHASE)
	if Input.is_action_just_pressed("rotate_roullete"):
		if GameManagerGlobal.spins_left > 0:
			GameManagerGlobal.modify_game_state(GameEnums.game_states.SPIN_PHASE)
			GameManagerGlobal.modify_spins_left(GameManagerGlobal.spins_left - 1)
		#TODO end round
	
	#Debugging temporary calls
	if Input.is_action_just_pressed("boost_add"):
		GameManagerGlobal.modify_boost_left(max (0, GameManagerGlobal.boosts_left - 1))
	if Input.is_action_just_pressed("boost_del"):
		GameManagerGlobal.modify_boost_left(min (GameManagerGlobal.boost_count, GameManagerGlobal.boosts_left + 1))
	if Input.is_action_just_pressed("add_ball"):
		#GameManagerGlobal.modify_spins_left(min (GameManagerGlobal.spin_count, GameManagerGlobal.spins_left + 1))
		round_start()

func does_bet_win(bet_id : int) -> bool:
	var bet_type : GameEnums.bet_types = $Table/BettingSystem.get_bet_type(bet_id)
	if bet_type == GameEnums.bet_types.NUMBER:
		for cell : RouletteCell in GameManagerGlobal.caughtCells:
			if cell.number == bet_id:
				return true
				
	elif bet_type == GameEnums.bet_types.THIRD || bet_id == (GameEnums.max_roulette_num + 4) || bet_id == (GameEnums.max_roulette_num + 5):
		var shift
		var step
		if bet_type == GameEnums.bet_types.THIRD:
			shift = bet_id - GameEnums.max_roulette_num
			step = GameEnums.max_roulette_num / 3
		else:
			shift = bet_id - (GameEnums.max_roulette_num + 3)
			step = GameEnums.max_roulette_num / 2
		var lower_bound = (shift - 1) * step + 1
		var upper_bound = shift * step
		for cell : RouletteCell in GameManagerGlobal.caughtCells:
			if cell.number >= lower_bound && cell.number <= upper_bound:
				return true
				
	elif bet_id == (GameEnums.max_roulette_num + 6) || bet_id == (GameEnums.max_roulette_num + 7):
		var mod_res = bet_id - (GameEnums.max_roulette_num + 6)
		for cell : RouletteCell in GameManagerGlobal.caughtCells:
			if (cell.number % 2) == mod_res:
				return true
	elif bet_id == (GameEnums.max_roulette_num + 8) || bet_id == (GameEnums.max_roulette_num + 9):
		var whatever = bet_id - (GameEnums.max_roulette_num + 8)
		var color : Color = Color.BLACK if whatever else Color.RED
		for cell : RouletteCell in GameManagerGlobal.caughtCells:
			if cell.colour == color:
				return true
			
	#button_1st_half.text = "1 to 12"
	#button_2nd_half.text = "13 TO 24"
	#button_even.text = "EVEN"
	#button_odd.text = "ODD"
	#button_red.text = "RED"
	#button_black.text = "BLACK"
	return false

func get_bet_coeff(bet_id : int) -> float:
	var bet_type = $Table/BettingSystem.get_bet_type(bet_id)
	match bet_type:
		GameEnums.bet_types.NUMBER:
			return GameManagerGlobal.single_bet_coeff
		GameEnums.bet_types.THIRD:
			return GameManagerGlobal.third_bet_coeff
		GameEnums.bet_types.HALF:
			return GameManagerGlobal.half_bet_coeff
		_:
			return 0.0

func get_full_bet_win() -> int:
	var value = 0
	for bet_id in GameManagerGlobal.bets:
		var bet = GameManagerGlobal.bets[bet_id]
		if does_bet_win(bet_id):
			var new_value = int (bet * get_bet_coeff(bet_id))
			print("Won bet: ", bet_id, ", amount won: ", new_value)
			value += new_value
	var out_str = "Total profit: " + str(value)
	GameManagerGlobal.signal_send_error_message.emit(out_str)
	return value

func _on_send_error_message(message : String): 
	$HUD/ErrorMessage.put_content(message)
	$HUD/ErrorMessage.restart_anim()

func edit_money():
	$HUD/CoinLabel/Label.text = str(GameManagerGlobal.money)
	
func edit_rubys():
	$HUD/RubyLabel/Label.text = str(GameManagerGlobal.rubys)

func _on_new_state():
	print("Current state " + GameEnums.game_state_str(GameManagerGlobal.game_state))
	match (GameManagerGlobal.game_state):
		GameEnums.game_states.SPIN_PHASE:
			if GameManagerGlobal.applying_boost:
				GameManagerGlobal.applying_boost = false
			else:
				$Table/Roulette.spin_roulette()
		GameEnums.game_states.STOP_PHASE:
			print("Stopped, boosts: ", GameManagerGlobal.boosts_left)
			if GameManagerGlobal.boosts_left == 0:
				GameManagerGlobal.modify_game_state(GameEnums.game_states.BET_PHASE)
				return
			
			$Table/BoostSystem.start_system()
			
			#$Table/Roulette.spin_roulette()
			#GameManagerGlobal.game_state = GameEnums.game_states.SPIN_PHASE
		GameEnums.game_states.BET_PHASE:
			$Table/Roulette.stop_roulette()
			var money_won = get_full_bet_win()
			GameManagerGlobal.modify_money(money_won)
			$Table/BettingSystem.clear_bets()
		_:
			pass

func round_start():
	pick_quota_message()
	GameManagerGlobal.round_count += 1
	GameManagerGlobal.signal_round_start.emit()
	$HUD/SpinSymbolContainer.refill_spins()
	$HUD/BoostSymbolContainer.refill_boosts()



func pick_quota_message():
	var previous_quota_msg = GameManagerGlobal.current_quota_message
	var new_quota_msg = GameManagerGlobal.quota_messages.pick_random()
	if (new_quota_msg != previous_quota_msg):
		GameManagerGlobal.current_quota_message = new_quota_msg
	else:
		pick_quota_message()

func _on_shop_button_down() -> void:
	GameManagerGlobal.signal_switch_scene.emit(GameEnums.switching_scenes.SHOP_SCENE)
