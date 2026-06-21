extends Button

var amount_bet: int
var button_id: int

signal placed_bet(bet_button_id : int)

func init(sizex: float, sizey: float, posx: float, posy: float, id: int) -> void:
	size.x = sizex
	size.y = sizey
	position.x = posx
	position.y = posy
	button_id = id
	amount_bet = 0;

func _on_button_down() -> void:
	placed_bet.emit(button_id)
