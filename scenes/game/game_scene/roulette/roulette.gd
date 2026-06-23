class_name Roulette
extends Node2D

static func get_random_vector2(size: float) -> Vector2:
	var angle = randf_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)) * size

static func get_random_roulette_rot() -> float:
	var rot = 0.0
	while abs(rot) < 0.01 : rot = randf_range(-0.04, 0.04)
	return rot

var cells : Array[RouletteCell] = []
var default_font : Font = ThemeDB.fallback_font;

const base_roulette_numbers : int = 24
# (base_roulette_numbers + 1) includes the green 0
var total_weight : float = (base_roulette_numbers + 1) * RouletteCell.base_cell_weight

func _init():
	cells.append(RouletteCell.new(0, Color.GREEN))
	for i in range(base_roulette_numbers):
		var curCol = Color.RED
		if i % 2 == 0: curCol = Color.BLACK
		cells.append(RouletteCell.new(i + 1, curCol))
	randomize_weights()
	cells[0].weight = 10
	update_total_weight()

func randomize_weights():
	for cell in cells:
		cell.weight = randf_range(0.5, 2)
	update_total_weight()

func update_total_weight():
	total_weight = 0
	for cell in cells:
		total_weight += cell.weight
	#queue_redraw()

# -------------------------------- Drawing --------------------------------

var inner_circle_radius : int = 350
var inner_circle_colour : Color = Color.SADDLE_BROWN
var cell_circle_radius : int = 500
var outer_circle_radius : int = 700
var outer_circle_colour : Color = Color.DARK_RED

var visual_rotation : float = 0;

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 3 + floor(10 * abs(angle_from - angle_to)) 
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

func draw_cells():
	var base_cell_angle = 2 * PI / total_weight
	var cur_angle = 0

	draw_set_transform(Vector2(0, 0), visual_rotation)
	for cell in cells:
		# Actual angle length of the cell
		var cur_cell_angle = base_cell_angle * cell.weight
		# Modifies the draw angle so that the middle of the cell is perfectly vertical
		var draw_angle = -PI / 2
		draw_set_transform(Vector2(0, 0), cur_angle + visual_rotation)
		draw_circle_arc_poly(Vector2(0, 0), cell_circle_radius, draw_angle, draw_angle + cur_cell_angle, cell.colour)
		draw_set_transform(Vector2(0, 0), cur_angle + cur_cell_angle / 2 + visual_rotation)
		
		var text = str(cell.number)
		var font_max_width = sin(cur_cell_angle) * cell_circle_radius
		var font_size = min(48, font_max_width / len(text))
		var position = Vector2(-font_max_width / 2, -cell_circle_radius * 0.95 + font_size / 2)
		draw_string(default_font, position, text, HORIZONTAL_ALIGNMENT_CENTER, font_max_width, font_size)
		cur_angle += cur_cell_angle
		#print(text, " is ", cell.weight/total_weight)

	draw_set_transform(Vector2(0, 0), 0)

func draw_centre():
	draw_circle(Vector2(0, 0), inner_circle_radius, inner_circle_colour)

func draw_edge():
	draw_circle(Vector2(0, 0), outer_circle_radius, outer_circle_colour)

func _draw():
	draw_edge()
	draw_cells()
	draw_centre()
	move_banks()
	#_draw_bank_debug()

# -------------------------------- Physics --------------------------------

var rotation_speed : float = 0;
var outer_wall_segments: int = 128

func build_outer_wall():
	var wall_body = StaticBody2D.new()
	add_child(wall_body)

	for i in range(outer_wall_segments):
		var angle_a = (float(i) / float(outer_wall_segments)) * 2 * PI
		var angle_b = (float(i + 1) / float(outer_wall_segments)) * 2 * PI
 
		var point_a = Vector2(cos(angle_a), sin(angle_a)) * outer_circle_radius
		var point_b = Vector2(cos(angle_b), sin(angle_b)) * outer_circle_radius

		var seg_shape = SegmentShape2D.new()
		seg_shape.a = point_a
		seg_shape.b = point_b
 
		var col = CollisionShape2D.new()
		col.shape = seg_shape
		wall_body.add_child(col)
 
	var visual = Line2D.new()
	visual.width = 20
	visual.closed = true
	visual.default_color = Color.BLACK
	for i in range(outer_wall_segments + 1):
		var angle = (float(i) / float(outer_wall_segments)) * 2 * PI
		visual.add_point(Vector2(cos(angle), sin(angle)) * outer_circle_radius)
	wall_body.add_child(visual)

