extends Node

class_name GameEnums

enum switching_scenes {MAIN_MENU_SCENE, HOW_TO_PLAY_SCENE, GAME_SCENE, SHOP_SCENE}

enum game_states {BET_PHASE, STOP_PHASE, SPIN_PHASE}

enum bet_types {NUMBER, HALF, THIRD}

const max_roulette_num : int = 24

const total_max_spin_count : int = 8
const total_max_boost_count : int = 8

static func game_state_str(state : game_states) -> String:
	match state:
		game_states.BET_PHASE: return "Bet phase"
		game_states.STOP_PHASE: return "Stop phase"
		game_states.SPIN_PHASE: return "Spin phase"
		_: return "Unknown state"
