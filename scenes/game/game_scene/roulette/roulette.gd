class_name Roulette
extends Node2D

static func get_random_vector2(size: float) -> Vector2:
	var angle = randf_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)) * size

static func get_random_roulette_rot() -> float:
	var rot = 0.0
	while abs(rot) < 0.03 : rot = randf_range(-0.04, 0.04)
	return rot

# -------------------------------- Initial values --------------------------------

var initial_cell_order : Array[int] = [0, 20, 6, 8, 18, 14, 2, 4, 21, 1, 13, 3, 24, 7, 15, 19, 10, 12, 22, 5, 16, 9, 11, 23, 17]
var initial_cells : Array[RouletteCell]
var reset = true

func get_initial_balls() -> Array[RouletteBall]:
	return [RouletteBall.new()]

func prepare_inital_cells():
	if len(initial_cells) != 0: return
	for i in len(initial_cell_order):
		var curCol = Color.RED
		var num = initial_cell_order[i]
		if i % 2 == 0: curCol = Color.BLACK
		if num == 0: curCol = Color.DARK_GREEN
		initial_cells.append(RouletteCell.new(num, curCol))

var cells : Array[RouletteCell] = []
var default_font : Font = load("res://assets/fonts/PixeloidMono.otf");

# (base_roulette_numbers + 1) includes the green 0
var total_weight : float = 0

func _init():
	prepare_inital_cells()
	cells = initial_cells.duplicate_deep()
	balls = get_initial_balls()
	prepare_balls()

	randomize_weights()
	#cells[0].weight = 10
	update_total_weight()

func _ready():
	build_outer_wall()
	build_banks()
	prepare_textures()
	

func full_reset():
	cells.clear()
	balls.clear()
	for n in get_children():
		if n is RouletteBall or RouletteCell:
			print("Removing ", n)
			remove_child(n)
			n.queue_free()
	cells = initial_cells.duplicate_deep()
	balls = get_initial_balls()
	prepare_balls()

	randomize_weights()
	update_total_weight()
	
	build_outer_wall()
	build_banks()

func randomize_weights():
	for cell in cells:
		cell.weight = randf_range(0.5, 2)
	update_total_weight()

func update_total_weight():
	total_weight = 0
	for cell in cells:
		total_weight += cell.weight

# -------------------------------- Drawing --------------------------------

var inner_circle_radius : int = 350
var inner_circle_colour : Color = Color.SADDLE_BROWN
#var inner_circle_texture : Sprite2D = load("res://assets/textures/test.png")
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
		var pos = Vector2(-font_max_width / 2, -cell_circle_radius * 0.95 + font_size / 2)
		draw_string(default_font, pos, text, HORIZONTAL_ALIGNMENT_CENTER, font_max_width, font_size)
		cur_angle += cur_cell_angle

	draw_set_transform(Vector2(0, 0), 0)

func prepare_textures():
	var scale = Vector2(1, 1) * inner_circle_radius / 75
	print(scale)
	$inner_wheel_sprite.apply_scale(scale)

func draw_centre():
	draw_circle(Vector2(0, 0), inner_circle_radius, inner_circle_colour)

func draw_edge():
	draw_circle(Vector2(0, 0), outer_circle_radius, outer_circle_colour)

func _draw():
	draw_edge()
	draw_cells()
	draw_centre()
	move_banks()

# -------------------------------- Physics --------------------------------

var rotation_speed : float = 0;
var outer_wall_segments: int = 256

func build_outer_wall():
	var wall_body = StaticBody2D.new()
	add_child(wall_body)

	for i in range(outer_wall_segments):
		var angle_a = (float(i) / float(outer_wall_segments)) * 2 * PI
		var angle_b = (float(i + 1) / float(outer_wall_segments)) * 2 * PI
 
		var point_a = Vector2(cos(angle_a), sin(angle_a)) * (outer_circle_radius - RouletteBall.ball_radius)
		var point_b = Vector2(cos(angle_b), sin(angle_b)) * (outer_circle_radius - RouletteBall.ball_radius)

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
	GameManagerGlobal.caughtBalls = 0
	GameManagerGlobal.caughtCells.clear()
	reset_balls()
	for ball in balls: ball.show()
	rotation_speed = get_random_roulette_rot()
	launch_balls()

func stop_roulette():
	rotation_speed = 0.0

var angular_velocity : float
func angular_speed_at_point(point : Vector2) -> float:
	return angular_velocity * point.length()

var settled_frames : int = 0

