extends Node2D

class_name GameScene

func _ready() -> void:
	GameManager.money = 100
	GameManager.game_state = GameEnums.game_states.BET_PHASE
	$Table/BettingSystem.send_error_message.connect(send_error_message)

func _process(_delta: float) -> void:
	match (GameManager.game_state):
		GameEnums.game_states.BET_PHASE:
			if Input.is_action_just_pressed("rotate_roullete"):
				$Table/Roulette.spin_roulette()
				GameManager.game_state = GameEnums.game_states.SPIN_PHASE
		GameEnums.game_states.SPIN_PHASE:
			if Input.is_action_just_pressed("stop_roullete"):
				$Table/Roulette.stop_roulette()
				GameManager.game_state = GameEnums.game_states.BET_PHASE
				GameManager.money += get_full_bet_win()
		_:
			pass

func does_bet_win(bet_id : int) -> bool:
	var bet_type : GameEnums.bet_types = $Table/BettingSystem.get_bet_type(bet_id)
	if bet_type == GameEnums.bet_types.NUMBER:
		for cell : RouletteCell in GameManager.caughtCells:
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
		for cell : RouletteCell in GameManager.caughtCells:
			if cell.number >= lower_bound && cell.number <= upper_bound:
				return true
				
	elif bet_id == (GameEnums.max_roulette_num + 6) || bet_id == (GameEnums.max_roulette_num + 7):
		var mod_res = bet_id - (GameEnums.max_roulette_num + 6)
		for cell : RouletteCell in GameManager.caughtCells:
			if (cell.number % 2) == mod_res:
				return true
	elif bet_id == (GameEnums.max_roulette_num + 8) || bet_id == (GameEnums.max_roulette_num + 9):
		var whatever = bet_id - (GameEnums.max_roulette_num + 8)
		var color : Color = Color.BLACK if whatever else Color.RED
		for cell : RouletteCell in GameManager.caughtCells:
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
			return GameManager.single_bet_coeff
		GameEnums.bet_types.THIRD:
			return GameManager.third_bet_coeff
		GameEnums.bet_types.HALF:
			return GameManager.half_bet_coeff
		_:
			return 0.0

func get_full_bet_win() -> int:
	var value = 0
	for bet_id in GameManager.bets:
		var bet = GameManager.bets[bet_id]
		if does_bet_win(bet_id):
			var new_value = int (bet * get_bet_coeff(bet_id))
			print("Won bet: ", bet_id, ", amount won: ", new_value)
			value += new_value
	var out_str = "Total profit: " + str(value)
	send_error_message(out_str)
	return value

func send_error_message(message : String):
	$Table/ErrorMessage.put_content(message)
	$Table/ErrorMessage.restart_anim()
