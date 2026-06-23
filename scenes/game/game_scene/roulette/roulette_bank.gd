class_name RouletteBank
extends Area2D

var cell : RouletteCell
var local_bank_position : Vector2

var catch_characteristic_speed : float = 100.0
var catch_sharpness : float = 1.5

var top_edge_radius : float
var bottom_edge_radius : float

var polygon_points : PackedVector2Array = []
var outer_collider : CollisionShape2D
var left_collider : CollisionShape2D
var right_collider : CollisionShape2D

func get_bank_position():
	return global_position + local_bank_position

func get_arc_points(center, radius, angle_from, angle_to) -> PackedVector2Array:
	var nb_points = 3 + floor(10 * abs(angle_from - angle_to)) 
	var points_arc = PackedVector2Array()

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	return points_arc

func build_colliders(bank_angle: float, radius_center: float, width: float):
	var outer_r = radius_center + width * 0.5
	var inner_r = radius_center - width * 0.5
	var left_angle = -bank_angle * 0.5
	var right_angle = bank_angle * 0.5

	var outer_convex = Line2D.new()
	outer_convex.points = get_arc_points(Vector2.ZERO, outer_r, left_angle, right_angle)
	match cell.colour:
		Color.BLACK:
			outer_convex.default_color = Color(0.9, 0.9, 0.9, 0.2)
		_:
			outer_convex.default_color = Color(0.1, 0.1, 0.1, 0.4)
	add_child(outer_convex)
	outer_collider = CollisionShape2D.new()
	outer_collider.shape = outer_convex
	add_child(outer_collider)
	
	var left_side = Line2D.new()
	left_side.points = [Vector2(cos(left_angle), sin(left_angle)) * inner_r, Vector2(cos(left_angle), sin(left_angle)) * outer_r]
	left_side.default_color = Color.SILVER
	add_child(left_side)
	left_collider = CollisionShape2D.new()
	left_collider.shape = left_side
	add_child(left_collider)
	
	var right_side = Line2D.new()
	right_side.points = [Vector2(cos(right_angle), sin(right_angle)) * inner_r, Vector2(cos(right_angle), sin(right_angle)) * outer_r]
	right_side.default_color = Color.SILVER
	add_child(right_side)
	right_collider = CollisionShape2D.new()
	right_collider.shape = right_side
	add_child(right_collider)


func _init(owner_cell: RouletteCell, bank_angle: float, bank_position: Vector2 = Vector2.ZERO, bank_width: float = 45.0):
	cell = owner_cell
	local_bank_position = bank_position
	rotation = bank_position.angle()
	name = "Bank_%s" % str(cell.number)
	
	if cell.number < 5:
		var position_visual = Polygon2D.new()
		position_visual.color = Color(0.204, 0.663, 0.682, 1.0)
		position_visual.position = local_bank_position
		position_visual.polygon = RouletteBall._make_circle_points(20, 24)
		add_child(position_visual)
	
	build_colliders(bank_angle, bank_position.length() * 0.985, bank_width)
	#polygon_points = build_bank_polygon(bank_angle - 0.05, bank_position.length(), bank_width)
	
	var convex = ConvexPolygonShape2D.new()
	convex.points = polygon_points

	#bank_collider = CollisionShape2D.new()
	#bank_collider.shape = convex
	#add_child(bank_collider)
	
	#var visual = Polygon2D.new()
	#match cell.colour:
		#Color.BLACK:
			#visual.color = Color(0.9, 0.9, 0.9, 0.2)
		#_:
			#visual.color = Color(0.1, 0.1, 0.1, 0.2)
	#visual.polygon = polygon_points
	#add_child(visual)

	body_entered.connect(_on_body_entered)

# Used by Roulette.move_banks()
func rotate_around_center(angle: float) -> void:
	rotation += angle
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
		GameManager.caughtCells.push_back(cell)
		print("Ball caught at number ", cell.number)
		return
	print("Ball missed cell ", cell.number)
	var ball_dir 
