class_name Roulette
extends Node2D

static func get_random_vector2(size: float) -> Vector2:
	var angle = randf_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)) * size

static func get_random_roulette_rot() -> float:
	var rot = 0.0
	while abs(rot) < 2 : rot = randf_range(-3, 3)
	return rot

# -------------------------------- Sound --------------------------------

@onready var roulette_tick_sound: AudioStreamPlayer = $AudioStreamPlayer
var sound_play_rotation: float = 0.2
var sound_acc_rotation: float = 0

func play_roulette_sound():
	roulette_tick_sound.play()

# -------------------------------- Initial values --------------------------------

var initial_cell_order : Array[int] = [0, 20, 6, 8, 18, 14, 2, 4, 21, 1, 13, 3, 24, 7, 15, 19, 10, 12, 22, 5, 16, 9, 11, 23, 17]
var finished_spin = true
var balls_freeze_time = 60
var balls_freezed = 0

func get_initial_balls() -> Array[RouletteBall]:
	return [RouletteBall.new()]

func prepare_inital_cells():
	if len(GameManagerGlobal.initial_cells) != 0: return
	for i in len(initial_cell_order):
		var curCol = Color.RED
		var num = initial_cell_order[i]
		if i % 2 == 0: curCol = Color.BLACK
		if num == 0: curCol = Color.DARK_GREEN
		GameManagerGlobal.initial_cells.append(RouletteCell.new(num, curCol))

static var cells : Array[RouletteCell]:
	get: return GameManagerGlobal.cells
	set(value): GameManagerGlobal.cells = value

var default_font : Font = load("res://assets/fonts/PixeloidMono.otf");

# (base_roulette_numbers + 1) includes the green 0
var total_weight : float = 0


func _init():
	prepare_inital_cells()
	cells = []
	for cell in GameManagerGlobal.initial_cells:
		cells.append(cell.duplicate())
	balls = get_initial_balls()
	prepare_balls()
	update_total_weight()

func _ready():
	build_outer_wall()
	build_banks()
	prepare_textures()
	GameManagerGlobal.on_boost.connect(apply_boost)
	GameManagerGlobal.signal_game_start.connect(prepare_inital_cells)
	GameManagerGlobal.reset_roulette.connect(full_reset)
	
	GameManagerGlobal.commit_cell_change.connect(commit_cell_mod)
	roulette_tick_sound.stream = load("res://assets/music/RouletteTickSFX.mp3")

func full_reset():
	cells.clear()
	balls.clear()
	for n in get_children():
		if n is RouletteBall or n is RouletteBank:
			remove_child(n)
			n.queue_free()
	for cell in GameManagerGlobal.initial_cells:
		cells.append(cell.duplicate())
	
	balls = get_initial_balls()
	prepare_balls()
	commit_cell_mod()
	GameManagerGlobal.on_boost.connect(apply_boost)

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
var cell_circle_radius : int = 500
var outer_circle_radius : int = 600
var outer_circle_colour : Color = Color.SADDLE_BROWN.blend(Color(0, 0, 0, 0.4))

var visual_rotation : float = 0

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

func rebuild_banks():
	for child in get_children():
		if child is RouletteBank:
			remove_child(child)
	build_banks()

func prepare_textures():
	#$roulette_handle_sprite.apply_scale(Vector2(1, 1) * (inner_circle_radius + 2) / 44)
	$inner_wheel_sprite.apply_scale(Vector2(1, 1) * (inner_circle_radius + 2) / 44.2)
	$roulette_handle_sprite.apply_scale(Vector2(1, 1) * (inner_circle_radius + 2) / 44)

func draw_centre():
	draw_circle(Vector2(0, 0), inner_circle_radius, inner_circle_colour)

func draw_edge():
	draw_circle(Vector2(0, 0), outer_circle_radius, outer_circle_colour)

func _draw():
	draw_edge()
	draw_cells()
	draw_centre()

var cell_size_limit = 0.018
func remove_small_cells():
	var idx_to_remove = cells.find_custom(func(cell): return cell.weight / total_weight < cell_size_limit)
	while idx_to_remove != -1:
		print("Removing cell %s because of size" % cells[idx_to_remove])
		total_weight -= cells[idx_to_remove].weight
		cells.remove_at(idx_to_remove)
		idx_to_remove = cells.find_custom(func(cell): return cell.weight / total_weight < cell_size_limit)


func modify_cell_weight(idx: int, change: float):
	cells[idx].weight += change
	commit_cell_mod()

# Calls the required functions to for a cell.weight change to actually occur
func commit_cell_mod():
	visual_rotation = 0
	update_total_weight()
	remove_small_cells()
	rebuild_banks()

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

