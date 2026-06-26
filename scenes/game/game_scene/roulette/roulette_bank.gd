class_name RouletteBank
extends Node2D

var cell : RouletteCell

var catch_characteristic_speed : float = 100.0
var catch_sharpness : float = 1.5

var top_edge_radius : float
var bottom_edge_radius : float

var polygon_points : PackedVector2Array = []
var collider_visiual_width : float = 5

var wall_skip_min_speed : float = 250.0
var wall_skip_max_speed : float = 600.0
var wall_collider_thickness : float = 8.0

var outer_one_way_wall_thickness : float = 5.0

# Holds the colliders (left, right, outer)
var wall_body : StaticBody2D
var base_angle : float

var left_collider : CollisionShape2D
var right_collider : CollisionShape2D

# detects fast balls approaching the left/right wall
var left_skip_gate : Area2D
var right_skip_gate : Area2D

# wider zones spanning past both faces of the wall; re-enabling only happens
# once the ball has fully exited one of these, never on a blind tick timer
var left_clear_zone : Area2D
var right_clear_zone : Area2D

var catch_trigger : Area2D

var invert_outer_one_way_direction : bool = false


func get_arc_points(center, radius, angle_from, angle_to) -> PackedVector2Array:
	var nb_points = 3 + floor(20 * abs(angle_from - angle_to))
	var points_arc = PackedVector2Array()

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	return points_arc


func _build_outer_one_way_wall(inner_r: float, left_angle: float, right_angle: float) -> void:
	var wall_thickness = outer_one_way_wall_thickness
	var outer_r = inner_r + wall_thickness
 
	var outer_arc = get_arc_points(Vector2.ZERO, outer_r, left_angle, right_angle)
	var inner_arc = get_arc_points(Vector2.ZERO, inner_r, left_angle, right_angle)
 
	for i in range(outer_arc.size() - 1):
		var outer_a = outer_arc[i]
		var outer_b = outer_arc[i + 1]
		var inner_a = inner_arc[i]
		var inner_b = inner_arc[i + 1]
		var quad_mid = (outer_a + outer_b + inner_a + inner_b) * 0.25
 
		# Quad points relative to their own center
		var quad_points = PackedVector2Array([
			outer_a - quad_mid, outer_b - quad_mid,
			inner_a - quad_mid, inner_b - quad_mid
		])
 
		var outward = quad_mid.normalized()
		if invert_outer_one_way_direction:
			outward = -outward
		# Rotate the shape, so that one way collision is correct
		var correction = PI / 2.0 - outward.angle()
		var rotated_points = PackedVector2Array()
		for p in quad_points:
			rotated_points.append(p.rotated(correction))
 
		var seg_collider = CollisionShape2D.new()
		var poly = ConvexPolygonShape2D.new()
		seg_collider.name = "Outer collider %s" % str(cell.number, ",", i)
		poly.points = rotated_points
		seg_collider.shape = poly
		seg_collider.position = quad_mid
		seg_collider.rotation = -correction
		seg_collider.one_way_collision = true
		seg_collider.one_way_collision_margin = 16.0
 
		wall_body.add_child(seg_collider)

