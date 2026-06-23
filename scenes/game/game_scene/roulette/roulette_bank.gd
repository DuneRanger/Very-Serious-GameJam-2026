class_name RouletteBank
extends Area2D

var cell : RouletteCell
var radius : float

var catch_characteristic_speed : float = 100.0
var catch_sharpness : float = 1.5

func _init(owner_cell: RouletteCell = null, bank_radius: float = 45.0, bank_position: Vector2 = Vector2.ZERO) -> void:
	cell = owner_cell
	radius = bank_radius
	position = bank_position
	name = "Bank_%s" % str(cell.number) if cell else "Bank"

	var shape = CircleShape2D.new()
	shape.radius = radius
	var col = CollisionShape2D.new()
	col.shape = shape
	add_child(col)

	body_entered.connect(_on_body_entered)

# Used by Roulette.move_banks()
func rotate_around_center(angle: float) -> void:
	position = position.rotated(angle)

func catch_probability(speed: float) -> float:
	if speed <= 0.0:
		return 1.0
	return 1.0 / (1.0 + pow(speed / catch_characteristic_speed, catch_sharpness))

func _on_body_entered(body: Node) -> void:
	if not (body is RouletteBall) or body.settled:
		return

	var speed = body.get_speed()
	var catch_chance = catch_probability(speed)
	var effective_chance = catch_chance * (1.0 - body.height * 0.85)

	if randf() < effective_chance:
		body.catch_in_pocket(cell)
		GameManagerGlobal.caughtCells.push_back(cell)
		GameManagerGlobal.caughtBalls += 1
		print("Ball caught at number ", cell.number)
	else:
		print("Ball missed cell ", cell.number)