var fast_decay : bool = false
func decay_rotation(_delta):
	if fast_decay: _delta *= 10
	if rotation_speed > 0:
		rotation_speed = max(0, min(rotation_speed - 0.05 * _delta, rotation_speed * (1 - 0.1 * _delta)))
	else:
		rotation_speed = min(0, max(rotation_speed + 0.05 * _delta, rotation_speed * (1 - 0.1 * _delta)))

func spin_roulette():
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

func rotate_roulette(_delta : float):
	visual_rotation += rotation_speed * _delta
	$inner_wheel_sprite.rotation += rotation_speed * _delta
	$roulette_handle_sprite.rotation += rotation_speed * _delta
	
	move_banks()

	sound_acc_rotation += abs(rotation_speed) * _delta
	if sound_acc_rotation > sound_play_rotation:
		sound_acc_rotation -= sound_play_rotation
		play_roulette_sound()

func _physics_process(_delta: float):
	angular_velocity = rotation_speed / _delta
	#var linear_ang_velocity = cell_circle_radius * angular_velocity
	#print("Angular velocity: ", angular_velocity, ", Linear velocity: ", linear_ang_velocity)
	
	give_balls_angular_velocity(_delta)
	simulate_inclines(_delta)
	decay_rotation(_delta)
	rescue_orphaned_balls()
	match (GameManagerGlobal.game_state):
		GameEnums.game_states.SPIN_PHASE:
			if finished_spin == false:
				finished_spin = true
				balls_freezed = 0
				show_balls()
				freeze_balls()
			if balls_freezed < balls_freeze_time:
				balls_freezed += 1
				return
			unfreeze_balls()
			rotate_roulette(_delta)
			if balls.all(func(ball : RouletteBall): return ball.settled): settled_frames += 1
			else: settled_frames = 0
			if settled_frames > 120:
				fast_decay = true
			if is_equal_approx(rotation_speed, 0) and settled_frames > 0:
				var temp : Array[RouletteCell] = []
				for ball in balls: temp.append(ball.caught_cell)
				temp.sort_custom(func(a, b): return a.number < b.number)
				print("Caught: ", temp.map(func(cell): return cell.number))
				GameManagerGlobal.caughtCells = temp
				GameManagerGlobal.modify_game_state(GameEnums.game_states.STOP_PHASE)
				fast_decay = false
		GameEnums.game_states.STOP_PHASE:
			if GameManagerGlobal.applying_boost: rotate_roulette(_delta)
		GameEnums.game_states.BET_PHASE:
			if finished_spin:
				hide_balls()
				finished_spin = false
		_:
			pass

func _process(_delta: float):
	queue_redraw()

# -------------------------------- Banks --------------------------------

var bank_radius_pos : float = cell_circle_radius * 0.8
var bank_catch_characteristic_speed : float = 100.0
var bank_catch_sharpness : float = 1.5
var bank_width : float = 90

func build_banks():
	var base_cell_angle = 2 * PI / total_weight
	var cur_angle = 0.0

	for cell in cells:
		var cur_cell_angle = base_cell_angle * cell.weight
		var mid_angle = cur_angle + cur_cell_angle / 2 - PI / 2
		var bank_position = Vector2(cos(mid_angle), sin(mid_angle)) * bank_radius_pos

		var bank = RouletteBank.new(cell, cur_cell_angle, bank_position, bank_width)
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

func hide_balls():
	for ball in balls:
		ball.hide()

func show_balls():
	for ball in balls:
		ball.show()

func freeze_balls():
	for ball in balls:
		ball.freeze = true

func unfreeze_balls():
	for ball in balls:
		ball.freeze = false

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

var inner_incline_strength : float = 800
var inner_incline_radius : int = inner_circle_radius
var cell_radius_end : int = cell_circle_radius
var cell_bank_incline_strength : float = 100
var outer_incline_radius : int = bank_radius_pos + bank_width / 2
var outer_incline_strength : float = 800

func give_balls_angular_velocity(_delta: float):
	if abs(rotation_speed) < 0.01:
		return
	for ball : RouletteBall in balls:
		var ball_to_mid = ball.position
		if ball_to_mid.length() <= cell_circle_radius - ball.ball_radius:
			ball.apply_central_impulse(-1 * sign(rotation_speed) * ball_to_mid.normalized().orthogonal() * rotation_speed * _delta)

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
		elif ball_rad >= outer_incline_radius - ball.ball_radius:
			ball.apply_central_impulse(-ball_to_mid.normalized() * 2 * outer_incline_strength * _delta)

func apply_boost(amount : float):
	print("called apply boost with ", amount)
	rotation_speed = 1.5 * sqrt(amount)
	for ball : RouletteBall in balls:
		ball.settled = false
		ball.apply_central_impulse(-ball.position.rotated(randf_range(-0.3, 0.3)) * 2 * sqrt(amount))
