extends Node

class_name GameEnums

const num_sep : String = "\'"

enum switching_scenes {MAIN_MENU_SCENE, HOW_TO_PLAY_SCENE, GAME_SCENE, SHOP_SCENE}

enum game_states {BET_PHASE, STOP_PHASE, SPIN_PHASE}

enum bet_types {NUMBER, HALF, THIRD}
const bet_button_count : int = 34

const max_roulette_num : int = 24

const total_max_spin_count : int = 8
const total_max_boost_count : int = 8

const base_quota_amount : int = 100

#static func test_formats() -> void:
	#var tests : Array[float] = [0.0, 1.0, 1000.0, 2354.0, 2354786789.0, 
	#543890583409.0,1000000000.0,1000000000000.0,100000000000.0, 34789237849237894.0, 8943809432453480956.0,
	#10 ** 12, (10 ** 12) + 1, 10 ** 13, (10 ** 13) - 1, 999999999999.9999]
	#for test in tests:
		#print("Format of " + str(test) + " is: " + format_num(test))

static func format_num(num : float) -> String:
	num = float(num)
	print("Formatting: %f" % num)
	var out : String = ""
	if (num >= (10 ** 12)):
		var power : int = int(round(log(num) / log(10)))
		num /= pow(10.0, power)
		if num >= 10.0:
			num /= 10.0
			power += 1
		elif num < 1.0:
			num *= 10.0
			power -= 1
		
		if round(num * 1000.0) / 1000.0 >= 10.0:
			num /= 10.0
			power += 1
		out = "%1.3fe%d" % [num, power]
	elif num < 1000:
		out = "%d" % int(num)
	else:
		@warning_ignore("narrowing_conversion")
		var parsed_num : int = num
		out = "%03d" % (parsed_num % 1000)
		while (parsed_num >= 1000):
			parsed_num /= 1000
			if parsed_num >= 1000:
				out = ("%03d" % (parsed_num % 1000)) + num_sep + out
			else:
				out = str(parsed_num) + num_sep + out
	print("Formatted as: " + out)
	return out

static func game_state_str(state : game_states) -> String:
	match state:
		game_states.BET_PHASE: return "Bet phase"
		game_states.STOP_PHASE: return "Stop phase"
		game_states.SPIN_PHASE: return "Spin phase"
		_: return "Unknown state"
