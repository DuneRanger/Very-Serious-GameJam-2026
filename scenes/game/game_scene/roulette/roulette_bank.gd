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
var collider_visiual_width : float = 5

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
	var inner_r = radius_center - width * 0.48
	var left_angle = -bank_angle * 0.5
	var right_angle = bank_angle * 0.5
	
	var base_shade = 0.1
	#if cell.colour == Color.BLACK: base_shade = 0.8

	var outer_visual = Polygon2D.new()
	var line = get_arc_points(Vector2.ZERO, outer_r, left_angle, right_angle)
	var line2 = get_arc_points(Vector2.ZERO, inner_r, right_angle, left_angle)
	outer_visual.polygon = line + line2
	var colours = []
	for i in range(line.size()): colours.append(Color(base_shade, base_shade, base_shade, 0.4))
	for i in range(line2.size()): colours.append(Color(base_shade, base_shade, base_shade, 0.2))
	outer_visual.vertex_colors = colours
	add_child(outer_visual)

	var outer_shape = ConcavePolygonShape2D.new()
	outer_shape.segments = get_arc_points(Vector2.ZERO, outer_r, left_angle, right_angle)

	outer_collider = CollisionShape2D.new()
	outer_collider.shape = outer_shape
	add_child(outer_collider)
	
	outer_r -= collider_visiual_width / 2
	# Left wall visual
	var left_a = Vector2(cos(left_angle), sin(left_angle)) * inner_r
	var left_b = Vector2(cos(left_angle), sin(left_angle)) * outer_r

	var left_visual = Line2D.new()
	left_visual.width = collider_visiual_width
	left_visual.points = [left_a, left_b]
	left_visual.default_color = Color.SILVER
	add_child(left_visual)

	# Left wall collider
	var left_shape = SegmentShape2D.new()
	left_shape.a = left_a
	left_shape.b = left_b

	left_collider = CollisionShape2D.new()
	left_collider.shape = left_shape
	add_child(left_collider)

	# Right wall visual
	var right_a = Vector2(cos(right_angle), sin(right_angle)) * inner_r
	var right_b = Vector2(cos(right_angle), sin(right_angle)) * outer_r

	var right_visual = Line2D.new()
	right_visual.width = collider_visiual_width
	right_visual.points = [right_a, right_b]
	right_visual.default_color = Color.SILVER
	add_child(right_visual)

	# Right wall collider
	var right_shape = SegmentShape2D.new()
	right_shape.a = right_a
	right_shape.b = right_b

	right_collider = CollisionShape2D.new()
	right_collider.shape = right_shape
	add_child(right_collider)


func _init(owner_cell: RouletteCell, bank_angle: float, bank_position: Vector2 = Vector2.ZERO, bank_width: float = 45.0):
	cell = owner_cell
	rotation = bank_position.angle()
	name = "Bank_%s" % str(cell.number)

	build_colliders(bank_angle, bank_position.length() * 0.98, bank_width)
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
