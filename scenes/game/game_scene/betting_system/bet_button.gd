extends Button

var amount_bet: int
var button_id: int

func _ready() -> void:
	pass

func init(sizex: float, sizey: float, posx: float, posy: float, id: int) -> void:
	size.x = sizex
	size.y = sizey
	position.x = posx
	position.y = posy
	button_id = id
	
	amount_bet = 0;
	

func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	print("Pressed button with id: ", button_id)