func decay_rotation():
	if rotation_speed > 0:
		rotation_speed = max(0, min(rotation_speed - 0.000005, rotation_speed * 0.999))
	else:
		rotation_speed = min(0, max(rotation_speed + 0.000005, rotation_speed * 0.999))

func spin_roulette():
	reset_balls()
	rotation_speed = get_random_roulette_rot()
	launch_balls()

func stop_roulette():
	rotation_speed = 0.0

func _ready():
	build_outer_wall()
	build_banks()
	prepare_balls()

func _physics_process(_delta: float):
	match (GameManager.game_state):
		GameEnums.game_states.SPIN_PHASE:
			give_balls_angular_velocity(_delta)
			simulate_inclines(_delta)
			visual_rotation += rotation_speed
			
			decay_rotation()
			queue_redraw()
			if rotation_speed == 0:
				GameManager.game_state = GameEnums.game_states.BET_PHASE
		GameEnums.game_states.BET_PHASE:
			pass
		_:
			pass

func _process(_delta: float) -> void:
	pass

# -------------------------------- Banks --------------------------------

var bank_radius_pos : float = cell_circle_radius * 0.8
var bank_catch_characteristic_speed : float = 100.0
var bank_catch_sharpness : float = 1.5
var bank_trigger_radius : float = 45

func build_banks() -> void:
	var base_cell_angle = 2 * PI / total_weight
	var cur_angle = 0.0

	for cell in cells:
		var cur_cell_angle = base_cell_angle * cell.weight
		var mid_angle = cur_angle + cur_cell_angle / 2 - PI / 2
		var bank_position = Vector2(cos(mid_angle), sin(mid_angle)) * bank_radius_pos

		var bank = RouletteBank.new(cell, cur_cell_angle, bank_position, 90)
		bank.catch_characteristic_speed = bank_catch_characteristic_speed
		bank.catch_sharpness = bank_catch_sharpness
		cell.bank = bank
		add_child(bank)

		cur_angle += cur_cell_angle

func move_banks() -> void:
	for cell in cells:
		if is_instance_valid(cell.bank):
			cell.bank.rotate_around_center(rotation_speed * 1.001)

# -------------------------------- Balls --------------------------------

var balls : Array[RouletteBall] = []

func prepare_balls():
	for i in range(3):
		balls.append(RouletteBall.new())
	for ball in balls:
		ball.position = Vector2(outer_circle_radius - 50, 0)
		add_child(ball)

func reset_balls() -> void:
	var start_position = Vector2(outer_circle_radius - 50, 0)
	for ball in balls:
		if is_instance_valid(ball):
			ball.reset_ball(start_position)

func launch_balls() -> void:
	for ball in balls:
		if ball and is_instance_valid(ball):
			ball.apply_impulse(Vector2(0, 1000 * (-1 * sign(rotation_speed))))

var inner_incline_strength : float = 600
var inner_incline_radius : int = inner_circle_radius
var cell_radius_end : int = cell_circle_radius
var outer_incline_radius : int = bank_radius_pos + bank_trigger_radius
var outer_incline_strength : float = 600

func give_balls_angular_velocity(_delta: float):
	if abs(rotation_speed) < 0.01:
		return
	for ball : RouletteBall in balls:
		var ball_to_mid = ball.position
		if ball_to_mid.length() <= cell_circle_radius - ball.ball_radius:
			ball.apply_central_impulse(-1 * sign(rotation_speed) * ball_to_mid.normalized().orthogonal() * 500 * rotation_speed * _delta)

func simulate_inclines(_delta : float):
	for ball : RouletteBall in balls:
		var ball_to_mid = ball.position
		var ball_rad = ball_to_mid.length()
		
		if ball_rad <= inner_incline_radius + ball.ball_radius:
			ball.apply_central_impulse(ball_to_mid.normalized() * inner_incline_strength * _delta)
		elif ball_rad >= outer_circle_radius - ball.ball_radius:
			ball.apply_central_impulse(-ball_to_mid.normalized() * outer_incline_strength * _delta)
		elif ball_rad >= outer_incline_radius + ball.ball_radius:
			ball.apply_central_impulse(-ball_to_mid.normalized() * 2 * outer_incline_strength * _delta)