func _physics_process(_delta: float):
	angular_velocity = rotation_speed / _delta
	#var linear_ang_velocity = cell_circle_radius * angular_velocity
	#print("Angular velocity: ", angular_velocity, ", Linear velocity: ", linear_ang_velocity)
	
	give_balls_angular_velocity(_delta)
	simulate_inclines(_delta)
	decay_rotation()
	rescue_orphaned_balls()
	queue_redraw()
	match (GameManagerGlobal.game_state):
		GameEnums.game_states.SPIN_PHASE:
			reset = true
			visual_rotation += rotation_speed
			$inner_wheel_sprite.rotation += rotation_speed
			if balls.all(func(ball : RouletteBall): return ball.settled): settled_frames += 1
			else: settled_frames = 0
			if settled_frames > 120:
				var temp : Array[RouletteCell] = []
				for ball in balls: temp.append(ball.caught_cell)
				print("Caught: ", temp.map(func(cell): return cell.number))
				GameManagerGlobal.caughtCells = temp
				GameManagerGlobal.modify_game_state(GameEnums.game_states.STOP_PHASE)
			#else:
				#var text = ""
				#for ball in balls:
					#if ball.settled == false:
						#text += str(round(ball.get_speed())) + str(ball.caught_cell != null) + ", "
				#print(text)
		GameEnums.game_states.BET_PHASE:
			#if reset: full_reset()
			if reset: add_ball()
			reset = false
			pass
		_:
			pass

func _process(_delta: float):
	pass

# -------------------------------- Banks --------------------------------

var bank_radius_pos : float = cell_circle_radius * 0.8
var bank_catch_characteristic_speed : float = 100.0
var bank_catch_sharpness : float = 1.5
var bank_trigger_radius : float = 45

func build_banks():
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

func move_banks():
	for cell in cells:
		if is_instance_valid(cell.bank):
			cell.bank.set_total_rotation(visual_rotation)

func rescue_orphaned_balls():
	for ball in balls:
		if ball.settled or ball.get_speed() >= 50:
			continue
		var tracked_somewhere = false
		for cell in cells:
			if is_instance_valid(cell.bank) and cell.bank.is_tracking(ball):
				tracked_somewhere = true
				break
		if tracked_somewhere:
			continue
		for cell in cells:
			if is_instance_valid(cell.bank) and cell.bank.currently_overlaps(ball):
				cell.bank.adopt_ball(ball)
				break

# -------------------------------- Balls --------------------------------

var balls : Array[RouletteBall] = []

func prepare_balls():
	for ball in balls:
		ball.z_index = 2
		ball.hide()
		ball.freeze = true
		add_child(ball)

func add_ball():
	var ball = RouletteBall.new()
	ball.z_index = -2
	ball.hide()
	ball.freeze = true
	add_child(ball)
	balls.append(ball)

func reset_balls():
	for ball in balls:
		if is_instance_valid(ball):
			var start_position = get_random_vector2(outer_circle_radius - 2 * RouletteBall.ball_radius)
			ball.freeze = false
			for cell in cells:
				if is_instance_valid(cell.bank):
					cell.bank.clear_ball(ball)
			ball.reset_ball(start_position)

func launch_balls():
	for ball in balls:
		if ball as RouletteBall:
			ball.z_index = 2
			var normal = Vector2(-ball.init_position.y, ball.init_position.x).normalized()
			ball.launch(normal * 800 * (-1 * sign(rotation_speed)))

var inner_incline_strength : float = 600
var inner_incline_radius : int = inner_circle_radius
var cell_radius_end : int = cell_circle_radius
var cell_bank_incline_strength : float = 100
var outer_incline_radius : int = bank_radius_pos + bank_trigger_radius
var outer_incline_strength : float = 800

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
		if ball_rad <= bank_radius_pos + 2 * ball.ball_radius:
			ball.apply_central_impulse(ball_to_mid.normalized() * cell_bank_incline_strength * _delta)
		elif ball_rad >= outer_circle_radius - ball.ball_radius:
			ball.apply_central_impulse(-ball_to_mid.normalized() * outer_incline_strength * _delta)
		elif ball_rad >= outer_incline_radius + ball.ball_radius:
			ball.apply_central_impulse(-ball_to_mid.normalized() * 2 * outer_incline_strength * _delta)
	
func apply_boost(amount : float):
	for ball : RouletteBall in balls:
		ball.settled = false
		ball.apply_central_impulse(ball.position.rotated(randf_range(-0.1, 0.1)) * amount)