func build_colliders(bank_angle: float, radius_center: float, width: float):
	var outer_r = radius_center + width * 0.5
	var inner_r = radius_center - width * 0.48
	var left_angle = -bank_angle * 0.5
	var right_angle = bank_angle * 0.5

	var base_shade = 0.1

	var outer_visual = Polygon2D.new()
	outer_visual.name = "Outer collider visual %s" % cell.number
	var outer_line = get_arc_points(Vector2.ZERO, outer_r, left_angle, right_angle)
	var inner_line = get_arc_points(Vector2.ZERO, inner_r, right_angle, left_angle)
	outer_visual.polygon = outer_line + inner_line
	var colours = []
	for i in range(outer_line.size()): colours.append(Color(base_shade, base_shade, base_shade, 0.4))
	for i in range(inner_line.size()): colours.append(Color(base_shade, base_shade, base_shade, 0.2))
	outer_visual.vertex_colors = colours
	add_child(outer_visual)

	# StaticBody2D that holds all (bounce-producing) colliders
	wall_body = StaticBody2D.new()
	wall_body.name = "Body for bank %d" % cell.number
	add_child(wall_body)

	_build_outer_one_way_wall(outer_r, left_angle, right_angle)

	# Adjusting, so that the side wall and outer wall don't overlap
	outer_r -= collider_visiual_width / 2
	
	
	# Left wall visual
	var left_a = Vector2(cos(left_angle), sin(left_angle)) * inner_r
	var left_b = Vector2(cos(left_angle), sin(left_angle)) * outer_r

	var left_visual = Line2D.new()
	left_visual.width = collider_visiual_width
	left_visual.points = [left_a, left_b]
	left_visual.default_color = Color.SILVER
	add_child(left_visual)

	var left_mid = (left_a + left_b) * 0.5
	var left_len = left_a.distance_to(left_b)

	var left_shape = RectangleShape2D.new()
	left_shape.size = Vector2(wall_collider_thickness, left_len)

	left_collider = CollisionShape2D.new()
	left_collider.name = "Left collider %s" % cell.number
	left_collider.shape = left_shape
	left_collider.position = left_mid
	left_collider.rotation = (left_b - left_a).angle() - PI / 2.0
	wall_body.add_child(left_collider)

	# Right wall visual
	var right_a = Vector2(cos(right_angle), sin(right_angle)) * inner_r
	var right_b = Vector2(cos(right_angle), sin(right_angle)) * outer_r

	var right_visual = Line2D.new()
	right_visual.width = collider_visiual_width
	right_visual.points = [right_a, right_b]
	right_visual.default_color = Color.SILVER
	add_child(right_visual)

	var right_mid = (right_a + right_b) * 0.5
	var right_len = right_a.distance_to(right_b)

	var right_shape = RectangleShape2D.new()
	right_shape.size = Vector2(wall_collider_thickness, right_len)

	right_collider = CollisionShape2D.new()
	right_collider.name = "Right collider %s" % cell.number
	right_collider.shape = right_shape
	right_collider.position = right_mid
	right_collider.rotation = (right_b - right_a).angle() - PI / 2.0
	wall_body.add_child(right_collider)

	#_build_skip_gates(left_angle, right_angle, inner_r, outer_r)
	outer_r += collider_visiual_width / 2
	var t = 0.02
	_build_catch_trigger(left_angle + t, right_angle - t, inner_r + RouletteBall.ball_radius / 2, outer_r + RouletteBall.ball_radius / 2)

func _init(owner_cell: RouletteCell, bank_angle: float, bank_position: Vector2 = Vector2.ZERO, bank_width: float = 45.0):
	cell = owner_cell
	base_angle = bank_position.angle()
	rotation = base_angle
	name = "Bank_%s" % str(cell.number)

	build_colliders(bank_angle, bank_position.length() * 0.98, bank_width)

# Thin Area2D zones placed just inside each side wall. A ball entering one of
# these fast enough has a chance to get its matching wall collider disabled,
# letting it pass straight through/"bounce over"
func _build_skip_gates(left_angle: float, right_angle: float, inner_r: float, outer_r: float):
	var gate_half_thickness = 10.0
	var mid_r = (inner_r + outer_r) * 0.5
	var wall_len = outer_r - inner_r

	var clear_zone_half_thickness = gate_half_thickness + wall_collider_thickness

	left_skip_gate = Area2D.new()
	left_skip_gate.name = "Left skip gate %s" % cell.number 
	left_skip_gate.position = Vector2(cos(left_angle), sin(left_angle)) * mid_r
	left_skip_gate.rotation = left_angle
	add_child(left_skip_gate)

	var left_gate_shape = RectangleShape2D.new()
	left_gate_shape.size = Vector2(wall_len, gate_half_thickness * 2)
	var left_gate_collider = CollisionShape2D.new()
	left_gate_collider.name = "Left gate collider %s" % cell.number 
	left_gate_collider.shape = left_gate_shape
	left_skip_gate.add_child(left_gate_collider)
	left_skip_gate.body_entered.connect(_on_left_gate_entered)

	left_clear_zone = Area2D.new()
	left_clear_zone.name = "Left clear zone %s" % cell.number
	left_clear_zone.position = left_skip_gate.position
	left_clear_zone.rotation = left_angle
	add_child(left_clear_zone)

	var left_clear_shape = RectangleShape2D.new()
	left_clear_shape.size = Vector2(wall_len, clear_zone_half_thickness * 2)
	var left_clear_collider = CollisionShape2D.new()
	left_clear_collider.shape = left_clear_shape
	left_clear_zone.add_child(left_clear_collider)
	left_clear_zone.body_exited.connect(_on_left_clear_zone_exited)

	right_skip_gate = Area2D.new()
	right_skip_gate.name = "Right skip gate %s" % cell.number 
	right_skip_gate.position = Vector2(cos(right_angle), sin(right_angle)) * mid_r
	right_skip_gate.rotation = right_angle
	add_child(right_skip_gate)

	var right_gate_shape = RectangleShape2D.new()
	right_gate_shape.size = Vector2(wall_len, gate_half_thickness * 2)
	var right_gate_collider = CollisionShape2D.new()
	right_gate_collider.name = "Right gate collider %s" % cell.number 
	right_gate_collider.shape = right_gate_shape
	right_skip_gate.add_child(right_gate_collider)
	right_skip_gate.body_entered.connect(_on_right_gate_entered)

	right_clear_zone = Area2D.new()
	right_clear_zone.name = "Right clear zone %s" % cell.number
	right_clear_zone.position = right_skip_gate.position
	right_clear_zone.rotation = right_angle
	add_child(right_clear_zone)

	var right_clear_shape = RectangleShape2D.new()
	right_clear_shape.size = Vector2(wall_len, clear_zone_half_thickness * 2)
	var right_clear_collider = CollisionShape2D.new()
	right_clear_collider.shape = right_clear_shape
	right_clear_zone.add_child(right_clear_collider)
	right_clear_zone.body_exited.connect(_on_right_clear_zone_exited)

