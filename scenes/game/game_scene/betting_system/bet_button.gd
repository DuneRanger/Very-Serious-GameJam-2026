extends Button

var amount_bet: int
var button_id: int
var to_process: bool

func _ready() -> void:
	pass

func init(sizex: float, sizey: float, posx: float, posy: float, id: int) -> void:
	size.x = sizex
	size.y = sizey
	position.x = posx
	position.y = posy
	button_id = id
	amount_bet = 0;
	to_process = false

func _on_button_down() -> void:
	to_process = true