# The original pocket-catch detector: unchanged in spirit, just rebuilt as its
# own Area2D since the bank itself is no longer an Area2D.
func _build_catch_trigger(left_angle: float, right_angle: float, inner_r: float, outer_r: float):
	catch_trigger = Area2D.new()
	add_child(catch_trigger)

	var pocket_shape = ConvexPolygonShape2D.new()
	var pts = get_arc_points(Vector2.ZERO, outer_r, left_angle, right_angle)
	pts += get_arc_points(Vector2.ZERO, inner_r, right_angle, left_angle)
	pocket_shape.points = pts

	var pocket_collider = CollisionShape2D.new()
	pocket_collider.name = "Catch collider %s" % cell.number
	pocket_collider.shape = pocket_shape
	catch_trigger.add_child(pocket_collider)

	catch_trigger.body_entered.connect(_on_body_entered)
	catch_trigger.body_exited.connect(_on_body_exited)

func _skip_chance(speed: float) -> float:
	if speed <= wall_skip_min_speed:
		return 0.0
	if speed >= wall_skip_max_speed:
		return 1.0
	return 1.0 / (1.0 + pow(speed / wall_skip_min_speed, catch_sharpness))

func _on_left_gate_entered(body: Node):
	if not (body is RouletteBall) or body.settled:
		return
	body = body as RouletteBall
	if randf() < _skip_chance(body.get_speed()):
		left_collider.disabled = true

func _on_right_gate_entered(body: Node):
	if not (body is RouletteBall) or body.settled:
		return
	body = body as RouletteBall
	if randf() < _skip_chance(body.get_speed()):
		right_collider.disabled = true

func _on_left_clear_zone_exited(body: Node):
	if not (body is RouletteBall):
		return
	left_collider.disabled = false

func _on_right_clear_zone_exited(body: Node):
	if not (body is RouletteBall):
		return
	right_collider.disabled = false

func set_total_rotation(visual_rotation: float):
	rotation = base_angle + visual_rotation

func clear_ball(ball: RouletteBall) -> void:
	contains_balls.erase(ball)

func is_tracking(ball: RouletteBall) -> bool:
	return contains_balls.has(ball)

func adopt_ball(ball: RouletteBall) -> void:
	if not contains_balls.has(ball):
		contains_balls.append(ball)

func currently_overlaps(ball: RouletteBall) -> bool:
	return catch_trigger.overlaps_body(ball)

func catch_probability(speed: float) -> float:
	if speed <= 0.0:
		return 1.0
	return 1.0 / (1.0 + pow(speed / catch_characteristic_speed, catch_sharpness))

var contains_balls : Array[RouletteBall] = []

func _physics_process(_delta: float):
	for ball in contains_balls:
		if ball.get_speed() < 75 and ball.settled == false:
			ball.settled = true
			ball.caught_cell = cell
			print("ball in cell ", cell.number, " settled")

func _on_body_entered(body: Node):
	if not (body is RouletteBall): return
	body = body as RouletteBall

	if not contains_balls.has(body): contains_balls.append(body)

func _on_body_exited(body: Node):
	if not (body is RouletteBall): return
	body = body as RouletteBall
	if not contains_balls.has(body): return

	contains_balls.erase(body)
	if body.settled and body.caught_cell == cell:
		body.settled = false
		body.caught_cell = null
		print("ball in cell ", cell.number, " unsettled")
